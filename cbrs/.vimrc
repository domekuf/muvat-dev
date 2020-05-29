set path+=src
set path+=src/lib-cbrs-common
set path+=src/lib-cbrs-common/test
set path+=src/lib-cbrs-model
set path+=src/lib-cbrs-model/test
set path+=src/lib-cbrs-spvdbus
set path+=src/lib-cbrs-spvdbus/test
set path+=src/lib-cbrs-cfg
set path+=src/lib-cbrs-cfg/test
set path+=src/lib-cbrs-dbus
set path+=src/lib-cbrs-dbus/test
set path+=src/lib-cbrs-entities
set path+=src/lib-cbrs-entities/test
set path+=src/lib-cbrs
set path+=src/lib-cbrs/test
set path+=src/lib-rest
set path+=src/lib-rest/cpp-httplib
set path+=src/lib-rest/test
set path+=src/lib-auth
set path+=src/lib-auth/test
set path+=src/cbrs-daemon
set path+=src/cbrs-daemon/test
set path+=src/cbrs-web
set path+=src/cbrs-web/test

function! JitFunction()
    !source m.sh && jit > jit.txt
    read jit.txt
endfunction
command! Jit :call JitFunction()

