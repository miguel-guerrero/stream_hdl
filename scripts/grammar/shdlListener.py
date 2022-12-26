# Generated from shdl.g by ANTLR 4.11.1
from antlr4 import *
if __name__ is not None and "." in __name__:
    from .shdlParser import shdlParser
else:
    from shdlParser import shdlParser

# This class defines a complete listener for a parse tree produced by shdlParser.
class shdlListener(ParseTreeListener):

    # Enter a parse tree produced by shdlParser#top.
    def enterTop(self, ctx:shdlParser.TopContext):
        pass

    # Exit a parse tree produced by shdlParser#top.
    def exitTop(self, ctx:shdlParser.TopContext):
        pass


    # Enter a parse tree produced by shdlParser#module.
    def enterModule(self, ctx:shdlParser.ModuleContext):
        pass

    # Exit a parse tree produced by shdlParser#module.
    def exitModule(self, ctx:shdlParser.ModuleContext):
        pass


    # Enter a parse tree produced by shdlParser#opt_blank_lines.
    def enterOpt_blank_lines(self, ctx:shdlParser.Opt_blank_linesContext):
        pass

    # Exit a parse tree produced by shdlParser#opt_blank_lines.
    def exitOpt_blank_lines(self, ctx:shdlParser.Opt_blank_linesContext):
        pass


    # Enter a parse tree produced by shdlParser#module_body.
    def enterModule_body(self, ctx:shdlParser.Module_bodyContext):
        pass

    # Exit a parse tree produced by shdlParser#module_body.
    def exitModule_body(self, ctx:shdlParser.Module_bodyContext):
        pass


    # Enter a parse tree produced by shdlParser#param_decls.
    def enterParam_decls(self, ctx:shdlParser.Param_declsContext):
        pass

    # Exit a parse tree produced by shdlParser#param_decls.
    def exitParam_decls(self, ctx:shdlParser.Param_declsContext):
        pass


    # Enter a parse tree produced by shdlParser#io_decls.
    def enterIo_decls(self, ctx:shdlParser.Io_declsContext):
        pass

    # Exit a parse tree produced by shdlParser#io_decls.
    def exitIo_decls(self, ctx:shdlParser.Io_declsContext):
        pass


    # Enter a parse tree produced by shdlParser#sentences.
    def enterSentences(self, ctx:shdlParser.SentencesContext):
        pass

    # Exit a parse tree produced by shdlParser#sentences.
    def exitSentences(self, ctx:shdlParser.SentencesContext):
        pass


    # Enter a parse tree produced by shdlParser#param_decl.
    def enterParam_decl(self, ctx:shdlParser.Param_declContext):
        pass

    # Exit a parse tree produced by shdlParser#param_decl.
    def exitParam_decl(self, ctx:shdlParser.Param_declContext):
        pass


    # Enter a parse tree produced by shdlParser#io_decl.
    def enterIo_decl(self, ctx:shdlParser.Io_declContext):
        pass

    # Exit a parse tree produced by shdlParser#io_decl.
    def exitIo_decl(self, ctx:shdlParser.Io_declContext):
        pass


    # Enter a parse tree produced by shdlParser#input_decl.
    def enterInput_decl(self, ctx:shdlParser.Input_declContext):
        pass

    # Exit a parse tree produced by shdlParser#input_decl.
    def exitInput_decl(self, ctx:shdlParser.Input_declContext):
        pass


    # Enter a parse tree produced by shdlParser#output_decl.
    def enterOutput_decl(self, ctx:shdlParser.Output_declContext):
        pass

    # Exit a parse tree produced by shdlParser#output_decl.
    def exitOutput_decl(self, ctx:shdlParser.Output_declContext):
        pass


    # Enter a parse tree produced by shdlParser#strin_decl.
    def enterStrin_decl(self, ctx:shdlParser.Strin_declContext):
        pass

    # Exit a parse tree produced by shdlParser#strin_decl.
    def exitStrin_decl(self, ctx:shdlParser.Strin_declContext):
        pass


    # Enter a parse tree produced by shdlParser#strout_decl.
    def enterStrout_decl(self, ctx:shdlParser.Strout_declContext):
        pass

    # Exit a parse tree produced by shdlParser#strout_decl.
    def exitStrout_decl(self, ctx:shdlParser.Strout_declContext):
        pass


    # Enter a parse tree produced by shdlParser#hstr_decl.
    def enterHstr_decl(self, ctx:shdlParser.Hstr_declContext):
        pass

    # Exit a parse tree produced by shdlParser#hstr_decl.
    def exitHstr_decl(self, ctx:shdlParser.Hstr_declContext):
        pass


    # Enter a parse tree produced by shdlParser#sentence.
    def enterSentence(self, ctx:shdlParser.SentenceContext):
        pass

    # Exit a parse tree produced by shdlParser#sentence.
    def exitSentence(self, ctx:shdlParser.SentenceContext):
        pass


    # Enter a parse tree produced by shdlParser#ins_name.
    def enterIns_name(self, ctx:shdlParser.Ins_nameContext):
        pass

    # Exit a parse tree produced by shdlParser#ins_name.
    def exitIns_name(self, ctx:shdlParser.Ins_nameContext):
        pass


    # Enter a parse tree produced by shdlParser#args.
    def enterArgs(self, ctx:shdlParser.ArgsContext):
        pass

    # Exit a parse tree produced by shdlParser#args.
    def exitArgs(self, ctx:shdlParser.ArgsContext):
        pass


    # Enter a parse tree produced by shdlParser#arg.
    def enterArg(self, ctx:shdlParser.ArgContext):
        pass

    # Exit a parse tree produced by shdlParser#arg.
    def exitArg(self, ctx:shdlParser.ArgContext):
        pass


    # Enter a parse tree produced by shdlParser#str_list.
    def enterStr_list(self, ctx:shdlParser.Str_listContext):
        pass

    # Exit a parse tree produced by shdlParser#str_list.
    def exitStr_list(self, ctx:shdlParser.Str_listContext):
        pass


    # Enter a parse tree produced by shdlParser#width_decl.
    def enterWidth_decl(self, ctx:shdlParser.Width_declContext):
        pass

    # Exit a parse tree produced by shdlParser#width_decl.
    def exitWidth_decl(self, ctx:shdlParser.Width_declContext):
        pass


    # Enter a parse tree produced by shdlParser#const_expr.
    def enterConst_expr(self, ctx:shdlParser.Const_exprContext):
        pass

    # Exit a parse tree produced by shdlParser#const_expr.
    def exitConst_expr(self, ctx:shdlParser.Const_exprContext):
        pass



del shdlParser