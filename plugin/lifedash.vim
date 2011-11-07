" LifeDash - A vim plugin for self-tracking and getting things done.
" ``A goal without a plan is just a wish.'' - Antoine de Saint Exupéry
"
" :author: Robert David Grant <robert.david.grant@gmail.com>
" 
" :copyright:
"   Copyright 2011 Robert David Grant
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
if !exists("g:lifedash_dir")
    let g:lifedash_dir = globpath(&rtp, 'lifedata')
endif

" Setup map leader
if !exists("g:lifedash_map_prefix")
    let g:lifedash_map_prefix = '<leader>'
endif
let s:mapl = g:lifedash_map_prefix

" Make sure mappings are only active in .rst files
let s:map_cmd = "nmap"


""" MAPPINGS """
""""""""""""""""
" Paste date in ISO format and weekday
execute s:map_cmd s:mapl.'d' '"=strftime("%F (%A)")<CR>p'

" Paste date and time in ISO format
execute s:map_cmd s:mapl.'D' '"=strftime("%FT%T%Z")<CR>p'

" Mark a task finished and date it
execute s:map_cmd s:mapl.'f' ':s/[-/wx]/x/<CR>$a  <ESC>'.s:mapl.'D<ESC>0:noh<CR>'

" Mark a task partially finished and date it
execute s:map_cmd s:mapl.'p' ':s/[-/wx]/\//<CR>$a  <ESC>'.s:mapl.'D<ESC>0:noh<CR>'

" Mark a task waiting and date it
execute s:map_cmd s:mapl.'w :s/[-/wx]/w/<CR>$a  <ESC>'.s:mapl.'D<ESC>0:noh<CR>'

" Mark task finished and move it to bottom of list
execute s:map_cmd s:mapl.'G' s:mapl."fddGp''"

" Star a task
execute s:map_cmd s:mapl.'*' '$a *<ESC>0:noh<CR>'

" View starred/waiting task\s
execute s:map_cmd s:mapl.'v*' ':vimgrep /\*$/ %<CR>:botright copen<CR>:noh<CR>'
execute s:map_cmd s:mapl.'vw' ':vimgrep /^\s\s*w/ %<CR>:botright copen<CR>:noh<CR>'

" Generate new checklists
execute s:map_cmd s:mapl.'nt' ':call EditChecklist("todo")<CR>'
execute s:map_cmd s:mapl.'ne' ':call EditChecklist("exercise")<CR>'
execute s:map_cmd s:mapl.'nd' ':call EditChecklist("daily")<CR>'
execute s:map_cmd s:mapl.'nw' ':call EditChecklist("weekly")<CR>'
execute s:map_cmd s:mapl.'nm' ':call EditChecklist("monthly")<CR>'
execute s:map_cmd s:mapl.'ny' ':call EditChecklist("yearly")<CR>'

execute s:map_cmd s:mapl.'nl' ':call NewLifeDash()<CR>'

""" FUNCTIONS """
"""""""""""""""""
function! EditChecklist(name)
    let l:data_paths = {
        \"todo": g:lifedash_dir . "/todo-" . strftime("%F") . ".rst",
        \"exercise": g:lifedash_dir . "/exercise-" . strftime("%F") . ".rst",
        \"daily": g:lifedash_dir . "/daily-" . strftime("%F") . ".rst",
        \"weekly": g:lifedash_dir . "/weekly-" . strftime("%V") . ".rst",
        \ "monthly": g:lifedash_dir . "/monthly-" . strftime("%Y") . "-" .  strftime("%m") . ".rst",
        \ "yearly": g:lifedash_dir . "/yearly-" . strftime("%Y") . ".rst"}
    let l:path = l:data_paths[a:name]
    echo l:path
    if filereadable(l:path)
        execute "edit " . l:path
    else
        execute "edit " . l:path
        execute "0read " . g:lifedash_dir . "/templates/" . a:name . ".rst"
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
    split
    call EditChecklist("daily")
    wincmd l
    split
    call EditChecklist("weekly")
endfunction
