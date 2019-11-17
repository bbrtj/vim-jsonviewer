let s:foldstart_mark = '{{{!!'
function! jsonviewer#folding#foldstart_mark()
	return s:foldstart_mark
endfunction

let s:foldend_mark = '!!}}}'
function! jsonviewer#folding#foldend_mark()
	return s:foldend_mark
endfunction

let s:empty_fold = '{}$\|\[\]$'
let s:foldstart = '[{\[]$'
let s:foldend = '[}\]]$'

function! jsonviewer#folding#foldText()
	let header = getline(v:foldstart)
	let header = substitute(header, '^\t*', repeat(' ', indent(v:foldstart)), "")
	let header = substitute(header, s:foldstart, '', "")
	let header = substitute(header, s:foldstart_mark, '', "")
	return header
endfunction
