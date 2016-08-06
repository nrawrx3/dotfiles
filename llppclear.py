#!/usr/bin/env python3

# Remove the llpp.conf's saved locations that are older than the given number
# of days since they were last opened - but only if there are no bookmarks

import xml.etree.ElementTree as ET
import os
import sys
import argparse
import re
from datetime import datetime, timedelta

LLPPCONFIG = os.path.join(os.getenv('HOME'), '.config', 'llpp.conf')
days = 20

def _get_filename(path):
    return os.path.basename(path.split('.')[0])

def doit(file, days, ignore_bookmarks, ignore_days, regex, is_dry_run):
    t = ET.parse(file)
    root = t.getroot()
    td = timedelta(days=days)
    now = datetime.today()
    oldest_to_keep = now - td
    r = None
    if regex != '':
        r = re.compile(regex, re.IGNORECASE)
    for elem in root.findall('doc'):
        last_visit = datetime.fromtimestamp(int(elem.attrib['last-visit']))

        # Such logic
        day_keep = (not ignore_days) and (last_visit >= oldest_to_keep)
        bookmark_keep = (not ignore_bookmarks) and (len(elem.getchildren()) > 0)
        regex_matches = regex == '' or re.fullmatch(r, _get_filename(elem.attrib['path']))

        # Much wow
        if not(day_keep or bookmark_keep) and regex_matches:
            print("Removing - {}".format(elem.attrib['path']))
            if not is_dry_run:
                root.remove(elem)
    if not is_dry_run:
        t.write(file)


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description='Clean the llpp config file of saved document positions, etc')
    ap.add_argument('-f', '--file', type=str, default=LLPPCONFIG, help='The config file path')
    ap.add_argument('-d', '--days', type=int, default=days,
                    help='How many days old minimum the entries need to be')
    ap.add_argument('-b', '--ignore_bookmarks', action='store_true', default=False,
                    help='Do not take presence of bookmark into account')
    ap.add_argument('-n', '--ignore_days', action='store_true', help='Do not take entry age into account')
    ap.add_argument('-r', '--regex', type=str, default='',
                    help='Use a regular expression to match file names')
    ap.add_argument('-s', '--dry_run', action='store_true',
                    help='Just print potential filenames, don\'t actually remove them')

    args = ap.parse_args()
    doit(args.file, args.days, args.ignore_bookmarks, args.ignore_days, args.regex, args.dry_run)

