" LifeDash - A vim plugin for self-tracking and getting things done.
"
"     A goal without a plan is just a wish. - Antoine de Saint Exupéry
"
" :author: Robert David Grant <robert.david.grant@gmail.com>
" 
" :copyright:
"   Copyright 2012-2015 Robert David Grant
" 
"   Licensed under the Apache License, Version 2.0 (the "License"); you
"   may not use this file except in compliance with the License.  You
"   may obtain a copy of the License at
" 
"      http://www.apache.org/licenses/LICENSE-2.0
" 
"   Unless required by applicable law or agreed to in writing, software
"   distributed under the License is distributed on an "AS IS" BASIS,
"   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
"   implied.  See the License for the specific language governing
"   permissions and limitations under the License.


""" SETUP """
"""""""""""""
" Check if loaded, if nocompatible, if vim is current
if exists('g:loaded_lifedash') || &cp || v:version < 700
    finish
endif
let g:lifedash_loaded = 1

" Setup default data folder
let s:default_lifedash_dir = globpath(&rtp, 'lifedata')
if !exists("g:lifedash_dir")
    let g:lifedash_dir = s:default_lifedash_dir
endif

" Setup map leader
if !exists("g:lifedash_map_prefix")
    let g:lifedash_map_prefix = '<Leader>'
endif
let s:mapl = g:lifedash_map_prefix

" Make sure mappings are only active in .yaml files
let s:map_cmd = "nmap"


""" MAPPINGS """
""""""""""""""""
" Paste date in ISO format and weekday
execute s:map_cmd s:mapl.'d' '"=strftime("%F (%A):")<CR>p'

" Paste date and time in ISO format
execute s:map_cmd s:mapl.'D' '"=strftime("%FT%T%Z")<CR>p'

" Mark a task finished (success) and date it
execute s:map_cmd s:mapl.'f' '$a  @done(<ESC>'.s:mapl.'Da)<ESC>'

" Mark a task finished (failure/decided against) and date it
execute s:map_cmd s:mapl.'x' '$a  @cancelled(<ESC>'.s:mapl.'Da)<ESC>'

" Mark a task partially finished and date it
execute s:map_cmd s:mapl.'p' '$a  @progress(<ESC>'.s:mapl.'Da)<ESC>'

" Mark a task waiting and date it
execute s:map_cmd s:mapl.'w' '$a  @waiting(<ESC>'.s:mapl.'Da)<ESC>'

" Move a task to bottom of DONE list (archive it)
execute s:map_cmd s:mapl.'a' "ddGp''"

" Mark a task @today
execute s:map_cmd s:mapl.'t' '$a  @today<ESC>'

" View today / waiting tasks
execute s:map_cmd s:mapl.'vt' ':vimgrep /@today/ %<CR>:botright copen<CR>:noh<CR>'
execute s:map_cmd s:mapl.'vw' ':vimgrep /@waiting/ %<CR>:botright copen<CR>:noh<CR>'

" Generate new checklists
execute s:map_cmd s:mapl.'nt' ':call EditChecklist("todo")<CR>'
execute s:map_cmd s:mapl.'ne' ':call EditChecklist("exercise")<CR>'
execute s:map_cmd s:mapl.'nm' ':call EditChecklist("monthly")<CR>'
execute s:map_cmd s:mapl.'ny' ':call EditChecklist("yearly")<CR>'

" Populate new lifedash window
execute s:map_cmd s:mapl.'nl' ':call NewLifeDash()<CR>'


""" FUNCTIONS """
"""""""""""""""""
function! EditChecklist(name)
    let l:data_paths = {
        \"todo": g:lifedash_dir . "/todo.yaml",
        \"exercise": g:lifedash_dir . "/exercise.yaml",
        \"monthly": g:lifedash_dir . "/monthly-" . strftime("%Y") . "-" .  strftime("%m") . ".yaml",
        \"yearly": g:lifedash_dir . "/yearly-" . strftime("%Y") . ".yaml"}
    let l:path = l:data_paths[a:name]
    echo l:path
    if filereadable(l:path)
        execute "edit" l:path
    else
        execute "edit" l:path
        if isdirectory(g:lifedash_dir . "/templates")
            execute "0read" g:lifedash_dir . "/templates/" . a:name . ".yaml"
        else
           execute "0read" s:default_lifedash_dir . "/templates/" . a:name . ".yaml"
       endif
    endif
endfunction

function! NewLifeDash()
    call EditChecklist("yearly")
    vsplit
    call EditChecklist("monthly")
    vsplit
    call EditChecklist("todo")
    wincmd l
    split
    call EditChecklist("exercise")
endfunction
