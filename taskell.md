## Cold

- jrnl functionality to assist in mass unlocking and locking in order to rotate keys
- read in from stdio
    > - https://gist.github.com/ck3g/faa5df7c9b380430c5a192115806f341
    > 
    * [ ] - https://gist.github.com/ck3g/faa5df7c9b380430c5a192115806f341
- https://stackoverflow.com/questions/32085258/how-can-i-schedule-code-to-run-every-few-hours-in-elixir-or-phoenix-framework/38778117
- randomly create a puzzle game
- generalized ability to get date from command line for piping into other things
- refactor bw into its own module
    * [ ] or we could separate out into rofi, or even better auto type without ever touching system clipboard

## Warm

- investigate what would be needed to get syncthing into TL and whether or not it would be worth it
- somehow I am trying to do stuff to a tar file and its empty before I have appended a sha to the tar name???
- thing to remove syncthing conflicts on files that I know are append only
- cap merge/browse
    > some sort of functionality towards looking at all the new categories and either compressing deleting or taskifying them
    * [ ] 

## Selected

- figure out what needs testing the most
    * [ ] possibly split and the parsing inside
    * [ ] possibly startx
    * [ ] possibly jrnl
- put refresh in other tasks in right spot
- safety, dont rm jrnl mds unless the gpg is fully formed

## Waiting on Something


## Doing

- can archive-done for the current directory and when done archives in a way that lets me know where the done task came from

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
- restic backup into watched processes
- investigate getting all systemctl work in bootstrap into tl
    * [ ] restic backup (done)
    * [ ] syncthing (this is automatic so leave it alone for now)
- done archive syncthing conflicts why?
    > solved this by implementing write only system. a new file with timestamp for name is is archiving can later implement a cat
- conky setup to tl
    > This requires using ports to stream output from conky command into xsetroot. See ~/.xinit for what needs to be done
    * [ ] ended up with polybar config
- tl new cap
    > this thing creates a new capture file that can be later folded into the main capture file. The reason for this is that I want to be able to write stuff independant of private stuff that might be my main capture file. I guess another thing is needed something like tl cap merge
    * [x] maybe  its more of a category creation maybe category creation is  a list of categories in a category file and each entry is a folder with a capture file inside and  I can basically run tl cap with a prefixed category somehow to file it away in that category.
    * [x] also if we have something in clipboard throw it in there
    * [x] also open it in text editor upon creation?
- makes a scratch new capture file for a given topic and opens subl to that file
