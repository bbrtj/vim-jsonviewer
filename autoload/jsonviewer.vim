function! s:getBufferJson(bufid)
	let lines = getbufline(a:bufid, 1, "$")
	let string = join(lines)
	let json = json_decode(string)
	if strlen(string) > g:jsonviewer_optimize
		let b:jsonviewer_optimized = 1
	endif
	return json
endfunction

function! jsonviewer#isOptimized()
	return exists("b:jsonviewer_optimized") && b:jsonviewer_optimized
endfunction

function! jsonviewer#prettyPrint(label, data, level)
	let content = []
	let indent = repeat("\t", a:level)
	let line = indent . a:label . ": "

	let vtype = type(a:data)
	if vtype ==# v:t_list || vtype ==# v:t_dict
		if vtype ==# v:t_list
			let loopdata = map(a:data, {i, val -> [i, val]})
			let bounds = ["[", "]"]
			let name = "Array"
		elseif vtype ==# v:t_dict
			let loopdata = items(a:data)
			let bounds = ["{", "}"]
			let name = "Object"
		endif

		if len(loopdata) == 0
			call add(content, line . bounds[0] . bounds[1])
		else
			call add(content, line . name . " (" . len(loopdata) . ") " . jsonviewer#folding#foldstart_mark() . bounds[0])
			if jsonviewer#isOptimized() && a:level >= 1
				let current = len(b:references)
				call extend(b:references, deepcopy(loopdata))
				call extend(content, map(loopdata, {i, val -> indent . "\t###" . (current + i) . ": ..."}))
			else
				for [ind, value] in loopdata
					call extend(content, jsonviewer#prettyPrint(ind, value, a:level + 1))
				endfor
			endif
			call add(content, indent . jsonviewer#folding#foldend_mark() . bounds[1])
		endif
	elseif vtype ==# v:t_string
		call add(content, line . "`" . a:data . "`")
	elseif vtype ==# v:t_number
		call add(content, line . a:data)
	elseif vtype ==# v:t_float
		call add(content, line . string(a:data))
	elseif vtype ==# v:t_bool
		call add(content, line . (a:data ==# v:true ? "true" : "false"))
	elseif vtype ==# v:t_none
		call add(content, line . "null")
	else
		throw "Error: incorrect datatype in json"
	endif
	return content
endfunction

function! jsonviewer#init()
	try
		let orig_buffer = bufnr("%")
		enew
		let newbuffer = bufnr("%")
		execute "file jsonviewer \\#" . newbuffer
		echom "Loading jsonviewer, please wait..."
		let json = s:getBufferJson(orig_buffer)
		let b:references = []
		let lines = jsonviewer#prettyPrint("root", json, 0)
		call append(0, lines)
		setlocal filetype=jsonviewer
		normal gg
		echom "Loaded " . len(lines) . " lines" .
			\(jsonviewer#isOptimized() ? " (optimized)" : "")
	catch
		execute newbuffer . "bw"
		echoe "Failed initializing jsonviewer " . v:exception
	endtry
endfunction
