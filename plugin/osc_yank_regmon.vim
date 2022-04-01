" osc_yank_regmon
" Monitors a named registry. If stuff gets yanked into it, automatically 
" yank it via plugin osc-yank.
"
" VARIABLES
" osc_yank_regmon_reg: the register to monitor
"   default: 'z'

fun s:get_monitored_reg()
    return get(g:, 'osc_yank_regmon_reg', 'z')
endfun

fun s:process(regname)
    if a:regname != s:get_monitored_reg()
        return
    endif
    call OSCYankString(getreg(a:regname))
endfun

fun s:has_osc_yank()
    return exists('*OSCYankString')
endfun

fun s:configure_buf_reg_hook()
    augroup OSCYankRegMonBuf
        au!
        let mon_reg = s:get_monitored_reg()
        if mon_reg != '' && s:has_osc_yank()
            autocmd TextYankPost * call s:process(v:event['regname'])
        endif
    augroup END
endfun

augroup OSCYankRegMonMain
    au!
    autocmd BufEnter * call s:configure_buf_reg_hook()
augroup END
