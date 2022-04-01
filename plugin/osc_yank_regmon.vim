" osc_yank_regmon
" Monitors a named registry. If stuff gets yanked into it, automatically 
" yank it via plugin osc-yank.
"
" VARIABLES
" osc_yank_regmon_enable: whether this plugin is enabled
"   default: 1
" osc_yank_regmon_reg: the register to monitor
"   default: unamed register

fun s:get_osc_yank_regmon_enable()
    return get(g:, 'osc_yank_regmon_enable', 1)
endfun

fun s:get_osc_yank_regmon_reg()
    return get(g:, 'osc_yank_regmon_reg', '')
endfun

fun s:process(regname)
    if a:regname == s:get_osc_yank_regmon_reg()
        silent call OSCYankString(getreg(a:regname))
    endif
endfun

fun s:has_osc_yank()
    return exists('*OSCYankString')
endfun

fun s:configure_buf_reg_hook()
    if !s:get_osc_yank_regmon_enable() || !s:has_osc_yank()
        return
    endif

    augroup OSCYankRegMonBuf
        au!
        autocmd TextYankPost * call s:process(v:event['regname'])
    augroup END
endfun

augroup OSCYankRegMonMain
    au!
    autocmd BufEnter * call s:configure_buf_reg_hook()
augroup END
