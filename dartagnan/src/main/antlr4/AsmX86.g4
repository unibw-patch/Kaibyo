grammar AsmX86;

main
   : (line ('!' line)* EOL)*
   ;

line
   : lbl? (assemblerdirective | instruction)? comment?
   ;

instruction
   : rep? opcode expressionlist?
   ;

lbl
   : GLOB global
   | TYPE vardef
   | arraysize
   | arrayinit
   | varinit
   | LABEL COLON
   | slabel COLON? expressionlist?
   ;

arraysize
   : ARRAYSIZE expressionlist?
   ;
   
arrayinit
   : ARRAYINIT expressionlist?
   ;
   
varinit
   : VARINIT expressionlist?
   ;
   
global
   : NAME
   ;

vardef
   : variable ',' AT type
   ;

variable
   : NAME
   ;

type
   : NAME
   ;

assemblerdirective
   : org
   | end
   | if_
   | endif
   | equ
   | db
   | dw
   | cseg
   | dd
   | dseg
   | title
   | include
   | rw
   | rb
   | rs
   | '.'
   ;

rw
   : name? RW expression
   ;

rb
   : name? RB expression
   ;

rs
   : name? RS expression
   ;

cseg
   : CSEG expression?
   ;

dseg
   : DSEG expression?
   ;

dw
   : DW expressionlist
   ;

db
   : DB expressionlist
   ;

dd
   : DD expressionlist
   ;

equ
   : name EQU expression
   ;

if_
   : IF assemblerexpression
   ;

assemblerexpression
   : assemblerterm (assemblerlogical assemblerterm)*
   | '(' assemblerexpression ')'
   ;

assemblerlogical
   : 'eq'
   | 'ne'
   ;

assemblerterm
   : name
   | number
   | (NOT assemblerterm)
   ;

endif
   : ENDIF
   ;

end
   : END
   ;

org
   : ORG expression
   ;

title
   : TITLE string
   ;

include
   : INCLUDE name
   ;

expressionlist
   : expression (',' expression)*
   ;

slabel
   : name
   ;

expression
   : multiplyingExpression (SIGN multiplyingExpression)*
   ;

multiplyingExpression
   : argument (MULT argument)*
   ;

argument
   : number
   | dollar
   | register_
   | AT? name
   | string
   | ('(' expression ')')
   | ((number | name)? '[' expression ']')
   | address
   | NOT expression
   | OFFSET expression
   | LENGTH expression
   | (register_ ':') expression
   | LABEL
   ;

address
   : ptr '[' expression ']'
   ;

ptr
   : (BYTE | WORD | DWORD | QWORD)? PTR
   ;

dollar
   : DOLLAR
   ;

register_
   : REGISTER
   ;

string
   : STRING
   ;

name
   : NAME
   ;

number
   : SIGN? NUMBER
   ;

opcode
   : OPCODE
   ;

rep
   : REP
   ;

comment
   : COMMENT
   ;


BYTE
   : B Y T E
   ;


WORD
   : W O R D
   ;


DWORD
   : D W O R D
   ;


QWORD
   : Q W O R D
   ;


DSEG
   : D S E G
   ;


CSEG
   : C S E G
   ;


INCLUDE
   : I N C L U D E
   ;


TITLE
   : T I T L E
   ;


END
   : E N D
   ;


ORG
   : O R G
   ;


ENDIF
   : E N D I F
   ;


IF
   : I F
   ;


EQU
   : E Q U
   ;


DW
   : D W
   ;


DB
   : D B
   ;


DD
   : D D
   ;


PTR
   : P T R
   ;


NOT
   : N O T
   ;


OFFSET
   : O F F S E T
   ;


RW
   : R W
   ;


RB
   : R B
   ;


RS
   : R S
   ;


LENGTH
   : L E N G T H
   ;


COMMENT
   : '#' ~ [\r\n]* -> skip
   ;


REGISTER
   : R A X | R B X | R C X | R D X | R D I | R B P | R S P | R S I
   | E A X | E B X | E C X | E D X | E D I | E B P | E S P | E S I
   | A X | B X | C X | D X | D I | B P | S P | S I
   | A H | A L | B H | B L | C H | C L | D H | D L | S P L | B P L | S I L | D I L 
   | R '8' | R '8' D | R '8' W | R '8' B
   | R '9' | R '9' D | R '9' W | R '9' B
   | R '10' | R '10' D | R '10' W | R '10' B
   | R '11' | R '11' D | R '11' W | R '11' B
   | R '12' | R '12' D | R '12' W | R '12' B
   | R '13' | R '13' D | R '13' W | R '13' B
   | R '14' | R '14' D | R '14' W | R '14' B
   | R '15' | R '15' D | R '15' W | R '15' B
   | C I | I P | C S | D S | E S | S S
   ;


