" Vim syntax file
" Language:            C#
" Maintainer:          Nick Jensen <nickspoon@gmail.com>
" Former Maintainers:  Anduin Withers <awithers@anduin.com>
"                      Johannes Zellner <johannes@zellner.org>
" Last Change:         2020-11-23
" Filenames:           *.cs
" License:             Vim (see :h license)
" Repository:          https://github.com/nickspoons/vim-cs
"
" References:
"   -   ECMA-334 5th Edition: C# Language Specification
"       https://www.ecma-international.org/publications-and-standards/standards/ecma-334/
"   -   C# Language Design: Draft 6th Edition and later proposals
"       https://github.com/dotnet/csharplang

if exists('b:current_syntax')
  finish
endif

let s:save_cpo = &cpoptions
set cpoptions&vim

syn keyword	csType	bool byte char decimal double float int long object sbyte short string T uint ulong ushort var void dynamic
syn keyword	csType	nint nuint " contextual
syn keyword	csStorage	delegate enum interface namespace struct
syn keyword	csRepeat	break continue do for foreach goto return while
syn keyword	csConditional	else if switch
syn keyword	csLabel	case default
syn match	csOperatorError	display +::+
syn match	csGlobal	display +global::+
" user labels
syn match	csLabel	display +^\s*\I\i*\s*:\%([^:]\)\@=+

" Modifiers
syn keyword	csAccessModifier	internal private protected public
" TODO: in new out
syn keyword	csModifier	abstract const event override readonly sealed static virtual volatile
syn match	csModifier	"\<\%(extern\|unsafe\)\>"
syn match	csModifier	"\<partial\ze\_s\+\%(class\|struct\|interface\|record\|void\)\>"

syn keyword	csException	try catch finally throw when
syn keyword	csLinq	ascending by descending equals from group in into join let on orderby select where

" Async
syn keyword	csAsyncModifier	async
syn keyword	csAsyncOperator	await

syn match	csStorage	"\<extern\ze\s\+alias\>"
syn match	csStorage	"\%(\<extern\s\+\)\@16<=alias\>"

syn match	csStatement	"\<\%(checked\|unchecked\|unsafe\)\ze\_s*{"

syn keyword	csUnspecifiedStatement	as base fixed in is lock nameof operator out params ref sizeof stackalloc this using
syn keyword	csUnsupportedStatement	value
syn keyword	csUnspecifiedKeyword	explicit implicit

" Contextual Keywords
syn match	csContextualStatement	"\<yield\ze\_s\+\%(return\|break\)\>"
syn match	csContextualStatement	"\<\%(get\|set\|init\|add\|remove\)\ze\_s*\%([;{]\|=>\)"
syn match	csContextualStatement	"\<where\>\ze[^:]\+:"

" Operators
syn keyword	csTypeOf	typeof nextgroup=csTypeOfOperand,csTypeOfError skipwhite skipempty
syn region	csTypeOfOperand	matchgroup=csParens start="(" end=")" contained contains=csType
syn match       csTypeOfError               "[^([:space:]]" contained
syn match	csKeywordOperator	"\<\%(checked\|unchecked\)\ze\_s*("

" Punctuation
syn match	csBraces	"[{}\[\]]" display
syn match	csParens	"[()]" display
syn match	csOpSymbols	"+\{1,2}" display
syn match	csOpSymbols	"-\{1,2}" display
syn match	csOpSymbols	"=\{1,2}" display
syn match	csOpSymbols	">\{1,2}" display
syn match	csOpSymbols	"<\{1,2}" display
syn match	csOpSymbols	"[!><+\-*/]=" display
syn match	csOpSymbols	"[!*/^]" display
syn match	csOpSymbols	"=>" display
syn match	csEndColon	";" display
syn match	csLogicSymbols	"&&" display
syn match	csLogicSymbols	"||" display
syn match	csLogicSymbols	"?" display
syn match	csLogicSymbols	":" display

