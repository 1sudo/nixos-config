set tabstop=4 " length of \t

set softtabstop=-1 " length when editing text (0 = tabstop, -1 = shiftwidth)

set shiftwidth=0 " length for shifting text (0 = tabstop)

set shiftround " round to multiples

set autoindent " reuse indent for new lines

set cpoptions+=I " keep indentation after leaving a line blank

" keep spaces as default for now
" (since most of my stuff implicitly assumes this configuration),
" and configure for each 'project' explicitly
" in the future (new/reformatted)
" (via .editorconfig).
" Keep `:retab!` in mind for reformatting files :)
set expandtab " use spaces instead of tabs

filetype plugin indent on " use language specific settings

set list

set listchars=eol:↩,tab:⏽\ ⏵,multispace:•∘,lead:‐,leadmultispace:‐∘,trail:✦,nbsp:⁋
