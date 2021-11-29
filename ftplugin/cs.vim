" Vim filetype plugin file
" Language:            C#
" Maintainer:          Nick Jensen <nickspoon@gmail.com>
" Former Maintainer:   Johannes Zellner <johannes@zellner.org>
" Last Change:         2021-11-30
" License:             Vim (see :h license)
" Repository:          https://github.com/nickspoons/vim-cs

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal formatoptions-=t formatoptions+=croql

" Set 'comments' to format dashed lists in comments.
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,:///,://

let b:undo_ftplugin = 'setl com< fo<'

if (has('gui_win32') || has('gui_gtk')) && !exists('b:browsefilter')
  let b:browsefilter = "C# Source Files (*.cs)\t*.cs\nAll Files (*.*)\t*.*\n"
  let b:undo_ftplugin .= ' | unlet! b:browsefilter'
endif

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim:et:sw=2:sts=2
