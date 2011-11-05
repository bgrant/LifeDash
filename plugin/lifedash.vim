" LifeDash - A vim plugin for productivity and self-tracking.
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


let g:lifedash_version = "0.1"

" Check if loaded
if exists('g:loaded_lifedash')
  if g:lifedash_loaded == 0
    finish
  endif
endif
let g:lifedash_loaded = 1

" Setup default data folder
if !exists("g:lifedash_folder")
    let g:lifedash_folder = substitute(globpath(&rtp, 'lifedata/'))
endif


""" MAPPINGS """
""""""""""""""""

" Append date and time in ISO format to end of line
map <Leader>tD "=strftime("%FT%T%Z")<CR>p

" Mark a task finished and date it
map <Leader>tf :s/[-/wx]/x/<CR>$a  <ESC><Leader>tD<ESC>0:noh<CR>

" Mark a task partially finished and date it
map <Leader>tp :s/[-/wx]/\//<CR>$a  <ESC><Leader>tD<ESC>0:noh<CR>

" Mark a task waiting and date it
map <Leader>tw :s/[-/wx]/w/<CR>$a  <ESC><Leader>tD<ESC>0:noh<CR>

" Mark task finished and move it to bottom of list
map <Leader>tG <Leader>tfddGp''

" Mark a task waiting and move it to bottom of that project
"map <Leader>tw :s/^\s\s*-/ w/<CR>$a  <ESC><Leader>tD<ESC>0dd/^$<CR>P<ESC>'':noh<CR>
" Star a task and promote it to top of project
"map <Leader>t* $a *<ESC>0dd?^[^ ]<CR>p:noh<CR>
"
" Star a task
map <Leader>t* $a *<ESC>0:noh<CR>

" View starred/waiting tasks
map <Leader>tv* :vimgrep /\*$/ %<CR>:botright copen<CR>:noh<CR>
map <Leader>tvw :vimgrep /^\s\s*w/ %<CR>:botright copen<CR>:noh<CR>


""" FUNCTIONS """
"""""""""""""""""

let s:CL_FOLDER = "/Users/bgrant/documents/life/todo"
function! EditChecklist(name)
    let l:cl_paths = {"daily": s:CL_FOLDER . "/daily-" . strftime("%F"),
                \ "weekly": s:CL_FOLDER . "/weekly-" . strftime("%F"),
                \ "monthly": s:CL_FOLDER . "/monthly-" . strftime("%Y") . "-" .  strftime("%m"),
                \ "yearly": s:CL_FOLDER . "/yearly-" . strftime("%Y")}
    let l:path = l:cl_paths[a:name]
    echo l:path
    if filereadable(l:path)
        execute "edit " . l:path
    else
        execute "edit " . l:path
        execute "0read " . s:CL_FOLDER . "/templates/" . a:name
    endif
endfunction

" Generate new checklists
map ,nd = :exe EditChecklist("daily")<CR>
map ,nw = :exe EditChecklist("weekly")<CR>
map ,nm = :exe EditChecklist("monthly")<CR>
map ,ny = :exe EditChecklist("yearly")<CR>

