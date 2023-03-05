vim.cmd([[
" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 0

" set default theme (dark or light)
" By default the theme is define according to the preferences of the system
let g:mkdp_theme = 'light'

" use a custom markdown style must be absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
" let g:mkdp_markdown_css = "~/Documents/script/markdown.css/dest/github/markdown.css"
]])
