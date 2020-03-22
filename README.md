# Tavatar: shell history mirroring teaching tool

This tool include a shell hook which can (in real time) post your
shell history to a Google drive file.  This allows you to easily share
shell history with learners so that they can copy and paste - with no
special infra needed on your part.



## Usage

Set up the virtual environments:

```
./tavatar.sh
```

Prepare the shell.  This will blank the history file
`~/.tavatar_history` - append to this file to send data.  It will then
create a file `~/.tavatar`, which you can source to set up a
`PROMPT_COMMAND` to append history to this file (but you can use any
other option you want, too):

```
./tavatar.sh MAIN
```

This will tell you to source the shell initialization file (for bash,
but there are some for other shells, too).  All it does is append
every command to the file `~/.tavatar_history`.  Instead of sourcing
this, you can do anything else that appends to this file:

```
source init.bash.sh
```

Then finally, start the process that watches the history file and
uploads to the google doc.  This process polls the history file and
uploads when there are new lines.  It will also prompt for google
authentication the first time (and cache that into `token.pickle`).
The app isn't verified, so you have to accept the risk under
"advanced".

```
./tavatar.sh CONNECT '1ftGqZ-1yfnlyxc8dbhbJ42S2ZAyyvFuxtQTZ9bOFGMs'
```

## Notes

* Only actual shell commands are uploaded, i.e. if you mistype the
  command name it won't be updated.  The intention is to save you from
  uploading mis-pasted text.

* But something including `http` will be uploaded - to send links to
  students.



## See also





## Development and maintnance

Author Sabry Razick, University of Oslo

This is currently in alpha.  The Google oauth app is not verified yet.
