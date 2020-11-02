---
menu_title: Code Editors
title: Tools - Code Editors
permalink: /notes/tools/code_editors/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

## Visual Studio Code

### Extensions

#### [SQLTools](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools)

* SQL Format (Beautifier)
  * Win/Linux: Ctrl + E, Ctrl + B
  * OSX: Cmd + E, Cmd + B
  * or using the standard VSCode Format Document/selection

#### [JSON Tools](https://marketplace.visualstudio.com/items?itemName=eriklynd.json-tools)

* JSON Format (Beautifier)
  * Ctrl(Cmd) + Alt + M

* JSON Minify
  * Alt + M

## Vim

### Command Mode

#### Open and Quit

| Action | Command |
| ------ | ------- |
| Open | vi *filename* |
| Quit (no changes made) | :q + Enter |
| Quit (ignore changes) | :q! + Enter |
| Save | :w + Enter |
| Save and Quit | :wq + Enter |

#### Cursor

| Action | Command |
| ------ | ------- |
| Move | Arrow Keys |
| Start of the Line | 0 |
| End of the Line | $ |
| Next Word | w |
| Previous Word | b |
| First Line | :0 + Enter |
| Nth Line | :n + Enter |
| Last Line | :$ + Enter |

#### Text Manipulation

| Action | Command |
| ------ | ------- |
| UNDO | u |
| REDO | Ctrl + r |
| Edit Text | i |
| Delete Line from Cursor | D |
| Delete Line | dd |
| Copy Line | yy |
| Copy Multiple Lines | *N*yy |
| Past Line | p |

#### Text Searching

| Action | Command |
| ------ | ------- |
| Search Text | /*string* |
| Next Occurrence | n |
| Previous Occurrence | N |

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

Source: [Vim Commands Cheat Sheet](https://www.fprintf.net/vimCheatSheet.html)

### Initial Setup

Install vim-plug, a Vim plugin manager.

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Options:

`-f`: (HTTP) Fail silently (no output at all) on server errors.
`-L`: (HTTP) If the server reports that the requested page has moved to a different location (indicated with a Location: header and a 3XX response code), this option will make curl redo the request on the new place.
`-o`: Write output to <file> instead of stdout.
`--create-dirs`: When used in conjunction with the -o, --output option, curl will create the necessary local directory hierarchy as needed.

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


