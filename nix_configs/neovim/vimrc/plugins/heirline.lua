local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local colors = {
  bright_bg = utils.get_highlight("Folded").bg,
  bright_fg = utils.get_highlight("Folded").fg,
  red = utils.get_highlight("DiagnosticError").fg,
  dark_red = utils.get_highlight("DiffDelete").bg,
  green = utils.get_highlight("String").fg,
  blue = utils.get_highlight("Function").fg,
  gray = utils.get_highlight("NonText").fg,
  orange = utils.get_highlight("Constant").fg,
  purple = utils.get_highlight("Statement").fg,
  cyan = utils.get_highlight("Special").fg,
  diag_warn = utils.get_highlight("DiagnosticWarn").fg,
  diag_error = utils.get_highlight("DiagnosticError").fg,
  diag_hint = utils.get_highlight("DiagnosticHint").fg,
  diag_info = utils.get_highlight("DiagnosticInfo").fg,
  git_del = utils.get_highlight("diffDeleted").fg,
  git_add = utils.get_highlight("diffAdded").fg,
  git_change = utils.get_highlight("diffChanged").fg,
}

local ViMode = {
  -- get vim current mode, this information will be required by the provider
  -- and the highlight functions, so we compute it only once per component
  -- evaluation and store it as a component attribute
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()
  end,
  -- Now we define some dictionaries to map the output of mode() to the
  -- corresponding string and color. We can put these into `static` to compute
  -- them at initialisation time.
  static = {
    mode_names = { -- change the strings if you like it vvvvverbose!
      n = "Normal",
      no = "Normal?",
      nov = "Visual?",
      noV = "Line?",
      ["no\22"] = "Block?",
      niI = "Insert (Normal)",
      niR = "Replace (Normal)",
      niV = "VReplace (Normal)",
      nt = "Terminal (Normal)",
      v = "Visual",
      vs = "Select (Visual)",
      V = "VLine",
      Vs = "Select (VLine)",
      ["\22"] = "Block",
      ["\22s"] = "Select (Block)",
      s = "Select",
      S = "SLine",
      ["\19"] = "SBlock",
      i = "Insert",
      ic = "Insert (Compl)",
      -- line completion
      ix = "Insert (LCompl)",
      R = "Replace",
      Rc = "Replace (Compl)",
      Rx = "Replace (LCompl)",
      -- virtual replace
      Rv = "VReplace",
      Rvc = "VReplace (Compl)",
      Rvx = "VReplace (LCompl)",
      c = "Command",
      cv = "Ex",
      r = "...",
      rm = "More",
      ["r?"] = "Confirm?",
      ["!"] = "External!",
      t = "Terminal",
    },
    mode_colors = {
      n = "blue" ,
      i = "green",
      v = "cyan",
      V =  "cyan",
      ["\22"] =  "cyan",
      c =  "orange",
      s =  "purple",
      S =  "purple",
      ["\19"] =  "purple",
      R =  "orange",
      r =  "orange",
      ["!"] =  "red",
      t =  "red",
    }
  },
  provider = function(self)
    local mode_name = self.mode_names[self.mode] or
      "?"..self.mode_names[self.mode:sub(1, 1)]
    return "%2("..mode_name.."%)"
  end,
  -- Same goes for the highlight. Now the foreground will change according to the current mode.
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = self.mode_colors[mode], bold = true, }
  end,
  -- Re-evaluate the component only on ModeChanged event!
  -- Also allows the statusline to be re-evaluated when entering operator-pending mode
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  },
}

local FileNameBlock = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,
}

local FileIcon = {
    init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self)
        return self.icon and (self.icon .. " ")
    end,
    hl = function(self)
        return { fg = self.icon_color }
    end
}

