import sys


def formatw(w):
    if w == "1":
        return ""
    else:
        return "[{}-1:0]".format(w)


def get_module_name(name, inps, outs):
    mod_nm = name
    if len(inps) != 1:
        mod_nm = f"{mod_nm}_{len(inps)}"
    if len(outs) != 1:
        mod_nm = f"{mod_nm}x{len(outs)}"
    return mod_nm


def get_param_string(parameters):
    param_str = ""
    if len(parameters) > 0:
        param_str = ",".join(parameters)
        param_str = "#(parameter " + param_str + ")"
    return param_str


def get_param_to_pass_string(parammeters_to_pass):
    out = ""
    if len(parammeters_to_pass) > 0:
        out = ",".join(f".{name}({name})" for name in parammeters_to_pass)
        out = f"#({out})"
    return out


def get_drivers(inps, type_of, drivers):
    driver_set = set()
    for i in inps:
        if type_of[i] in ("sin", "input", "hstr"):
            driver_set.add(i)
        else:
            driver_set |= drivers[i]
    return driver_set


def get_loads(outs, type_of, loads):
    load_set = set()
    for o in outs:
        if type_of[o] in ("sout", "hstr"):
            load_set.add(o)
        else:
            load_set |= loads[o]
    return load_set


def write_module_hdr(fout, indent, module_name, param_str, io_declarations):
    fout.write(f"module {module_name} {param_str} (\n")
    indent = "   "
    sep = " "
    for typ, name, width in io_declarations:
        if typ in ("input", "output"):
            fout.write(indent + sep + f"{typ} {formatw(width)} {name}\n")
        elif typ == "sin":
            fout.write(indent + sep + f"input  {formatw(width)} {name}\n")
            fout.write(indent + "," + f"input  [3:0] {name}_mflags\n")
            fout.write(indent + "," + f"output [1:0] {name}_sflags\n")
        elif typ == "sout":
            fout.write(indent + sep + f"output {formatw(width)} {name}\n")
            fout.write(indent + "," + f"output [3:0] {name}_mflags\n")
            fout.write(indent + "," + f"input  [1:0] {name}_sflags\n")
        sep = ","
    fout.write(");\n\n")


def write_internal_decl(fout, internal_str_decl, internal_decl, assigns):
    # internal declarations
    for it in internal_str_decl:
        fout.write(f"wire [W-1:0] {it};\n")
        fout.write(f"wire [3:0]   {it}_mflags;\n")
        fout.write(f"wire [1:0]   {it}_sflags;\n")

    for typ, name, width in internal_decl:
        fout.write(f"{typ} {formatw(width)} {name};\n")

    for it in assigns:
        fout.write(f"{it};\n")


##############################################################################
# data structure holder for auxiliary data derived from syntax tree
##############################################################################
class SdpAttributes:
    def __init__(self):
        # dicts where the key is the instance name
        self.uc_d = {}  # up to current data
        self.uc_mflags = {}  # up to current master flags
        self.cu_sflags = {}  # current to up slave flags (flow control)

        self.cd_d = {}  # current to down data
        self.cd_mflags = {}  # current to down master flags
        self.dc_sflags = {}  # down to current slave flags (flow control)


##############################################################################
# generate some aux data structures from the input tree
##############################################################################
def annotate_attr(tree, attr):
    for k, (name, inps, outs) in enumerate(tree.topo):
        print(f"Annotating name={name} inps={inps} outs={outs}")
        ins_nm = tree.ins_name[k]

        attr.uc_d[ins_nm] = inps

        driver_set = get_drivers(inps, tree.type_of, tree.drivers)

        if len(driver_set) == 0:
            print("ERROR: nothing drives...", inps)
            sys.exit(1)
        else:
            attr.uc_mflags[ins_nm] = [
                i + "_mflags" for i in sorted(driver_set)
            ]

        if name in ("bufin", "regin"):
            attr.cu_sflags[ins_nm] = [inps[0] + "_sflags"]
        else:
            attr.cu_sflags[ins_nm] = [ins_nm + "_sflags"]
            tree.internal_decl.append(("wire", ins_nm + "_sflags", "2"))

        attr.cd_d[ins_nm] = outs
        if name in ("bufout", "regout"):
            attr.cd_mflags[ins_nm] = [outs[0] + "_mflags"]
        else:
            attr.cd_mflags[ins_nm] = [ins_nm + "_mflags"]
            tree.internal_decl.append(("wire", ins_nm + "_mflags", "4"))

        load_set = get_loads(outs, tree.type_of, tree.loads)
        if len(load_set) == 0:  # case of an usused output
            sflags = outs[0] + "_sflags"
            tree.internal_decl.append(("wire /*unused*/", sflags, "2"))
            attr.dc_sflags[ins_nm] = [sflags]
        elif name in ("bufout", "regout"):  # case of a primary output
            sflags = outs[0] + "_sflags"
            attr.dc_sflags[ins_nm] = [sflags]
        else:  # all other cases
            sflags = ins_nm + "_sflags"
            attr.dc_sflags[ins_nm] = [
                " | ".join([i + "_sflags" for i in sorted(load_set)])
            ]


##############################################################################
##############################################################################
def gen_output(tree, attr, file_out, clk, rst_n, parammeters_to_pass):

    param_str = get_param_string(tree.parameters)

    # dicts where the key is the instance name
    # uc=up to current,   cu=current to up
    # dc=down to current, cd=current to down

    with open(file_out, "w") as fout:
        indent = "   "
        write_module_hdr(
            fout, indent, tree.module_name, param_str, tree.io_declarations
        )
        write_internal_decl(
            fout, tree.internal_str_decl, tree.internal_decl, tree.assigns
        )

        params_down_str = get_param_to_pass_string(parammeters_to_pass)

        for ins_cnt, (name, inps, outs) in enumerate(tree.topo):
            print("Processing ", name, inps, outs)
            ins_nm = tree.ins_name[ins_cnt]

            fout.write(
                f"\n{tree.mod_name[ins_nm]} {params_down_str} {ins_nm} (\n"
            )
            fout.write(indent + f" .clk({clk})\n")
            fout.write(indent + f",.rst_n({rst_n})\n")
            mflags = " & ".join(attr.uc_mflags[ins_nm])

            fout.write(indent + " // data + flags in from upstream\n")
            for k, inp in enumerate(inps):
                inp_port = f"uc_d{k}"
                if tree.type_of[inp] in ("input", "sin", "str", "hstr"):
                    fout.write(indent + f",.{inp_port}({inp})\n")
            fout.write(indent + ",.uc_mflags({})\n".format(mflags))

            fout.write(indent + " // flags out to upstream\n")
            fout.write(
                indent + ",.cu_sflags({})\n".format(attr.cu_sflags[ins_nm][0])
            )

            fout.write(indent + " // flags in from downstream\n")
            fout.write(indent + f",.dc_sflags({attr.dc_sflags[ins_nm][0]})\n")

            fout.write(indent + " // data + flags out to downstream\n")
            for k, outp in enumerate(outs):
                outp_port = f"cd_d{k}"
                if tree.type_of[outp] in ("sout", "str", "hstr"):
                    fout.write(indent + f",.{outp_port}({outp})\n")
            fout.write(indent + f",.cd_mflags({attr.cd_mflags[ins_nm][0]})\n")

            fout.write(");\n")

        fout.write("\n")
        fout.write("endmodule\n")
