lua << EOF
require('neorg').setup {
  load = {
    ["core.defaults"] = {},
    ["core.norg.dirman"] = {
      config = {
        workspaces = {
          private = "~/neorg",
          },
        index = "index.norg",
        autochdir = true,
        default_workspace = "private",
        }
      },
    ["core.gtd.base"] = {
      config = {
        workspace = "private",
        }
      },
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp",
        },
      },
    ["core.norg.concealer"] = {
      config = {
        },
      },
    ["core.norg.journal"] = {
      config = {
        journal_folder = "journal",
        strategy = "nested",
        },
      },
    ["core.norg.qol.toc"] = {
      config = {
        },
      },
    },
  }
EOF
