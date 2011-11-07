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


" Check if loaded
if exists('g:loaded_lifedash')
    if g:lifedash_loaded == 0
        finish
    endif
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


""" MAPPINGS """
""""""""""""""""
" Append date and time in ISO format to end of line
map ttD "=strftime("%FT%T%Z")<CR>p

" Mark a task finished and date it
map ttf :s/[-/wx]/x/<CR>$a  <ESC>ttD<ESC>0:noh<CR>

" Mark a task partially finished and date it
map ttp :s/[-/wx]/\//<CR>$a  <ESC>ttD<ESC>0:noh<CR>

" Mark a task waiting and date it
map ttw :s/[-/wx]/w/<CR>$a  <ESC>ttD<ESC>0:noh<CR>

" Mark task finished and move it to bottom of list
map ttG ttfddGp''

" Star a task
map tt* $a *<ESC>0:noh<CR>

" View starred/waiting tasks
map ttv* :vimgrep /\*$/ %<CR>:botright copen<CR>:noh<CR>
map ttvw :vimgrep /^\s\s*w/ %<CR>:botright copen<CR>:noh<CR>


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

" Generate new checklists
map tnt = :exe EditChecklist("todo")<CR>
map tne = :exe EditChecklist("exercise")<CR>
map tnd = :exe EditChecklist("daily")<CR>
map tnw = :exe EditChecklist("weekly")<CR>
map tnm = :exe EditChecklist("monthly")<CR>
map tny = :exe EditChecklist("yearly")<CR>

