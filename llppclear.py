#!/usr/bin/env python3

# Remove the llpp.conf's saved locations that are older than the given number
# of days since they were last opened - but only if there are no bookmarks

import xml.etree.ElementTree as ET
import os
import sys
import argparse
from datetime import datetime, timedelta

LLPPCONFIG = os.path.join(os.getenv('HOME'), '.config', 'llpp.conf')
days = 20

def doit(file, days, any_bookmark, any_day):
    t = ET.parse(file)
    root = t.getroot()
    td = timedelta(days=days)
    now = datetime.today()
    oldest_to_keep = now - td
    for elem in root.findall('doc'):
        last_visit = datetime.fromtimestamp(int(elem.attrib['last-visit']))
        # Such logic
        day_keep = (not any_day) and (last_visit >= oldest_to_keep)
        bookmark_keep = (not any_bookmark) and (len(elem.getchildren()) > 0)
        # Much wow
        if not (day_keep or bookmark_keep):
            print("Removing - {}".format(elem.attrib['path']))
            root.remove(elem)
    t.write(file)


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description='Clean the llpp config file of saved document positions, etc')
    ap.add_argument('-f', '--file', type=str, default=LLPPCONFIG, help='The config file path')
    ap.add_argument('-d', '--days', type=int, default=days, help='How many days old minimum the entries need to be')
    ap.add_argument('-b', '--any_bookmarks', action='store_true', default=False, help='Do not check last day of open')
    ap.add_argument('-n', '--any_days', action='store_true', help='Do not check if bookmark is present')
    args = ap.parse_args()
    doit(args.file, args.days, args.any_bookmarks, args.any_days)

