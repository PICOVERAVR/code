: '\n' 10 ;
: BL 32 ;

\ maybe useful later?
: CR '\n' EMIT ;
: SPACE BL EMIT ;

: TRUE 1 ;
: FALSE 0 ;
: NOT 0= ;

\take tos and compile LIT <tos>
: LITERAL IMMEDIATE
	' LIT ,
	,
;

: ':'
	[
	CHAR :
	]
	LITERAL
;

\ defining some character constants for some reason
: ';' [ CHAR ; ] LITERAL ;
: '(' [ CHAR ( ] LITERAL ;
: ')' [ CHAR ) ] LITERAL ;
: '"' [ CHAR " ] LITERAL ;
: 'A' [ CHAR A ] LITERAL ;
: '0' [ CHAR 0 ] LITERAL ;
: '-' [ CHAR - ] LITERAL ;
: '.' [ CHAR . ] LITERAL ;

\ compile an immediate word
: [COMPILE] IMMEDIATE
	WORD
	FIND
	>CFA
	,
;

\ add a word for defining recursive definitions
: RECURSE IMMEDIATE
	LATEST @
	>CFA
	,
;

\ control structures here
: IF IMMEDIATE
	' 0BRANCH , \ compile a 0BRANCH
	HERE @ \save offset on stack
	0 , \ compile a dummy offset
;

: THEN IMMEDIATE
	DUP
	HERE @ SWAP - \find offset from address saved
	SWAP ! \ backfill dummy offset
;

\ same as a IF and THEN with a guanentee that the jump will be taken
: ELSE IMMEDIATE
	' BRANCH ,
	HERE @
	0 ,
	SWAP
	DUP
	HERE @ SWAP -
	SWAP !
;

: BEGIN IMMEDIATE
	HERE @
;

: UNTIL IMMEDIATE
	' 0BRANCH ,
	HERE @ -
	,
;

\ usage: BEGIN loop AGAIN
: AGAIN IMMEDIATE
	' BRANCH ,
	HERE @ -
	,
;

: WHILE IMMEDIATE
	' 0BRANCH ,
	HERE @
	0 ,
;

: REPEAT IMMEDIATE
	' BRANCH ,
	SWAP
	HERE @ - ,
	DUP
	HERE @ SWAP -
	SWAP !
;

: UNLESS IMMEDIATE
	' NOT , \ reverse the test
	[COMPILE] IF \ test it
;

\ more complex syntax for comments, allowing for multi-line comments and 
\ nested parantheses
: ( IMMEDIATE
	1
	BEGIN
		KEY \ get next key
		DUP '(' = IF \ is it a '('?
			DROP
			1+
		ELSE
			')' = IF \ if a close paren, dec the counter
				1-
		THEN
		THEN
	DUP 0= UNTIL \ repeat until the last brace is closed
	DROP
;

( this can be a comment now! )

: NIP ( x y -- y ) SWAP DROP ;
: TUCK ( x y -- y x y ) SWAP OVER ;
: PICK ( xn ... x1 x0 n -- xn ... x1 x0 xn )
	1+
	8 *
	DSP@ +
	@
;

( write a number of spaces to stdout )
: SPACES ( n -- )
	BEGIN
		DUP 0>
	WHILE
		SPACE
		1-
	REPEAT
	DROP
;

( set the base to a number )
: BINARY ( -- ) 2 BASE ! ;
: DECIMAL ( -- ) 10 BASE ! ;
: HEX ( -- ) 16 BASE ! ;

( U prints an unsigned number, padded to some number of bits )
: U. ( -- )
	BASE @ /MOD ( width rem quot )
	?DUP IF ( if quot <> 0, print quot )
		RECURSE
	THEN
	DUP 10 < IF
		'0'
	ELSE
		10 -
		'A'
	THEN
	+
	EMIT
;

( .S prints the whole stack, useful for debugging )
: .S ( -- )
	DSP@ ( get current stack pointer )
	62 EMIT SPACE ( nice printing for user )
	BEGIN
		DUP S0 @ <
	WHILE
		DUP @ U.
		SPACE
		8+
	REPEAT
	DROP
	CR
;

: UWIDTH2 ( u -- width )
	BASE @ /MOD
	?DUP IF
		SWAP DROP
		RECURSE 1+
	ELSE
		1
	THEN
;

: UWIDTH UWIDTH2 SWAP DROP ;


