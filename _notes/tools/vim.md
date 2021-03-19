---
menu_title: Vim
title: Tools - Vim
permalink: /notes/tools/vim/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

## Vim

### Command Mode

#### Open and Quit

| Action | Command |
| ------ | ------- |
| Open | `vim` *filename* |
| Open file | `:e` *filename* |
| Quit (no changes made) | `:q` |
| Quit (ignore changes) | `:q!` |
| Save | `:w` |
| Save and quit | `:wq` |

#### Screen Management

| Action | Command |
| ------ | ------- |
| List buffers | `:ls` |
| Previous/next buffer | `:bp` / `:bn` |
| Close buffer | `:bd` |
| Open file splitting horizontally | `:sp` *filename* |
| Open file splitting vertically | `:svp` *filename* |
| Split horizontally | `Ctrl` + `w`, `s` |
| Split vertically | `Ctrl` + `w`, `v` |
| Switch window | `Ctrl` + `w`, `w` |
| Switch to left, down, up, right window | `Ctrl` + `w` + `h`, `j`, `k`, `l` |
| Quit window | `Ctrl` + `w`, `q` |

#### Tab Management

| Action | Command |
| ------ | ------- |
| Open file in new tab | `:tabedit` *filename* |
| List tabs | `:tabs` |
| Previous/next tab | `gT` / `gt` |
| Close tab | `:tabclose` |

#### Cursor

| Action | Command |
| ------ | ------- |
| Move cursor | Arrow keys (left, down, up, right) or `h`, `j`, `k`, `l` |
| Move cursor to top/middle/bottom of screen | `H` / `M` / `L` |
| Previous/next word | `b` / `w` |
| End of word | `e` |
| Start/end of line | `0` or `^` / `$` |
| Previous/next sentence | `(` / `)` |
| Previous/next block of text | `{` / `}` |
| Previous/next page | `Ctrl` + `b` / `Ctrl` + `f` |
| Start/end of file | `gg` / `G` |
| First line | `:0` |
| Nth line | `:`*N* |
| Last line | `:$` |

#### Text Manipulation

| Action | Command |
| ------ | ------- |
| UNDO | `u` |
| REDO | `Ctrl` + `r` |
| Repeat last action | `.` |
| Edit text | `i` |
| Highlight characters | `v` |
| Highlight lines | `V` |
| Copy word | `yw` |
| Copy line | `yy` |
| Copy multiple lines | *N*`yy` |
| Delete word | `dw` |
| Delete line | `dd` |
| Delete line from cursor | `D` |
| Delete highlighted text | `d` |
| Delete from cursor to | `d0` (beginning of line), `dgg` / `dG` (beginning/end of file) |
| Paste line | `p` |

#### Text Searching

| Action | Command |
| ------ | ------- |
| Search text | /*string* |
| Next occurrence | `n` |
| Previous occurrence | `N` |
| Replace pattern without confirming | `%s/`*pattern*`/`*replacement*`/g` |
| Replace pattern confirming each time | `%s/`*pattern*`/`*replacement*`/gc` |

<span class="info-source">Source: <https://www.keycdn.com/blog/vim-commands></span>

### Recommended Configuration

It may be necessary to create the `~/.vimrc` file if it is not created by default.

```
" Make vim indent 2 spaces for Ruby files only
:autocmd Filetype ruby set sw=2
:autocmd Filetype ruby set ts=2
" Auto-indent repeats the indentation of the previous line
:autocmd Filetype ruby set autoindent
" This makes the cursor go to the previous/next line when pressing left/right
" arrow keys when on the first/last column
:autocmd Filetype ruby set ww+=<,>
```

<span class="info-source">Source: [https://www.fprintf.net/vimCheatSheet.html](https://www.fprintf.net/vimCheatSheet.html)</span>

### Initial Setup

Install vim-plug, a Vim plugin manager.

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Options:

`-f`: (HTTP) Fail silently (no output at all) on server errors.<br>
`-L`: (HTTP) If the server reports that the requested page has moved to a different location (indicated with a Location: header and a 3XX response code), this option will make curl redo the request on the new place.<br>
`-o`: Write output to <file> instead of stdout.<br>
`--create-dirs`: When used in conjunction with the -o, --output option, curl will create the necessary local directory hierarchy as needed.<br>

Edit `~/.vimrc` and add a section like the below:

```
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'scrooloose/nerdtree'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
```

Reload the file:

```
:source ~/.vimrc
```

Install the listed plugins:

```
:PlugInstall
```

Close the windows with `q` after installation is finished.

Open NERDTree:

```
:NERDTree
```

### Example .vimrc

```
syntax on

" Required to make lightline.vim work
set laststatus=2

" Unnecessary because of the use of lightline.vim
set noshowmode

" Display a line under the line where the cursor is
set cursorline

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'itchyny/lightline.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
```
