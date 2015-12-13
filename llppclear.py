import xml.etree.ElementTree as ET
import os
import sys
from datetime import datetime, timedelta

LLPPCONFIG = os.path.join(os.getenv('HOME'), '.config', 'llpp.conf')

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
        LLPPCONFIG = sys.argv[1]
    doit(20)
