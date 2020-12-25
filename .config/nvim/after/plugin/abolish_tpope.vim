function AbolishCmds() abort
    Abolish {teh,hte,het,eth,eht,th,te} the
    iabbrev THe The
    Abolish fo of
    Abolish ot to
    Abolish {htis,thsi} this
    Abolish htese these
    Abolish {htat,thta} that
    Abolish {htos,htose} those
    Abolish {norht} north
    Abolish na an
    Abolish {nad,adn} and
    Abolish {strenght} strength
    Abolish {ofr,fro} for

    Abolish govt{,s} government{,s}
    Abolish req{,s} requirement{,s}
    Abolish esp especially
endfunction


augroup abolish
    autocmd!
    autocmd Filetype text,pmarkdown,yaml call AbolishCmds()
augroup end
