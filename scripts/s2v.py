#!/usr/bin/env python3
import sys
from sdp_tree import SdpTree
import sdp_utils as su


##############################################################################
# load either grammar based parser or vanilla one. If something fails with
# the grammar based one it will default to vanilla parser
##############################################################################
def load_parser(want_grammar):
    if want_grammar:
        print("Trying to load grammar based parser...")
        try:
            from sdp_parse_grammar import parse_file
        except (ImportError, ModuleNotFoundError):
            want_grammar = False

    if not want_grammar:
        from sdp_parse_vanilla import parse_file
    return parse_file


##############################################################################
# main program
##############################################################################
if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("file_in", help="file in")
    parser.add_argument("file_out", help="file out")
    parser.add_argument(
        "--vanilla", "-v",
        action='store_true',
        default=False,
        help="use vanilla parser (instead of grammar based",
    )
    args = parser.parse_args()

    parse_file = load_parser(not args.vanilla)

    clk = "clk"
    rst_n = "rst_n"

    tree = SdpTree()
    tree.io_declarations.append(("input", clk, "1"))
    tree.io_declarations.append(("input", rst_n, "1"))
    parse_file(args.file_in, tree)

    attr = su.SdpAttributes()
    su.annotate_attr(tree, attr)

    parammeters_to_pass = ["W"]
    su.gen_output(tree, attr, args.file_out, clk, rst_n, parammeters_to_pass)

    sys.exit(0)
