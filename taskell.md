## Cold

- jrnl functionality to assist in mass unlocking and locking in order to rotate keys
- read in from stdio
    > - https://gist.github.com/ck3g/faa5df7c9b380430c5a192115806f341
    > 
    * [ ] - https://gist.github.com/ck3g/faa5df7c9b380430c5a192115806f341
- https://stackoverflow.com/questions/32085258/how-can-i-schedule-code-to-run-every-few-hours-in-elixir-or-phoenix-framework/38778117
- randomly create a puzzle game

## Warm

- investigate what would be needed to get syncthing into TL and whether or not it would be worth it
- investigate getting all systemctl work in bootstrap into tl
    * [ ] restic backup
    * [ ] syncthing
    * [ ] cpupower
- What happens when restic is run and nothing left to backup?
- somehow I am trying to do stuff to a tar file and its empty before I have appended a sha to the tar name???
- makes a scratch new capture file for a given topic and opens subl to that file
- conky setup to tl
- thing to remove syncthing conflicts on files that I know are append only

## Selected

- figure out what needs testing the most
    * [ ] possibly split and the parsing inside
    * [ ] possibly startx
    * [ ] possibly jrnl
- done archive syncthing conflicts why?
- put refresh in other tasks in right spot
- some way of clearing out old gpg files in jrnl folder

## Waiting on Something


## Doing


## Done

- cap from clipboard if no content is provided
- prepend-full-iso to gpg files so that we can sort on filename rather than created_at because of how copying from jrnl-archive works
- jrnl lock is no longer jrnl specific
- archive done exposed
- jrnl lock is really buggy now that its been fixed lol
- remove the ctime and other sorting stuff
- make jrnl archive read dirname and put in sub folder of jrnlarchive
- ensure that repeating jobs DONOT start when running cli commands
- options to peel off most recent from jrnl archive into current directory
- add the ability to copy a ## heading and its content and automatically create a new md file that is named appropriately
- remove the runonce module and fold into supervisor
