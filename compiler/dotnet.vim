" Vim compiler file
" Compiler:	dotnet build (.NET CLI)
" Maintainer:   Nick Jensen <nickspoon@gmail.com>
" Last Change:	2022 Nov 16

if exists("current_compiler")
  finish
endif
let current_compiler = "dotnet"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

CompilerSet makeprg=dotnet\ build\ -nologo\ -consoleloggerparameters:NoSummary

if get(g:, "dotnet_show_project_file", v:true)
  CompilerSet errorformat=%E%f(%l\\,%c):\ %trror\ %m,
			 \%W%f(%l\\,%c):\ %tarning\ %m,
			 \%-G%.%#
else
  CompilerSet errorformat=%E%f(%l\\,%c):\ %trror\ %m\ [%.%#],
			 \%W%f(%l\\,%c):\ %tarning\ %m\ [%.%#],
			 \%-G%.%#
endif

let &cpo = s:cpo_save
unlet s:cpo_save