" Generics
syn region	csGeneric	matchgroup=csGenericBraces start="<" end=">" oneline contains=csType,csGeneric,csUserType,csUserIdentifier,csUserInterface,csUserMethod

" Comments
"
" PROVIDES: @csCommentHook
syn keyword	csTodo	contained TODO FIXME XXX NOTE HACK TBD
syn region	csBlockComment	start="/\*"  end="\*/" contains=@csCommentHook,csTodo,@Spell
syn match	csLineComment	"//.*$" contains=@csCommentHook,csTodo,@Spell
syn cluster	csComment	contains=csLineComment,csBlockComment

" xml markup inside '///' and /**...*/ comments
syn cluster	xmlRegionHook	add=csXmlLineCommentLeader,csXmlBlockCommentMiddle
syn cluster	xmlCdataHook	add=csXmlLineCommentLeader,csXmlBlockCommentMiddle
syn cluster	xmlStartTagHook	add=csXmlLineCommentLeader,csXmlBlockCommentMiddle
syn cluster	xmlTagHook	add=csXmlTag
syn cluster	xmlAttribHook	add=csXmlAttrib

" https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/xmldoc/recommended-tags
syn keyword	csXmlTag	contained summary remarks
syn keyword	csXmlTag	contained returns param paramref exception value
syn keyword	csXmlTag	contained para list c code example
syn keyword	csXmlTag	contained inheritdoc include
syn keyword	csXmlTag	contained see seealso
syn keyword	csXmlTag	contained typeparam typeparamref
syn keyword	csXmlTag	contained b i u br a
syn keyword	csXmlAttrib	contained cref href

syn match	csXmlLineCommentLeader	"///" contained
syn match	csXmlLineComment	"///.*$" contains=csXmlLineCommentLeader,@csXml,@Spell keepend
syn match	csXmlBlockCommentMiddle	"^\s*\zs\*" contained
syn region	csXmlBlockComment	start="/\*\*" end="\*/" contains=@csXml,@Spell,csXmlBlockCommentMiddle keepend
syn include	@csXml syntax/xml.vim
hi def link	xmlRegion Comment

" Since syntax/xml.vim contains `syn spell toplevel`, we need to set it back to `default` here.
syn spell default

" Pre-processing directives
syn region	csPreProcDeclaration	start="^\s*\zs#\s*\%(define\|undef\)\>" end="$" contains=csLineComment keepend
syn region	csPreProcConditional	start="^\s*\zs#\s*\%(if\|elif\)\>" end="$" contains=csLineComment keepend
syn region	csPreProcConditional	start="^\s*\zs#\s*\%(else\|endif\)\>" end="$" contains=csLineComment keepend
syn region	csPreProcLine	start="^\s*\zs#\s*line\>" end="$" contains=csLineComment keepend
syn region	csPreProcDiagnostic	start="^\s*\zs#\s*\%(error\|warning\)\>" end="$"
syn region	csPreProcConditionalSection	matchgroup=csPreProcRegion start="^\s*#\s*region\>.*" end="^\s*#\s*endregion\>.*" transparent fold contains=TOP
syn region	csPreProcPragma	start="^\s*\zs#\s*pragma\>" end="$" contains=csLineComment keepend
syn region	csPreProcNullable	start="^\s*\zs#\s*nullable\>" end="$" contains=csLineComment keepend

syn region	csSummary	start="^\s*/// <summary" end="^\%\(\s*///\)\@!" transparent fold keepend


syn region	csClassType	start="\<class\>"hs=s+6 end="[:\n{]"me=e-1 contains=csClass
" csUserType may be defined by user scripts/plugins - it should be contained in csNewType
syn region	csNewType	start="\<new\>"hs=s+4 end="[;\n{(<\[]"me=e-1 contains=csNew,csUserType
syn region	csIsType	start=" is "hs=s+4 end="[A-Za-z0-9]\+" oneline contains=csIsAs
syn region	csIsType	start=" as "hs=s+4 end="[A-Za-z0-9]\+" oneline contains=csIsAs
syn keyword	csNew	new contained
syn keyword	csClass	class contained
syn keyword	csIsAs	is as

