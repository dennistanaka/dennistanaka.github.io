---
menu_title: Command Line
title: Cheat Sheets - Command Line
permalink: /notes/cheatsheets/command_line/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

## tmux Shortcuts

Prefix key (Ctrl + b) + command keys below:

```
$           Rename the current session.
(           Switch the attached client to the previous session.
)           Switch the attached client to the next session.
d           Detach the current client.

c           Create a new window.
,           Rename the current window.
l           Move to the previously selected window.
n           Change to the next window.
0 to 9      Select windows 0 to 9.

Up, Down
Left, Right Change to the pane above, below, to the left, or to the right of the current pane.
"           Split the current pane into two, top and bottom.
%           Split the current pane into two, left and right.
!           Break the current pane out of the window.
```

<span class="info-source">Source: `man tmux`</span>

## Search Files

```bash
# finds files by wildcard in the current directory
$ find . -name "test*"

# find only folders that were modified more than 30*24 hours ago
$ find . -type d -mtime +30
```

Act on the results of `find`:

```bash
# Removes the files found (-i prompts before removal)
# {} is a placeholder representing each result of the find command
# \; is just a delimiter indicating the end of the command passed to -exec
$ find . -name "test*" -exec rm -i {} \;
```

## Search Text

```bash
# basic search
$ grep test /home/ubuntu
$ grep "another test" /home/ubuntu
$ grep test /home/ubuntu/*.sh

# options:
# -r: recursive (-R to follow symlinks)
# -v: invert match
# -i: case-insensitive
# -w: full words

# lines before and after a match
$ grep -B 5 -A 5 test /home/ubuntu
```

<span class="info-source">Source: [https://linuxize.com/post/how-to-use-grep-command-to-search-files-in-linux/](https://linuxize.com/post/how-to-use-grep-command-to-search-files-in-linux/)</span>

### Exclude Folders from Recursive Search

```bash
$ grep -r --exclude-dir=node_modules test app
$ grep -r --exclude-dir={node_modules,vendor} test app
```

<span class="info-source">Source: [https://stackoverflow.com/questions/6565471/how-can-i-exclude-directories-from-grep-r](https://stackoverflow.com/questions/6565471/how-can-i-exclude-directories-from-grep-r)</span>

## Count Lines in File or Command Output

```bash
$ wc Gemfile
54  277 1964 Gemfile
```
It returns lines (54), words(277) and bytes (1964). We can limit the results to something specific with the options below:

```
wc -l : Prints the number of lines in a file.
wc -w : prints the number of words in a file.
wc -c : Displays the count of bytes in a file.
wc -m : prints the count of characters from a file.
wc -L : prints only the length of the longest line in a file.
```

Counting the lines in a command output:

```bash
$ git clean -n | wc -l
```

<span class="info-source">Source: [https://www.tecmint.com/wc-command-examples/](https://www.tecmint.com/wc-command-examples/)</span>

## Create Alias

Add to ~/.bashrc:

```bash
alias k=kubectl
```

## Find the Process Allocating a Specific Port

```bash
$ lsof -i :<port_number>

# or more specifically
$ lsof -i tcp:<port_number>
```

<span class="info-source">Source: [https://www.howtogeek.com/426031/how-to-use-the-linux-lsof-command/](https://www.howtogeek.com/426031/how-to-use-the-linux-lsof-command/)</span>

## Base64 Encoding and Decoding

```bash
# Encoding
$ echo -n 'string_to_be_encoded' | base64

# Decoding
$ echo 'encoded_string' | base64 --decode
```

Where `-n`: Do not print the trailing newline character.  This may also be achieved by appending \`\c' to the end of the string, as is done by iBCS2 compatible systems.  Note that this option as well as the effect of \`\c' are implementation-defined in IEEE Std 1003.1-2001 (``POSIX.1'') as amended by Cor. 1-2002.  Applications aiming for maximum portability are strongly encouraged to use printf(1) to suppress the newline character.

## Delete Specific Entries from the History

To remove a specific entry from the history, we first run `history` to get the number next to the command we want to delete and then:

```bash
$ history -d <number_of_the_entry>
```

If the line has already been written to $HISTFILE, we need to update it. Otherwise, the entry will reappear when we open a new session:

```bash
$ history -w
```

<span class="info-source">Source: [https://unix.stackexchange.com/questions/49214/how-to-remove-a-single-line-from-history](https://unix.stackexchange.com/questions/49214/how-to-remove-a-single-line-from-history)</span>

## Prevent Commands to Appear in Bash History

We can acoomplish this by setting the `HISTCONTROL` with an appropriate value. From `man bash`:

> A colon-separated list of values controlling how commands are saved on the history list. If the list of values includes "ignorespace", lines which begin with a space character are not saved in the history list. A value of "ignoredups" causes lines matching the previous history entry to not be saved. A value of "ignoreboth" is shorthand for "ignorespace" and "ignoredups".

So, it's usually safe to set it to `ignoreboth`:

```bash
export HISTCONTROL=ignoreboth
```

<span class="info-source">Source: [https://stackoverflow.com/questions/6475524/how-do-i-prevent-commands-from-showing-up-in-bash-history](https://stackoverflow.com/questions/6475524/how-do-i-prevent-commands-from-showing-up-in-bash-history)</span>



## Log Analysis

```bash
$ tail -n 100000 access.log | grep status:499 | awk '{ print $2 }' | sort | uniq -c | awk '{ print $1, $2 }' | sort -nr | head -n 30
$ tail -n 100000 access.log | grep status:499 | awk '{ print $(NF) }' | cut -d ':' -f 2 | sort -nr | head -n 100
```

- https://www.tecmint.com/count-word-occurrences-in-linux-text-file/
- https://fedingo.com/how-to-extract-ip-address-from-log-file/
- https://linuxhint.com/sort-command-in-linux-with-examples/#:~:text=SORT%20command%20in%20Linux%20is,come%20before%20the%20alphabetic%20lines.
- https://linuxize.com/post/linux-wc-command/
- https://stackoverflow.com/questions/380817/best-way-to-simulate-group-by-from-bash
- https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
- https://linuxhint.com/awk_print_last_column_file/

