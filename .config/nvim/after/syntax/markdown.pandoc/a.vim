syn region markdownFencedDivInfo matchgroup=markdownFencedDiv start=/\v^\:\:\:+/ end=/$/
hi def link markdownFencedDiv       Statement
hi def link markdownFencedDivInfo   String
