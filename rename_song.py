import eyed3
import sys

if len(sys.argv) != 2:
    sys.stderr.write("Usage: %s MP3_FILE\n" %(sys.argv[0]))
    sys.exit()

a = eyed3.load(sys.argv[1])
if a.tag is None or a.tag.artist is None or a.tag.title is None:
    print(sys.argv[1])
    sys.exit()
artist = "_".join(a.tag.artist.split())
album = "_".join(a.tag.album.split())
title = "_".join(a.tag.title.split())
filename = "%s_%s_%s" %(artist, album, title)
log = open("log.txt", "a")
log.write('\n' + filename)
print(filename)

