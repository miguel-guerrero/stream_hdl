import re
from enum import Enum


##############################################################################
# Parsing state enum
##############################################################################
class State(Enum):
    init = 1
    module_found = 2
    end_module_found = 3


def parse_io_decl(tokens):
    m = re.match(r"\[(.*)\]", tokens[1])
    if m is None:
        width = "1"
        name = tokens[1]
    else:
        width = m.group(1)
        name = tokens[2]
    typ = tokens[0]
    return typ, name, width


def parse_arrow(tokens):
    name = tokens[0]
    if "->" in tokens:
        pos = tokens.index("->")
        inps = tokens[1:pos]
        outs = tokens[pos + 1:]
    else:
        inps = tokens[1:]
        outs = []
    return name, inps, outs


##############################################################################
# Parse file using only string/regex funcions
##############################################################################
def parse_file(file_in, tree):
    print("Using vanilla parser")

    state = State.init
    with open(file_in, "r") as fin:

        for line in fin:
            line = line.strip()

            # skip comments
            m = re.match(r"\/\/", line)
            if m is not None or len(line) == 0:
                continue

            # not a comment
            tokens = re.split(r"\s+", line)

            # looking for 'module' keyword
            if state == State.init:
                if tokens[0] == "module":
                    tree.module_name = tokens[1]
                    state = State.module_found

            elif state == State.module_found:
                if tokens[0] == "endmodule":
                    state = State.end_module_found

                elif tokens[0] in ("sin", "sout"):
                    typ, name, width = parse_io_decl(tokens)
                    tree.io_declarations.append((typ, name, width))
                    tree.type_of[name] = typ

                elif tokens[0] in ("input", "output", "hstr"):
                    typ, name, width = parse_io_decl(tokens)
                    if tokens[0] in ("input", "output"):
                        tree.io_declarations.append((typ, name, width))
                    tree.type_of[name] = typ
                    if typ == "input":
                        tree.internal_decl.append(
                            ("wire", f"{name}_mflags", "4")
                        )
                        tree.assigns.append(f"assign {name}_mflags = 4'b0111")
                    elif typ == "hstr":
                        tree.internal_str_decl.append(name)
                        tree.assigns.append(f"assign {name}_sflags = 2'b00")
                        tree.assigns.append(f"assign {name}_mflags = 4'b0111")

                elif tokens[0] == "parameter":
                    tree.parameters.append(tokens[1])

                elif len(tokens) > 0:
                    name, inps, outs = parse_arrow(tokens)
                    tree.update_with_arrow(name, inps, outs)

            elif state == State.end_module_found:
                pass

            else:
                pass

    if state == State.end_module_found:
        pass
