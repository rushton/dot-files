" ingobuffer.vim: Custom buffer functions. 
"
" Copyright: (C) 2009 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	004	15-Oct-2009	ENH: ingobuffer#MakeScratchBuffer() now allows
"				to omit (via empty string) the a:scratchCommand
"				Ex command, and will then keep the scratch
"				buffer writable. 
"	003	04-Sep-2009	ENH: If a:scratchIsFile is false and
"				a:scratchDirspec is empty, there will be only
"				one scratch buffer with the same
"				a:scratchFilename, regardless of the scratch
"				buffer's directory path. This also fixes Vim
"				errors on the :file command when s:Bufnr() has
"				determined that there is no existing buffer,
"				when in fact there is. 
"				Replaced ':normal ...dd' with :delete, and not
"				clobbering the unnamed register any more. 
"	002	01-Sep-2009	Added ingobuffer#MakeTempfile(). 
"	001	05-Jan-2009	file creation

function! ingobuffer#CombineToFilespec( dirspec, filename )
    " Use path separator as exemplified by the passed dirspec. 
    let l:pathSeparator = (a:dirspec =~# '\' && a:dirspec !~# '/' ? '\' : '/')
    return a:dirspec . (a:dirspec =~# '^$\|[/\\]$' ? '' : l:pathSeparator) . a:filename
endfunction

function! ingobuffer#MakeTempfile( filename )
    let l:tempdirs = [$TEMP, $TMP]

    if has('dos16') || has('dos32') || has('win95') || has('win32') || has('win64') 
	call extend(l:tempdirs, [$HOMEDRIVE . $HOMEPATH, $WINDIR . '\Temp', 'C:\temp'])
    else
	call extend(l:tempdirs, [$HOME . '/tmp', '/tmp'])
    endif

    for l:tempdir in l:tempdirs
	if filewritable(l:tempdir) == 2
	    return ingobuffer#CombineToFilespec(l:tempdir, a:filename)
	endif
    endfor
    throw 'MakeTempfile: No writable temp directory found!'
endfunction

function! ingobuffer#NextScratchFilename( filespec )
    if a:filespec !~# ' \[\h\+\d*\]$'
	return a:filespec . ' [Scratch]'
    elseif a:filespec !~# ' \[\h\+\d\+\]$'
	return substitute(a:filespec, '\]$', '1]', '')
    else
	let l:number = matchstr(a:filespec, ' \[\h\+\zs\d\+\ze\]$')
	return substitute(a:filespec, '\d\+\]$', (l:number + 1) . ']', '')
    endif
endfunction
function! s:Bufnr( dirspec, filename, isFile )
    if empty(a:dirspec) && ! a:isFile
	" This scratch buffer does not behave like a file and is not tethered to
	" a particular directory; there should be only one scratch buffer with
	" this name in the Vim session. 
	" Do a partial search for the buffer name matching any file name in any
	" directory. 
	return bufnr('/'. escapings#bufnameescape(a:filename, 0) . '$')
    else
	return bufnr(
	\   escapings#bufnameescape(
	\	fnamemodify(
	\	    ingobuffer#CombineToFilespec(a:dirspec, a:filename),
	\	    '%:p'
	\	)
	\   )
	\)
    endif
endfunction
function! s:ChangeDir( dirspec )
    if empty( a:dirspec )
	return
    endif
    execute 'lcd ' . escapings#fnameescape(a:dirspec)
endfunction
function! s:BufType( scratchIsFile )
    return (a:scratchIsFile ? 'nowrite' : 'nofile')
endfunction
function! ingobuffer#MakeScratchBuffer( scratchDirspec, scratchFilename, scratchIsFile, scratchCommand, windowOpenCommand )
"*******************************************************************************
"* PURPOSE:
"   Create (or re-use an existing) scratch buffer (i.e. doesn't correspond to a
"   file on disk, but can be saved as such). 
"   To keep the scratch buffer (and create a new scratch buffer on the next
"   invocation), rename the current scratch buffer via ':file <newname>', or
"   make it a normal buffer via ':setl buftype='. 
"
"* ASSUMPTIONS / PRECONDITIONS:
"   None. 
"* EFFECTS / POSTCONDITIONS:
"   Creates or opens scratch buffer and loads it in a window (as specified by
"   a:windowOpenCommand) and activates that window. 
"* INPUTS:
"   a:scratchDirspec	Local working directory for the scratch buffer
"			(important for :! scratch commands). Pass empty string
"			to maintain the current CWD as-is. Pass '.' to maintain
"			the CWD but also fix it via :lcd. 
"			(Attention: ':set autochdir' will reset any CWD once the
"			current window is left!) Pass the getcwd() output if
"			maintaining the current CWD is important for
"			a:scratchCommand. 
"   a:scratchFilename	The name for the scratch buffer, so it can be saved via
"			either :w! or :w <newname>. 
"   a:scratchIsFile	Flag whether the scratch buffer should behave like a
"			file (i.e. adapt to changes in the global CWD), or not. 
"			If false and a:scratchDirspec is empty, there will be
"			only one scratch buffer with the same a:scratchFilename,
"			regardless of the scratch buffer's directory path. 
"   a:scratchCommand	Ex :read command to populate the scratch buffer. Use
"			:1read so that the first empty line will be kept; it is
"			deleted automatically. Pass empty string if you want to
"			populate the scratch buffer yourself. 
"   a:windowOpenCommand	Ex command to open the scratch window, e.g. :vnew or
"			:topleft new. 
"* RETURN VALUES: 
"   Indicator whether the scratch buffer has been opened: 
"   0	Failed to open scratch buffer. 
"   1	Already in scratch buffer window. 
"   2	Jumped to open scratch buffer window. 
"   3	Loaded existing scratch buffer in new window. 
"   4	Created scratch buffer in new window. 
"*******************************************************************************
    let l:currentWinNr = winnr()
    let l:status = 0

    let l:scratchBufnr = s:Bufnr(a:scratchDirspec, a:scratchFilename, a:scratchIsFile)
    let l:scratchWinnr = bufwinnr(l:scratchBufnr)
"****D echomsg '**** bufnr=' . l:scratchBufnr 'winnr=' . l:scratchWinnr
    if l:scratchWinnr == -1
	if l:scratchBufnr == -1
	    execute a:windowOpenCommand
	    " Note: The directory must already be changed here so that the :file
	    " command can set the correct buffer filespec. 
	    call s:ChangeDir(a:scratchDirspec)
	    execute 'silent keepalt file ' . escapings#fnameescape(a:scratchFilename)
	    let l:status = 4
	elseif getbufvar(l:scratchBufnr, '&buftype') =~# s:BufType(a:scratchIsFile)
	    execute a:windowOpenCommand
	    execute l:scratchBufnr . 'buffer'
	    let l:status = 3
	else
	    " A buffer with the scratch filespec is already loaded, but it
	    " contains an existing file, not a scratch file. As we don't want to
	    " jump to this existing file, try again with the next scratch
	    " filename. 
	    return ingobuffer#MakeScratchBuffer(a:scratchDirspec, ingobuffer#NextScratchFilename(a:scratchFilename), a:scratchIsFile, a:scratchCommand, a:windowOpenCommand)
	endif
    else
	if l:scratchWinnr == l:currentWinNr
	    let l:status = 1
	else
	    execute l:scratchWinnr . 'wincmd w'
	    let l:status = 2
	endif
    endif

    call s:ChangeDir(a:scratchDirspec)
    setlocal noreadonly
    silent %delete _
    " Note: ':silent' to suppress the "--No lines in buffer--" message. 

    if ! empty(a:scratchCommand)
	execute a:scratchCommand
	" ^ Keeps the existing line at the top of the buffer. 
	" v Deletes it. 
	silent 1delete _
	" Note: ':silent' to suppress deletion message if ':set report=0'. 
	
	setlocal readonly
    endif

    execute 'setlocal buftype=' . s:BufType(a:scratchIsFile)
    setlocal bufhidden=wipe nobuflisted noswapfile
    return l:status
endfunction

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
