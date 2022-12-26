grammar shdl;

top: module;
module: opt_blank_lines
         'module' ID NEWLINE
         module_body 
         'endmodule' NEWLINE?
        opt_blank_lines;

opt_blank_lines: (NEWLINE)*;

module_body: param_decls io_decls sentences ;

param_decls: (param_decl NEWLINE)* ;
io_decls:    (io_decl NEWLINE)* ;
sentences:   (sentence NEWLINE)* ;

param_decl: 'parameter' ID '=' const_expr;
io_decl:    input_decl 
       |    output_decl 
       |    strin_decl 
       |    strout_decl 
       |    hstr_decl 
       ;


input_decl:  'input'  width_decl? ID ;
output_decl: 'output' width_decl? ID ;
strin_decl:  'sin'    width_decl? ID ;
strout_decl: 'sout'   width_decl? ID ;
hstr_decl:   'hstr'   width_decl? ID ;

sentence: ins_name args? str_list ('->' str_list)? ;

ins_name: ID ('<' const_expr '>')? ;
args: '(' arg (',' arg)* ')' ;
arg: '.' ID '(' const_expr ')' ;
str_list: ID*  ;

width_decl: '[' const_expr ']' ;
const_expr: INT  
          | ID  
          ;

ID : [a-zA-Z][a-zA-Z0-9_]* ; // match identifiers
INT : [0-9]+ ; // match integers
NEWLINE : [\r\n]+ ;
WS      : [ \t]+ -> skip ;
LINE_COMMENT : '//' .*? [\r\n]+ -> skip ;