syn keyword	csBoolean	false true
syn keyword	csConstant	null

" Strings and constants
syn match	csSpecialError	"\\." contained
syn match	csSpecialCharError	"[^']" contained
" Character literals
syn match	csSpecialChar	+\\["\\'0abfnrtv]+ contained display
syn match	csUnicodeNumber	+\\x\x\{1,4}+ contained contains=csUnicodeSpecifier display
syn match	csUnicodeNumber	+\\u\x\{4}+ contained contains=csUnicodeSpecifier display
syn match	csUnicodeNumber	+\\U00\x\{6}+ contained contains=csUnicodeSpecifier display
syn match	csUnicodeSpecifier	+\\[uUx]+ contained display

syn region	csString	matchgroup=csQuote start=+"+  end=+"+ end=+$+ extend contains=csSpecialChar,csSpecialError,csUnicodeNumber,@Spell
syn match	csCharacter	"'[^']*'" contains=csSpecialChar,csSpecialCharError,csUnicodeNumber display
syn match	csCharacter	"'\\''" contains=csSpecialChar display
syn match	csCharacter	"'[^\\]'" display

" Numbers
syn case	ignore
syn match	csInteger	"\<0b[01_]*[01]\%([lu]\|lu\|ul\)\=\>" display
syn match	csInteger	"\<\d\+\%(_\+\d\+\)*\%([lu]\|lu\|ul\)\=\>" display
syn match	csInteger	"\<0x[[:xdigit:]_]*\x\%([lu]\|lu\|ul\)\=\>" display
syn match	csReal	"\<\d\+\%(_\+\d\+\)*\.\d\+\%(_\+\d\+\)*\%\(e[-+]\=\d\+\%(_\+\d\+\)*\)\=[fdm]\=" display
syn match	csReal	"\.\d\+\%(_\+\d\+\)*\%(e[-+]\=\d\+\%(_\+\d\+\)*\)\=[fdm]\=\>" display
syn match	csReal	"\<\d\+\%(_\+\d\+\)*e[-+]\=\d\+\%(_\+\d\+\)*[fdm]\=\>" display
syn match	csReal	"\<\d\+\%(_\+\d\+\)*[fdm]\>" display
syn case	match
syn cluster     csNumber	contains=csInteger,csReal

syn region	csInterpolatedString	matchgroup=csQuote start=+\$"+ end=+"+ extend contains=csInterpolation,csEscapedInterpolation,csSpecialChar,csSpecialError,csUnicodeNumber,@Spell

syn region	csInterpolation	matchgroup=csInterpolationDelimiter start=+{+ end=+}+ keepend contained contains=@csAll,csBraced,csBracketed,csInterpolationAlign,csInterpolationFormat
syn match	csEscapedInterpolation	"{{" transparent contains=NONE display
syn match	csEscapedInterpolation	"}}" transparent contains=NONE display
syn region	csInterpolationAlign	matchgroup=csInterpolationAlignDel start=+,+ end=+}+ end=+:+me=e-1 contained contains=@csNumber,csBoolean,csConstant,csCharacter,csParens,csOpSymbols,csString,csBracketed display
syn match	csInterpolationFormat	+:[^}]\+}+ contained contains=csInterpolationFormatDel display
syn match	csInterpolationAlignDel	+,+ contained display
syn match	csInterpolationFormatDel	+:+ contained display

syn region	csVerbatimString	matchgroup=csQuote start=+@"+ end=+"+ skip=+""+ extend contains=csVerbatimQuote,@Spell
syn match	csVerbatimQuote	+""+ contained

syn region	csInterVerbString	matchgroup=csQuote start=+$@"+ start=+@$"+ end=+"+ skip=+""+ extend contains=csInterpolation,csEscapedInterpolation,csSpecialChar,csSpecialError,csUnicodeNumber,csVerbatimQuote,@Spell

