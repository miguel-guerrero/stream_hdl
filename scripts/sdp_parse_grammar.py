# parse an SDP file using antlr4 grammar generated artifacts
from antlr4 import FileStream, CommonTokenStream, ParseTreeWalker
from grammar.shdlLexer import shdlLexer
from grammar.shdlParser import shdlParser
from grammar.shdlListener import shdlListener


class TreeBuilder(shdlListener):
    def __init__(self, tree):
        self.tree = tree

    def exitModule(self, ctx):
        self.tree.module_name = ctx.ID().getText()

    def exitIns_name(self, ctx):
        self.ins_name = ctx.ID().getText()

    def exitSentence(self, ctx):
        tree = self.tree
        name = ctx.ins_name().ID().getText()
        # args = ctx.args()
        lst0 = ctx.str_list(0)
        lst1 = ctx.str_list(1)

        inps = []
        for i in lst0.ID():
            n = i.getText()
            inps.append(n)

        outs = []
        if lst1 is not None:
            for i in lst1.ID():
                n = i.getText()
                outs.append(n)

        tree.update_with_arrow(name, inps, outs)

    # add hstr

    def exitParam_decl(self, ctx):
        tree = self.tree
        id_name = ctx.ID().getText()
        tree.parameters.append(id_name + "=" + self.const_expr)

    def exitInput_decl(self, ctx):
        tree = self.tree
        typ, name = "input", ctx.ID().getText()
        tree.type_of[name] = typ
        tree.io_declarations.append((typ, name, self.width))
        tree.internal_decl.append(("wire", "{}_mflags".format(name), "4"))
        tree.assigns.append("assign {}_mflags = 4'b0111".format(name))

    def exitOutput_decl(self, ctx):
        tree = self.tree
        typ, name = "output", ctx.ID().getText()
        tree.type_of[name] = typ
        tree.io_declarations.append((typ, name, self.width))

    def exitStrin_decl(self, ctx):
        tree = self.tree
        typ, name = "sin", ctx.ID().getText()
        tree.type_of[name] = typ
        tree.io_declarations.append((typ, name, self.width))

    def exitStrout_decl(self, ctx):
        tree = self.tree
        typ, name = "sout", ctx.ID().getText()
        tree.type_of[name] = typ
        tree.io_declarations.append((typ, name, self.width))

    def exitHstr_decl(self, ctx):
        tree = self.tree
        typ, name = "hstr", ctx.ID().getText()
        tree.type_of[name] = typ
        tree.io_declarations.append((typ, name, self.width))
        tree.internal_str_decl.append(name)
        tree.assigns.append("assign {}_sflags = 2'b00".format(name))
        tree.assigns.append("assign {}_mflags = 4'b0111".format(name))

    def exitWidth_decl(self, ctx):
        self.width = self.const_expr

    def exitConst_expr(self, ctx):
        if ctx.INT() is not None:
            self.const_expr = ctx.INT().getText()
        if ctx.ID() is not None:
            self.const_expr = ctx.ID().getText()


##############################################################################
# parse the input file
##############################################################################
def parse_file(file_in, tree):
    print("Using grammar parser")
    input = FileStream(file_in)
    lexer = shdlLexer(input)
    stream = CommonTokenStream(lexer)
    parser = shdlParser(stream)
    syntax_tree = parser.top()
    tree_builder = TreeBuilder(tree)
    walker = ParseTreeWalker()
    walker.walk(tree_builder, syntax_tree)


if __name__ == "__main__":
    import sys
    from sdp_tree import SdpTree

    tree = SdpTree()
    parse_file(sys.argv[1], tree)
    tree.dump()
