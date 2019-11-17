let s:lazyload_mark = '^\s*###[0-9]\+: \.\.\.$'

function! jsonviewer#lazyload#getFoldLines(foldstart, foldend)
	let items = []
	let indent = indent(a:foldstart) + &sw
	let lnum = a:foldstart + 1

	while lnum < a:foldend
		if indent(lnum) == indent
			let line = getline(lnum)
			if line =~ '^\s*.\+:'
				call add(items, [lnum, line])
			endif
		endif
		let lnum += 1
	endwhile

	return items
endfunction

function! s:load(line)
	let ind = matchstr(a:line, '[0-9]\+')
	let bufferobj = get(b:references, ind, ["ERROR", "An error occured while autoloading item #" . ind])
	let content = jsonviewer#prettyPrint(bufferobj[0], bufferobj[1], 0)
	return content
endfunction

function! jsonviewer#lazyload#openFold(lnum)
	let start = foldclosed(a:lnum)
	if start > -1
		let end = foldclosedend(a:lnum)
		normal za
		let view = winsaveview()
		setlocal modifiable
		let lines = jsonviewer#lazyload#getFoldLines(start, end)
		for [lnum, line] in reverse(lines)
			let indent = matchstr(line, '^\s*')
			if line =~# s:lazyload_mark
				let newlines = s:load(line)
				if len(newlines)
					let newlines = map(newlines, {i, val -> indent . val})
					execute lnum . "delete _"
					call append(lnum - 1, newlines)
					let filtered = filter(map(newlines,
						\{i, val -> [i + lnum, val]}),
						\{i, val -> val[1] =~ jsonviewer#folding#foldstart_mark()}
					\)
					for [lnum_fix, line_fix] in reverse(filtered)
						execute lnum_fix . "foldc"
					endfor
				endif
			endif
		endfor
		setlocal nomodifiable
		call winrestview(view)
	elseif foldlevel(a:lnum) > 0
		normal za
	endif
endfunction
