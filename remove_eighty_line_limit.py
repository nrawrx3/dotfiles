import sys

with open(sys.argv[1]) as f:
    IN_CODE, IN_PROSE = 0, 1
    state = IN_PROSE
    newtext = ''
    for line in f:
        if state == IN_CODE:
            if line.startswith('    '):
                newtext += line
            elif line == '\n':
                newtext += '\n'
            else:
                newtext += line[:len(line) - 1]
                state = IN_PROSE
        else:
            if line == '\n':
                newtext += '\n\n'
            elif line.startswith('    '):
                newtext += '\n{}'.format(line)
                state = IN_CODE
            elif line.startswith('##'):
                newtext += '\n{}'.format(line)
            else:
                newtext += ' {}'.format(line[:len(line) - 1])

    print(newtext)



