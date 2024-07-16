let g:floaterm_width = 0.5
let g:floaterm_height = 0.5
let g:floaterm_autoclose = 1
let g:floaterm_wintype = 'vsplit'
let g:floaterm_opener = 'vsplit'
let g:floaterm_autoinsert = v:false

" thanks to u/cdb_11 on reddit :)
" this allows to prevent myself from eagerly closing terminals
augroup Term
  autocmd!
  autocmd TermClose * ++nested stopinsert | au Term TermEnter <buffer> stopinsert
augroup end
