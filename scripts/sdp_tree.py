from collections import defaultdict, Counter
import  sdp_utils as su


##############################################################################
# data structure holder for input syntax tree
##############################################################################
class SdpTree:
    def __init__(self):
        self.module_name = "<>"
        self.parameters = []
        self.io_declarations = []
        self.internal_str_decl = []
        self.internal_decl = []
        self.assigns = []
        self.topo = []
        self.ins_name = []
        self.mod_name = {}
        self.type_of = {}
        self.ins_cnt = 0
        self.loads = defaultdict(set)
        self.drivers = defaultdict(set)
        self.cc = Counter()

    def update_with_arrow(self, name, inps, outs):
        for i in inps + outs:
            if i not in self.type_of:
                self.type_of[i] = "str"
                self.internal_str_decl.append(i)

        self.topo.append((name, inps, outs))
        mod_nm = su.get_module_name(name, inps, outs)

        # build instance name
        ins_idx = self.cc[mod_nm]
        self.cc[mod_nm] += 1
        ins_nm = f"u_{mod_nm}_{ins_idx}"

        # keep track of all instances so far
        self.ins_cnt += 1
        self.ins_name.append(ins_nm)
        self.mod_name[ins_nm] = mod_nm

        # this instance becomes a load to all its inputs
        for i in inps:
            self.loads[i].add(ins_nm)

        # this instance becomes a driver of all its outputs
        for o in outs:
            self.drivers[o].add(ins_nm)

    def dump(self):
        print("Module name:", self.module_name)
        print("parameters:", self.parameters)
        print("io_declarations:", self.io_declarations)
        print("internal_str_decl:", self.internal_str_decl)
        print("internal_decl:", self.internal_decl)
        print("assigns:", self.assigns)
        print("topo:", self.topo)
        print("ins_name:", self.ins_name)
        print("mod_name:", self.mod_name)
        print("type_of:", self.type_of)
        print("ins_cnt:", self.ins_cnt)
        print("loads:", self.loads)
        print("drivers:", self.drivers)
        print("cc:", self.cc)
