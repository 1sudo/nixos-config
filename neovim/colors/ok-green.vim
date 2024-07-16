" init

hi clear
syntax reset
let g:colors_name = "ok-green"

" TODO copy wezterm for now

" neovim terminal colors

let g:terminal_color_0  = "#061b12"
let g:terminal_color_1  = "#b786ec"
let g:terminal_color_2  = "#a4c89c"
let g:terminal_color_3  = "#cacd7d"
let g:terminal_color_4  = "#74c6e6"
let g:terminal_color_5  = "#77abef"
let g:terminal_color_6  = "#61d7d6"
let g:terminal_color_7  = "#a3c2b3"

let g:terminal_color_8  = "#a9b7b6"
let g:terminal_color_9  = "#cda2ff"
let g:terminal_color_10 = "#9af583"
let g:terminal_color_11 = "#dee04a"
let g:terminal_color_12 = "#45d0fe"
let g:terminal_color_13 = "#89bcff"
let g:terminal_color_14 = "#22f2f3"
let g:terminal_color_15 = "#a9d2be"

let g:terminal_color_background = "#020b06"
let g:terminal_color_foreground = "#b7e0cd"

" ansi colors
let g:terminal_ansi_colors = [
      \ g:terminal_color_0,
      \ g:terminal_color_1,
      \ g:terminal_color_2,
      \ g:terminal_color_3,
      \ g:terminal_color_4,
      \ g:terminal_color_5,
      \ g:terminal_color_6,
      \ g:terminal_color_7,
      \ g:terminal_color_8,
      \ g:terminal_color_9,
      \ g:terminal_color_10,
      \ g:terminal_color_11,
      \ g:terminal_color_12,
      \ g:terminal_color_13,
      \ g:terminal_color_14,
      \ g:terminal_color_15,
      \ ]

" sorted by the output of :so $VIMRUNTIME/syntax/hitest.vim

" Highlighting function
" Optional variables are attributes and guisp
function! s:hiFn(group, guifg, guibg, ctermfg, ctermbg, ...)
  let l:attr = get(a:, 1, "")
  let l:guisp = get(a:, 2, "")

  " See :help highlight-guifg
  let l:gui_special_names = ["NONE", "bg", "background", "fg", "foreground"]

  if a:guifg != ""
    exec "hi " . a:group . " guifg=" . a:guifg
  endif
  if a:guibg != ""
    exec "hi " . a:group . " guibg=" . a:guibg
  endif
  if a:ctermfg != ""
    exec "hi " . a:group . " ctermfg=" . a:ctermfg
  endif
  if a:ctermbg != ""
    exec "hi " . a:group . " ctermbg=" . a:ctermbg
  endif
  if l:attr != ""
    exec "hi " . a:group . " gui=" . l:attr . " cterm=" . l:attr
  endif
  if l:guisp != ""
    exec "hi " . a:group . " guisp=" . l:guisp
  endif
endfunction


fun <sid>hi(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  call s:hiFn(a:group, a:guifg, a:guibg, a:ctermfg, a:ctermbg, a:attr, a:guisp)
endfun


" groups for various occasions
call <sid>hi("Normal", g:terminal_color_foreground, "", "", "", "", "")

call <sid>hi("SpecialKey", g:terminal_color_foreground, "", "", "", "", "")
call <sid>hi("TermCursor", g:terminal_color_foreground, g:terminal_color_background, "", "", "", "")
call <sid>hi("NonText", g:terminal_color_7, "", "", "", "bold",  "")
call <sid>hi("Directory", g:terminal_color_4, "", "", "", "", "")
call <sid>hi("ErrorMsg", g:terminal_color_1, g:terminal_color_0, "", "", "", "")
" slightly 'stronger' variant of 11: okhsl(110, 0.9, 0.8)
call <sid>hi("IncSearch", g:terminal_color_background, "#cecf25", "", "", "none", "")
call <sid>hi("Search", g:terminal_color_background, g:terminal_color_11, "", "", "", "")
call <sid>hi("MoreMsg", g:terminal_color_2, "", "", "", "bold", "")
call <sid>hi("ModeMsg", g:terminal_color_2, "", "", "", "bold", "")
call <sid>hi("LineNr", g:terminal_color_7, "", "", "", "", "")
call <sid>hi("CursorLineNr", g:terminal_color_7, "", "", "", "bold", "")
call <sid>hi("Question", g:terminal_color_5, "", "", "", "bold", "")
call <sid>hi("StatusLine", g:terminal_color_15, g:terminal_color_0, "", "", "none", "")
call <sid>hi("StatusLineNC", g:terminal_color_7, g:terminal_color_0, "", "", "none", "")
" TODO
call <sid>hi("VertSplit", g:terminal_color_8, g:terminal_color_background, "", "", "none", "")
call <sid>hi("Title", g:terminal_color_6, "", "", "", "none", "")
" bright foreground: increase saturation & lightness okhsl(164, 0.85, 0.95)
" #ccfee6
" bright background: increase saturation & decreae lightness okhsl(167, 0.31,
" 0.28) #2f473d
call <sid>hi("Visual", "#ccfee6", "#2f473d", "", "", "", "")
call <sid>hi("WarningMsg", g:terminal_color_9, g:terminal_color_0, "", "", "", "")
call <sid>hi("WildMenu", g:terminal_color_background, g:terminal_color_foreground, "", "", "", "")
call <sid>hi("Folded", g:terminal_color_7, "bg", "", "", "", "")
call <sid>hi("FoldColumn", g:terminal_color_15, "bg", "", "", "", "")
call <sid>hi("DiffAdd", g:terminal_color_10, "#2f473d", "", "", "", "")
call <sid>hi("DiffChange", g:terminal_color_13, "#2f473d", "", "", "", "")
call <sid>hi("DiffDelete", g:terminal_color_7, "bg", "", "", "bold", "")
call <sid>hi("DiffText", g:terminal_color_12, "#2f473d", "", "", "bold", "")
call <sid>hi("SignColumn", g:terminal_color_7, "bg", "", "", "", "")
call <sid>hi("Conceal", g:terminal_color_foreground, "", "", "", "", "")
call <sid>hi("SpellBad", g:terminal_color_foreground, "", "", "", "", "")
call <sid>hi("SpellCap", g:terminal_color_foreground, "", "", "", "", "")
call <sid>hi("SpellRare", g:terminal_color_foreground, "", "", "", "", "")
call <sid>hi("SpellLocal", g:terminal_color_foreground, "", "", "", "", "")
call <sid>hi("Pmenu", g:terminal_color_15, g:terminal_color_background, "", "", "", "")
call <sid>hi("PmenuSel", g:terminal_color_15, g:terminal_color_0, "", "", "", "")
call <sid>hi("PmenuSbar", g:terminal_color_8, g:terminal_color_0, "", "", "", "")
call <sid>hi("PmenuThumb", g:terminal_color_7, g:terminal_color_0, "", "", "", "")

" cleanup

delf <sid>hi
