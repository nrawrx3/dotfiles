#!/usr/bin/env python

import pprint


def lcs_table(a, b):
    """
    Given 2 sequences a and b, returns a table containing the lcs information
    """
    m = len(a)
    n = len(b)
    t = [[0 for i in range(0, n + 1)] for i in range(0, m + 1)]
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if a[i - 1] == b[j - 1]:
                t[i][j] = t[i - 1][j - 1] + 1
            else:
                t[i][j] = max(t[i - 1][j], t[i][j - 1])

    #pprint.pprint(t)
    return t


def print_diff(a, b):
    """
    Prints the diff between the sequences a and b
    """
    t = lcs_table(a, b)
    m, n = len(a), len(b)
    l = []
    while m > 0 and n > 0:
        if a[m - 1] == b[n - 1]:
            l.append("= {}".format(a[m - 1]))
            m = m - 1
            n = n - 1
        else:
            left = t[m][n - 1]
            up = t[m - 1][n]
            if left > up:
                l.append('+ {}'.format(b[n - 1]))
                n = n - 1
            else:
                l.append('- {}'.format(a[m - 1]))
                m = m - 1

    while n > 0:
        l.append('+ {}'.format(b[n - 1]))
        n = n - 1

    while m > 0:
        l.append('- {}'.format(a[m - 1]))
        m = m - 1

    print(''.join(list(reversed(l))))


if __name__ == '__main__':
    from sys import argv, exit
    if len(argv) != 3:
        print("Usage: python {} FILE1 FILE2".format(argv[0]))
        exit(1)
    with open(argv[1]) as f1:
        with open(argv[2]) as f2:
            a = [line for line in f1]
            b = [line for line in f2]
            print_diff(a, b)

