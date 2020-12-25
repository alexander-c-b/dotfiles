if exists("g:autoqualified_hsimport_loaded")
    finish
endif

let g:autoqualified_hsimport_loaded = 1

let s:import_path = $HOME . "/scripts/autoqualified-hsimport.lua"

function s:Function() abort
    write
    call system(s:import_path . " " . bufname('%'))
    edit
endfunction

command -nargs=0 HSImport :call s:Function()
