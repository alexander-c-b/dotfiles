syn match markdownFencedDiv /^:::\(:*\)/
syn match markdownFencedDivInfo /\(^:::\)\@<= .*$/

hi def link markdownFencedDiv       Statement
hi def link markdownFencedDivInfo   Constant

" syn match markdownLatexEquation :\v\$[^0-9].{-}\$:
" syn region markdownInlineEquation  start=:\v(\\)@<!\$(\ @!):   end=:\v\$((\ )@>!(\d)@>!):
" syn region markdownDisplayEquation start=:\v(\\)@<!\$\$(\ @!): end=:\v\$\$((\ )@>!(\d)@>!):
" syn match markdownInlineEquation :\v(\\)@<!\$[^0-9\%x20](.{-})[^\\]\$(\ @!|\d@!):

syn region markdownInlineEquation  start=:\v(\\)@<!\$:   end=:\v(\\)@<!\$:
"     \ containedin=
"     \ markdownListItemAtLevel1,
"     \ markdownListItemAtLevel2,
"     \ markdownListItemAtLevel3,
"     \ markdownListItemAtLevel4,
"     \ markdownListItemAtLevel5,
"     \ markdownListItemAtLevel6,
"     \ markdownListItemAtLevel7,
"     \ markdownListItemAtLevel8,
"     \ markdownListItemAtLevel9,
"     \ markdownListItemAtLevel10,
"     \ markdownListItemAtLevel11,
"     \ markdownListItemAtLevel12,
"     \ markdownListItemAtLevel13,
"     \ markdownListItemAtLevel14,
"     \ markdownListItemAtLevel15,
"     \ markdownListItemAtLevel16
" 
syn region markdownDisplayEquation start=:\v(\\)@<!\$\$: end=:\v(\\)@<!\$\$:
"     \ containedin=
"     \ markdownListItemAtLevel1,
"     \ markdownListItemAtLevel2,
"     \ markdownListItemAtLevel3,
"     \ markdownListItemAtLevel4,
"     \ markdownListItemAtLevel5,
"     \ markdownListItemAtLevel6,
"     \ markdownListItemAtLevel7,
"     \ markdownListItemAtLevel8,
"     \ markdownListItemAtLevel9,
"     \ markdownListItemAtLevel10,
"     \ markdownListItemAtLevel11,
"     \ markdownListItemAtLevel12,
"     \ markdownListItemAtLevel13,
"     \ markdownListItemAtLevel14,
"     \ markdownListItemAtLevel15,
"     \ markdownListItemAtLevel16

" syn region markdownLatexEquation start=:\v\$[^0-9]: end=:\v\$: contained
"     \ containedin=
"     \ markdownListItemAtLevel1,
"     \ markdownListItemAtLevel2,
"     \ markdownListItemAtLevel3,
"     \ markdownListItemAtLevel4,
"     \ markdownListItemAtLevel5,
"     \ markdownListItemAtLevel6,
"     \ markdownListItemAtLevel7,
"     \ markdownListItemAtLevel8,
"     \ markdownListItemAtLevel9,
"     \ markdownListItemAtLevel10,
"     \ markdownListItemAtLevel11,
"     \ markdownListItemAtLevel12,
"     \ markdownListItemAtLevel13,
"     \ markdownListItemAtLevel14,
"     \ markdownListItemAtLevel15,
"     \ markdownListItemAtLevel16


" syn region markdownListItemAtLevel contains+=markdownLatexEquation

hi def link markdownInlineEquation  PreProc
hi def link markdownDisplayEquation PreProc
