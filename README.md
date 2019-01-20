# Disclaimer

I take NO RESPONSIBILITY if you lose any photo and/or video using these tools. I made them to simplify some scenarios for me, and just figured I'd share them. They all rely on you storing your content (including catalog) on a folder which can be accessed from a linux machine.

# showfiles.sh

Takes a `.lrcat` file and a base folder and shows you which files that's missing from your catalog file, it also produces a file with all files which exists in the base folder but not in your catalog.

Why is this useful? It allows an easy way to find any issues with your catalog, it also shows you any content which ISN'T tracked by your catalog but still stored alongside your photos and videos. I used
it to clean up and re-add photos I had somehow lost tracking on.

# movefiles.sh

Takes the extras file produced by showfiles.sh and moves the listed files into a new directory, allowing you to easily sift through the content AND use the "Library > Find all missing photos" to confirm if anything is off. I saved 18GB of storage by using `showfiles.sh` and then feeding it into `movefiles.sh`

