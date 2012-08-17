fun! CheckPHPSyntax()
  let clean = system("/usr/bin/php -l ". expand("%"))
  let test  = substitute(clean, "\.\\+ line \\([0-9]\\+\\)\\s*\.\\+", "\\1", "gis")
  if(test != clean)
    echohl ErrorMsg | ec clean | echohl None
    echo "Would you like to move to the line?"
    let choice = nr2char(getchar())
    if choice == 'y' || choice == "\<CR>"
      call cursor(test, 0)
    else
    endif
  endif
endfun

"automatically check syntax on save of the file WOOT!
"autocmd BufWritePost *.php :!/usr/bin/php -l % 
autocmd FileType php autocmd BufWritePost <buffer> :call CheckPHPSyntax()
" CTRL+L checks syntax on the file
"autocmd FileType php noremap  :!/usr/bin/php -l % 
autocmd FileType php noremap  :call CheckPHPSyntax() 
