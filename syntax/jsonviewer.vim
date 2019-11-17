if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syn region viewerString start='`' end='`$'

syn keyword viewerTrue true
syn keyword viewerFalse false
syn keyword viewerNull null
syn keyword viewerObject Object
syn keyword viewerArray Array

syn match viewerNumber "\(\s\|^\)\@<=[0-9]\+\(\.[0-9]\+\)\?\(\s\|$\)\@="
syn match viewerIndex '^\s*.\+:'
syn match viewerFoldMark '{{{!!\|!!}}}' conceal

hi link viewerIndex Function
hi link viewerNumber Number
hi link viewerString String
hi link viewerTrue Constant
hi link viewerFalse Constant
hi link viewerNull Constant
hi link viewerObject Keyword
hi link viewerArray Keyword
hi! link Folded Special

" Syntax folding not working properly - need a match in a line before the fold
" syn region viewerDict start="{" end="}" fold transparent
" syn region viewerArray start="\[" end="\]" fold transparent
" syn sync match viewerDictSync groupthere viewerDict '\s*.\+:\s*Object'
" syn sync match viewerDictSyncNone groupthere NONE '}'
" syn sync match viewerArraySync groupthere viewerArray '^\s*.\+:\s*Array'
" syn sync match viewerArraySyncNone groupthere NONE '\]'

setlocal foldmethod=marker
setlocal foldtext=jsonviewer#folding#foldText()

let b:current_syntax = "jsonviewer"
