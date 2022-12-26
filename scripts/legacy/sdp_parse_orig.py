#!/usr/bin/env python3

import re
from enum import Enum


##############################################################################
# parse the input file
##############################################################################
class State(Enum):
    init = 1
    module_found = 2
    end_module_found = 3


def parse_file(file_in, tree):
    state = State.init
    with open(file_in, "r") as fin:
        for line in fin:
            line = line.strip()
            m = re.match(r"\/\/", line)
            if m is None and len(line) > 0:
                tokens = re.split(r"\s+", line)

                if state == State.init:
                    if tokens[0] == "module":
                        tree.module_name = tokens[1]
                        state = State.module_found

                elif state == State.module_found:

                    if tokens[0] == "endmodule":
                        state = State.end_module_found
                    elif tokens[0] == "sin" or tokens[0] == "sout":
                        m = re.match(r"\[(.*)\]", tokens[1])
                        if m is None:
                            width = "1"
                            name = tokens[1]
                        else:
                            width = m.group(1)
                            name = tokens[2]
                        typ = tokens[0]
                        tree.io_declarations.append((typ, name, width))
                        tree.type_of[name] = typ
                    elif (
                        tokens[0] == "input"
                        or tokens[0] == "output"
                        or tokens[0] == "hstr"
                    ):
                        m = re.match(r"\[(.*)\]", tokens[1])
                        if m is None:
                            width = "1"
                            name = tokens[1]
                        else:
                            width = m.group(1)
                            name = tokens[2]
                        typ = tokens[0]
                        if tokens[0] == "input" or tokens[0] == "output":
                            tree.io_declarations.append((typ, name, width))
                        tree.type_of[name] = typ
                        if typ == "input":
                            tree.internal_decl.append(
                                ("wire", "{}_mflags".format(name), "4")
                            )
                            tree.assigns.append(
                                "assign {}_mflags = 4'b0111".format(name)
                            )
                        elif typ == "hstr":
                            tree.internal_str_decl.append(name)
                            tree.assigns.append(
                                "assign {}_sflags = 2'b00".format(name)
                            )
                            tree.assigns.append(
                                "assign {}_mflags = 4'b0111".format(name)
                            )
                    elif tokens[0] == "parameter":
                        tree.parameters.append(tokens[1])
                    elif len(tokens) > 0:
                        name = tokens[0]
                        if "->" in tokens:
                            pos = tokens.index("->")
                            ins = tokens[1:pos]
                            outs = tokens[pos + 1 :]
                        else:
                            ins = tokens[1:]
                            outs = []
                        for i in ins + outs:
                            if i not in tree.type_of:
                                tree.type_of[i] = "str"
                                tree.internal_str_decl.append(i)
                        name = tokens[0]
                        tree.topo.append((name, ins, outs))

                        mod_nm = name
                        if len(ins) != 1:
                            mod_nm = "{mod}_{num_ins}".format(
                                mod=mod_nm, num_ins=len(ins)
                            )
                        if len(outs) != 1:
                            mod_nm = "{mod}x{num_outs}".format(
                                mod=mod_nm, num_outs=len(outs)
                            )

                        ins_idx = tree.cc[mod_nm]
                        tree.cc[mod_nm] += 1
                        ins_nm = "u_" + mod_nm + "_" + "{:d}".format(ins_idx)
                        tree.ins_cnt += 1
                        tree.ins_name.append(ins_nm)
                        tree.mod_name[ins_nm] = mod_nm

                        for i in ins:
                            tree.loads[i].add(ins_nm)

                        for o in outs:
                            tree.drivers[o].add(ins_nm)

                elif state == State.end_module_found:
                    pass

                else:
                    pass
        # end for line
    # end with

    if state == State.end_module_found:
        pass
        # print ("DECL:", tree.io_declarations)
        # print ("TOPO:", tree.topo)


if __name__ == "__main__":
    import sys
    from sdp_tree import SdpTree

    t = SdpTree()
    parse_file(sys.argv[1], t)
    t.dump()
