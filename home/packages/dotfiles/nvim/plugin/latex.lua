vim.cmd([[

  " Default reader
  let g:livepreview_previewer = 'xreader'

  " Latex compiler
  "let g:livepreview_engine = 'pdflatex' . '-synctex=1 -interaction=nonstopmode -shell-escape'
  
  " Prevent recompiling on cursor hold, on buffer write is still active
  let g:livepreview_cursorhold_recompile = 0
]])