local FileName = {
    provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        local filename = vim.fn.fnamemodify(self.filename, ":p:~:.")
        if filename == "" then return "[No Name]" end
        -- now, if the filename would occupy more than 1/4th of the available
        -- space, we trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        -- TODO: do this dynamically, at least depending on the location
        -- (i.e. tabline/winbar/statusline)
        if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
        end
        return filename
    end,
    hl = { fg = utils.get_highlight("Directory").fg },
}

local FileFlags = {
    {
        condition = function()
            return vim.bo.modified
        end,
        provider = "[+]",
        hl = { fg = "green" },
    },
    {
        condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = "",
        hl = { fg = "orange" },
    },
}

local FileNameModifer = {
    hl = function()
        if vim.bo.modified then
            -- use `force` because we need to override the child's hl foreground
            return { fg = "cyan", bold = true, force=true }
        end
    end,
}

FileNameBlock = utils.insert(FileNameBlock,
    FileIcon,
    utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
    FileFlags,
    { provider = '%<'} -- this means that the statusline is cut here when there's not enough space
)

local FileType = {
    provider = function()
        return vim.bo.filetype
    end,
}

local FileEncoding = {
    provider = function()
        local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc -- :h 'enc'
        return enc ~= 'utf-8' and (" " .. enc .. " ")
    end
}

local FileFormat = {
    provider = function()
        local fmt = vim.bo.fileformat
        local icon = vim.api.nvim_call_function("WebDevIconsGetFileFormatSymbol", {})
        return icon or fmt
    end
}

local Ruler = {
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    -- %P = percentage through file of displayed window
    provider = "%p%% %l/%L %c",
}

local ScrollBar ={
    static = {
        sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
    },
    provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
        return string.rep(self.sbar[i], 2)
    end,
    -- had: bg: bright_bg; but that errors for some reason
    hl = { fg = "blue", },
}

local LSPIsActive = {
  condition = conditions.lsp_attached,
  update = {'LspAttach', 'LspDetach'},
  provider = "󰒓 [LSP]",
}

local LSPActiveList = {
    condition = conditions.lsp_attached,
    update = {'LspAttach', 'LspDetach'},

    -- You can keep it simple,
    -- provider = " [LSP]",

    -- Or complicate things a bit and get the servers names
    provider  = function()
        local names = {}
        for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            table.insert(names, server.name)
        end
        return "󰣖 [" .. table.concat(names, " ") .. "]"
    end,
    hl = { fg = "green", bold = true },
}

local DiagnosticsExist = {

    condition = conditions.has_diagnostics,

    static = {
        error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
        warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
        info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
        hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
    },

    init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,

    update = { "DiagnosticChanged", "BufEnter" },

    {
        provider = "![",
    },
    {
        provider = function(self)
            return self.errors > 0 and self.error_icon
        end,
        hl = { fg = "diag_error" },
    },
    {
        provider = function(self)
            return self.warnings > 0 and self.warn_icon
        end,
        hl = { fg = "diag_warn" },
    },
    {
        provider = function(self)
            return self.info > 0 and self.info_icon
        end,
        hl = { fg = "diag_info" },
    },
    {
        provider = function(self)
            return self.hints > 0 and self.hint_icon
        end,
        hl = { fg = "diag_hint" },
    },
    {
        provider = "]",
    },
}

-- TODO: refactor into a single thing
local DiagnosticsCount = {

    condition = conditions.has_diagnostics,

    static = {
        error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
        warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
        info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
        hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
    },

    init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,

    update = { "DiagnosticChanged", "BufEnter" },

    {
        provider = "![",
    },
    {
        provider = function(self)
            return (self.error_icon .. self.errors)
        end,
        hl = { fg = "diag_error" },
    },
    {
        provider = function(self)
            return (self.warn_icon .. self.warnings)
        end,
        hl = { fg = "diag_warn" },
    },
    {
        provider = function(self)
            return (self.info_icon .. self.info)
        end,
        hl = { fg = "diag_info" },
    },
    {
        provider = function(self)
            return (self.hint_icon .. self.hints)
        end,
        hl = { fg = "diag_hint" },
    },
    {
        provider = "]",
    },
}

