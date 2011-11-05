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

" Setup map leader
if !exists("g:lifedash_map_prefix")
    let g:lifedash_map_prefix = '<leader>'
endif


""" MAPPINGS """
""""""""""""""""
" Append date and time in ISO format to end of line
map <leader>tD "=strftime("%FT%T%Z")<CR>p

" Mark a task finished and date it
map <leader>tf :s/[-/wx]/x/<CR>$a  <ESC><leader>tD<ESC>0:noh<CR>

" Mark a task partially finished and date it
map <leader>tp :s/[-/wx]/\//<CR>$a  <ESC><leader>tD<ESC>0:noh<CR>

" Mark a task waiting and date it
map <leader>tw :s/[-/wx]/w/<CR>$a  <ESC><leader>tD<ESC>0:noh<CR>

" Mark task finished and move it to bottom of list
map <leader>tG <leader>tfddGp''

" Star a task
map <leader>t* $a *<ESC>0:noh<CR>

" View starred/waiting tasks
map <leader>tv* :vimgrep /\*$/ %<CR>:botright copen<CR>:noh<CR>
map <leader>tvw :vimgrep /^\s\s*w/ %<CR>:botright copen<CR>:noh<CR>


""" FUNCTIONS """
"""""""""""""""""
function! EditChecklist(name)
    let l:data_paths = {"weekly": g:lifedash_folder . "/weekly-" . strftime("%F"),
                \ "monthly": g:lifedash_folder . "/monthly-" . strftime("%Y") . "-" .  strftime("%m"),
                \ "yearly": g:lifedash_folder . "/yearly-" . strftime("%Y")}
    let l:path = l:data_paths[a:name]
    echo l:path
    if filereadable(l:path)
        execute "edit " . l:path
    else
        execute "edit " . l:path
        execute "0read " . g:lifedash_folder . "/templates/" . a:name
    endif
endfunction

" Generate new checklists
map <leader>tnd = :exe EditChecklist("daily")<CR>
map <leader>tnw = :exe EditChecklist("weekly")<CR>
map <leader>tnm = :exe EditChecklist("monthly")<CR>
map <leader>tny = :exe EditChecklist("yearly")<CR>

