setlocal noexpandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2

setlocal fillchars+=fold:\ ,
setlocal buftype=nofile
setlocal nomodifiable
setlocal conceallevel=2
setlocal concealcursor=nvic
setlocal foldlevel=1
setlocal foldopen=search
setlocal foldmarker={{{!!,!!}}}
setlocal nowrap

noremap <buffer> <silent> o :call jsonviewer#lazyload#openFold(line("."))<CR>
noremap <buffer> <silent> <CR> :call jsonviewer#lazyload#openFold(line("."))<CR>
noremap <buffer> <silent> OO :setlocal foldlevel=1<CR>