syn region	csBracketed	matchgroup=csParens start=+(+ end=+)+ extend contained transparent contains=@csAll,csBraced,csBracketed
syn region	csBraced	matchgroup=csParens start=+{+ end=+}+ extend contained transparent contains=@csAll,csBraced,csBracketed

syn cluster	csAll	contains=csCharacter,csClassType,@csComment,csContextualStatement,csEndColon,csIsType,csLabel,csLogicSymbols,csNewType,csBoolean,csConstant,@csNumber,csOpSymbols,csOperatorError,csParens,csPreCondit,csRegion,csString,csSummary,csType,csUnicodeNumber,csUnicodeSpecifier,csInterpolatedString,csVerbatimString,csInterVerbString,csUserType,csUserIdentifier,csUserInterface,csUserMethod

" Keyword identifiers
syn match csIdentifier "@\h\w*"

" The default highlighting.
hi def link	csType	Type
hi def link	csClassType	Type
hi def link	csIsType	Type
hi def link	csStorage	Structure
hi def link	csClass	Structure
hi def link	csRepeat	Repeat
hi def link	csConditional	Conditional
hi def link	csLabel	Label
hi def link	csModifier	StorageClass
hi def link	csAccessModifier	csModifier
hi def link	csConstant	Constant
hi def link	csException	Exception
hi def link	csUnspecifiedStatement	Statement
hi def link	csUnsupportedStatement	Statement
hi def link	csUnspecifiedKeyword	Keyword
hi def link	csNew	Statement
hi def link	csLinq	Statement
hi def link	csIsAs 	Keyword
hi def link	csAsyncModifier	csModifier
hi def link	csContextualStatement	Statement

hi def link	csTodo	Todo
hi def link	csComment	Comment
hi def link	csLineComment	csComment
hi def link	csBlockComment	csComment

hi def link	csKeywordOperator	Keyword
hi def link	csAsyncOperator	csKeywordOperator
hi def link	csTypeOf	csKeywordOperator
hi def link	csTypeOfOperand	Typedef
hi def link	csTypeOfError	Error
hi def link	csOpSymbols	Operator
hi def link	csLogicSymbols	Operator
hi def link	csOperatorError	Error

hi def link	csSpecialError	Error
hi def link	csSpecialCharError	Error
hi def link	csString	String
hi def link	csQuote	String
hi def link	csInterpolatedString	String
hi def link	csVerbatimString	String
hi def link	csInterVerbString	String
hi def link	csVerbatimQuote	SpecialChar

hi def link     csPreProc	PreProc
hi def link	csPreProcDeclaration	Define
hi def link	csPreProcConditional	PreCondit
hi def link	csPreProcLine	csPreProc
hi def link	csPreProcDiagnostic	csPreProc
hi def link	csPreProcRegion	csPreProc
hi def link	csPreProcPragma	csPreProc
hi def link	csPreProcNullable	csPreProc

hi def link	csBoolean	Boolean
hi def link	csCharacter	Character
hi def link	csSpecialChar	SpecialChar
hi def link	csInteger	Number
hi def link	csReal	Float
hi def link	csUnicodeNumber	SpecialChar
hi def link	csUnicodeSpecifier	SpecialChar
hi def link	csInterpolationDelimiter	Delimiter
hi def link	csInterpolationAlignDel	csInterpolationDelimiter
hi def link	csInterpolationFormat	csInterpolationDelimiter
hi def link	csInterpolationFormatDel	csInterpolationDelimiter

hi def link	csGenericBraces	csBraces

" xml markup
hi def link	csXmlLineCommentLeader	Comment
hi def link	csXmlLineComment	Comment
hi def link	csXmlBlockComment	Comment
hi def link	csXmlBlockCommentMiddle	csXmlBlockComment
hi def link	csXmlTag	Statement
hi def link	csXmlAttrib	Statement

let b:current_syntax = 'cs'

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim: vts=16,28