OPCODE
   : A A A | A A D | A A M | A A S | A D C | A D D | A N D 
   | C A L L | C B W | C L C | C L D | C L I | C M C | C M P | C M P S B | C M P S W | C W D | C M O V A E
   | D A A | D A S | D E C | D I V 
   | E S C 
   | H L T 
   | I D I V | I M U L | I N | I N C | I N T | I N T O | I R E T 
   | J A | J A E | J B | J B E | J C | J E | J G | J G E | J L | J L E | J N A | J N A E | J N B 
   | J N B E | J N C | J N E | J N G | J N G E | J N L | J N L E | J N O | J N P | J N S | J N Z 
   | J O | J P | J P E | J P O | J S | J Z | J C X Z | J M P | J M P S | J M P F 
   | L A H F | L D S | L E A | L E S | L F E N C E | L O C K | L O D S | L O D S B | L O D S W | L O O P | L O O P E | L O O P N E | L O O P N Z | L O O P Z 
   | M O V | M O V S | M O V S B | M O V S W  | M O V S X D | M O V Z X | M U L 
   | N E G | N O P | N O T 
   | O R | O U T 
   | P O P | P O P F | P U S H | P U S H F 
   | R C L | R C R | R E T | R E T N | R E T F | R O L | R O R 
   | S A H F | S A L | S A R | S A L C | S B B | S C A S B | S C A S W | S H L | S H R | S T C | S T D | S T I | S T O S B | S T O S W | S U B 
   | T E S T 
   | W A I T 
   | X C H G 
   | X L A T 
   | X O R
   ;


REP
   : R E P | R E P E | R E P N E | R E P N Z | R E P Z
   ;


DOLLAR
   : '$'
   ;


AT
   : '@'
   ;


COLON
   : ':'
   ;


SIGN
   : '+' | '-'
   ;

MULT
   : '*' | '/' | 'mod'
   ;

GLOB
   : '.' G L O B L
   ;
   
TYPE
   : '.' T Y P E
   ;
   
ARRAYSIZE
   : '.' A R R A Y S I Z E
   ;
   
ARRAYINIT
   : '.' A R R A Y I N I T
   ;
   
VARINIT
   : '.' V A R I N I T
   ;
   
LABEL
   : '.L' NAME
   ;
   
NAME
   : [.a-zA-Z] [a-zA-Z0-9."_]*
   ;
NUMBER
   : [0-9a-fA-F] + 'x' [0-9a-fA-F] + ('H' | 'h')?
   | [0-9a-fA-F] + ('H' | 'h')?
   ;
STRING
   : '"' ~'"'* '"'
   ;
EOL
   : [\r\n] +
   ;
WS
   : [ \t] -> skip
   ;
fragment A
   : ('a' | 'A')
   ;
fragment B
   : ('b' | 'B')
   ;
fragment C
   : ('c' | 'C')
   ;
fragment D
   : ('d' | 'D')
   ;
fragment E
   : ('e' | 'E')
   ;
fragment F
   : ('f' | 'F')
   ;
fragment G
   : ('g' | 'G')
   ;
fragment H
   : ('h' | 'H')
   ;
fragment I
   : ('i' | 'I')
   ;
fragment J
   : ('j' | 'J')
   ;
fragment K
   : ('k' | 'K')
   ;
fragment L
   : ('l' | 'L')
   ;
fragment M
   : ('m' | 'M')
   ;
fragment N
   : ('n' | 'N')
   ;
fragment O
   : ('o' | 'O')
   ;
fragment P
   : ('p' | 'P')
   ;
fragment Q
   : ('q' | 'Q')
   ;
fragment R
   : ('r' | 'R')
   ;
fragment S
   : ('s' | 'S')
   ;
fragment T
   : ('t' | 'T')
   ;
fragment U
   : ('u' | 'U')
   ;
fragment V
   : ('v' | 'V')
   ;
fragment W
   : ('w' | 'W')
   ;
fragment X
   : ('x' | 'X')
   ;
fragment Y
   : ('y' | 'Y')
   ;
fragment Z
   : ('z' | 'Z')
   ;