local GitBranch = {
    condition = conditions.is_git_repo,

    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,

    hl = { fg = "orange" },

    {   -- git branch name
        provider = function(self)
            return " " .. self.status_dict.head
        end,
        hl = { bold = true }
    },
}

local GitHasChanges = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  hl = { fg = "orange" },

  {
    condition = function(self)
      return self.has_changes
    end,
    provider = " ",
  }
}

local GitChanges = {
    condition = conditions.is_git_repo,

    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,

    hl = { fg = "orange" },

    {
        condition = function(self)
            return self.has_changes
        end,
        provider = "("
    },
    {
        provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("+" .. count)
        end,
        -- was git_add, but that doesn't work for some reason
        hl = { fg = "green" },
    },
    {
        provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("-" .. count)
        end,
        -- same here, git_del
        hl = { fg = "orange" },
    },
    {
        provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("~" .. count)
        end,
        -- same here, git_change
        hl = { fg = "purple" },
    },
    {
        condition = function(self)
            return self.has_changes
        end,
        provider = ")",
    },
}

local Spell = {
    condition = function()
        return vim.wo.spell
    end,
    provider = '󰓆 ',
    hl = { bold = true, fg = "cyan"}
}

local SearchCount = {
    condition = function()
        -- had ` and vim.o.cmdheight == 0` but this breaks it
        return vim.v.hlsearch ~= 0
    end,
    init = function(self)
        local ok, search = pcall(vim.fn.searchcount)
        if ok and search.total then
            self.search = search
        end
    end,
    provider = function(self)
        local search = self.search
        return string.format("/%s…[%d/%d]", vim.fn.getreg("/"):sub(1, 7), search.current, math.min(search.total, search.maxcount))
    end,
}

-- for all files: unsaved/saved, readonly state
--
-- tabline:
-- open files + ft icon
-- overall running lsps?
--
-- winbar:
-- [x] path
-- [x] ft icon
-- [x] lsp (icon?)
-- ~~[ ] total lines?~~
-- [x] scrollbar (top/botom of file)
-- [x] number of diagnostics? / diagnostic status
-- [x] git lines changed/deleted/added
--
-- statusline:
-- [x] column, 'progress' (XX% of lines, line Y/Z)
-- [x] filetype, attached lsps
-- [x] line-endings (\r\n, \r, \n), encoding
-- different indent, trailing whitespace
-- [x] number of diagnostics
-- [x] file name/location
-- [ ] lsp messages? TODO
-- [x] search (term, item y/z)
-- [ ] number of words
-- [x] spell check indicator
-- [x] git branch
-- [ ] indentation mismatch, trailing whitespace

-- utility:
local Align = { provider = "%=" }
local Space = { provider = " " }

-- bottom, global
local StatusLine = {
  -- global info
  -- vim specific
  ViMode,
  Spell,
  SearchCount,

  Space,

  -- other
  GitBranch,

  Align,

  -- buffer specific
  -- file metadata
  FileNameBlock,
  FileEncoding,
  FileFormat,
  FileType,

  -- buffer metadata
  -- *-vcs
  GitChanges,

  -- *-lsp
  LSPActiveList,
  DiagnosticsCount,

  Space,

  -- *-common
  ScrollBar,
  Ruler,
}

-- top of each window
local WinBar = {
  ScrollBar,
  FileNameBlock,

  Align,

  LSPIsActive,
  DiagnosticsExist,
  GitHasChanges,
}

-- top, global
-- TODO
local TabLine = {
}

-- show only global statusline at the bottom
-- (winbar is used at the top of each window for info that is relevant
-- indepent of focus)
vim.opt.laststatus = 3
require("heirline").setup({
    statusline = StatusLine,
    winbar = WinBar,
    tabline = TabLine,
    statuscolumn = nil,
    opts = {
      colors = colors,
    },
  })
