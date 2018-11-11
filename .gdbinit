python

import gdb.printing
import scaffold_gdb

gdb.printing.register_pretty_printer(gdb.current_objfile(), scaffold_gdb.make_pretty_printer())

end
