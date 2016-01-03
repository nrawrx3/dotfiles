# Remove the llpp.conf's saved locations that are older than the given number
# of days since they were last opened - but only if there are no bookmarks

import xml.etree.ElementTree as ET
import os
import sys
from datetime import datetime, timedelta

LLPPCONFIG = os.path.join(os.getenv('HOME'), '.config', 'llpp.conf')
REMOVE_BEFORE_DAYS = 20

def doit(remove_before_days):
    t = ET.parse(LLPPCONFIG)
    root = t.getroot()
    td = timedelta(days=remove_before_days)
    now = datetime.today()
    oldest_to_keep = now - td
    for elem in root.findall('doc'):
        last_visit = datetime.fromtimestamp(int(elem.attrib['last-visit']))
        if last_visit < oldest_to_keep and len(elem.getchildren()) == 0:
            print("Removing - {}".format(elem.attrib['path']))
            root.remove(elem)
    t.write(LLPPCONFIG)


if __name__ == '__main__':
    if len(sys.argv) == 2:
        if sys.argv[1] == '-h':
            sys.stderr.write("Usage: python {} [llpp_config_file({})] [remove_before_days=({})]\n".format(sys.argv[0], LLPPCONFIG, REMOVE_BEFORE_DAYS))
            sys.exit(1)
        LLPPCONFIG = sys.argv[1]
    elif len(sys.argv) == 3:
        LLPPCONFIG = sys.argv[1]
        REMOVE_BEFORE_DAYS = int(sys.argv[2])
    doit(REMOVE_BEFORE_DAYS)
