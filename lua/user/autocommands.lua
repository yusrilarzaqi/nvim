vim.cmd([[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end

  augroup _alpha
    autocmd!
    autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
  augroup end

  " augroup _view
  "   autocmd BufWinLeave *.* mkview
  "   autocmd BufWinEnter *.* silent loadview
  " augroup end

  augroup _markdown
   autocmd!
   autocmd FileType markdown setlocal nonumber
   autocmd FileType markdown setlocal norelativenumber
   autocmd FileType markdown setlocal signcolumn=no
   autocmd FileType markdown setlocal foldcolumn=0
   " autocmd FileType markdown setlocal spell
   " autocmd FileType markdown loadview
  augroup end

]])

-- Autoformat
-- augroup _lsp
--   autocmd!
--   autocmd BufWritePre * lua vim.lsp.buf.formatting()
-- augroup end
-- augroup _markdown
--   autocmd!
--   autocmd FileType markdown setlocal wrap
--   autocmd FileType markdown setlocal spell
-- augroup end

--[[ augroup _highlight
    " gray
    highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
    " blue
    highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
    highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
    " light blue
    highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
    highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
    highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
    " pink
    highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
    highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
    " front
    highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
    highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
    highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
  augroup end ]]
