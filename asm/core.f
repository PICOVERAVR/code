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

( ?? )
: U.R
	SWAP
	DUP
	UWIDTH
	ROT
	SWAP -
	SPACES
	U.
;

( print a signed number to some number of bits )
( n width )
: .R
	SWAP
	DUP 0< IF
		NEGATE
		1
		SWAP
		ROT
		1-
	ELSE
		0
		SWAP
		ROT
	THEN
	SWAP
	DUP
	UWIDTH
	ROT
	SWAP -
	SPACES
	SWAP
	IF
		'-' EMIT
	THEN
	
	U.
;

( . is pop and print )
: . 0 .R SPACE ;
( note trailing space )
: U. U. SPACE ;
( get an integer at an address and print it )
: ? @ . ;

( c a b WITHIN returns true if a <= c and c < b )
: WITHIN
	-ROT
	OVER
	<= IF
		> IF
			TRUE
		ELSE
			FALSE
		THEN
	ELSE
		2DROP
		FALSE
	THEN
;

( returns depth of stack )
: DEPTH
	S0 @ DSP@ -
	8- ( adjust because s0 was on stack when we pushed dsp )
;

: ALIGNED ( align an address )
	7 + 7 INVERT AND
;

( align here pointer )
: ALIGN HERE @ ALIGNED HERE ! ;

( strings are hard because we have to decide what to do in compiled mode vs immediate mode )
( append a byte to compiled word )
: C,
	HERE @ C!
	1 HERE +!
;

( -- addr len )
: S" IMMEDIATE
	STATE @ IF
		' LITSTRING ,
		HERE @
		0 ,
		BEGIN
			KEY
			DUP '"' <>
		WHILE
			C,
		REPEAT
		DROP
		DUP
		HERE @ SWAP -
		8-
		SWAP !
		ALIGN
	ELSE
		HERE @
		BEGIN
			KEY
			DUP '"' <>
		WHILE
			OVER C!
			1+
		REPEAT
		DROP
		HERE @ -
		HERE @
		SWAP
	THEN
;

: ." IMMEDIATE
	STATE @ IF ( compiling mode )
		[COMPILE] S"
		' TELL ,
	ELSE ( immediate mode, just read and print the characters )
		BEGIN
			KEY DUP '"' = IF
				DROP
				EXIT
			THEN
			EMIT
		AGAIN
	THEN
;

( create a constant, same as : <name> <value> ; )
: CONSTANT
	WORD
	CREATE
	DOCOL ,
	' LIT ,
	,
	' EXIT ,
;

: ALLOT ( n -- addr )
	HERE @ SWAP
	HERE +!
;

( turn # of cells into # of bytes )
: CELLS 8 * ;

( allocate one cell to hold the variable, and define it )
: VARIABLE
	1 CELLS ALLOT
	WORD CREATE
	DOCOL ,
	' LIT ,
	,
	' EXIT ,
;

( values are like variables, but push the actual value instead of a pointer to the value onto the stack.
  Implementation is more complex, but the runtime overhead is the same. )

: VALUE ( make a dictonary entry for value )
	WORD CREATE
	DOCOL ,
	' LIT ,
	,
	' EXIT ,
;

( this word compiles the address of the value, and therefore avoids a dictonary search each time. )
: TO IMMEDIATE
	WORD
	FIND
	>DFA
	8+
	STATE @ IF
		' LIT ,
		,
		' ! ,
	ELSE
		!
	THEN
;

: +TO IMMEDIATE
	WORD
	FIND
	>DFA
	8+
	STATE @ IF
		' LIT ,
		,
		' +! ,
	ELSE
		+!
	THEN
;

( finds name of address in dictonary )
: ID.
	8+
	DUP C@
	F_LENMASK AND
	
	BEGIN
		DUP 0>
	WHILE
		SWAP 1+
		DUP C@
		EMIT
		SWAP 1-
	REPEAT
	2DROP
;

: ?HIDDEN
	8+
	C@
	F_HIDDEN AND
;

: ?IMMEDIATE
	8+
	C@
	F_IMMED AND
;

: WORDS
	LATEST @
	BEGIN
		?DUP
	WHILE
		DUP ?HIDDEN NOT IF
			DUP ID.
			SPACE
		THEN
		@
	REPEAT
	CR
;

( forget a word and everything after it by setting the HERE pointer to its location )
: FORGET
	WORD FIND
	DUP @ LATEST !
	HERE !
;

( dump memory contents in a pretty way ) 
: DUMP
	BASE @ -ROT
	HEX

	BEGIN
		?DUP
	WHILE
		OVER 8 U.R
		SPACE

		( print up to 16 words on this line )
		2DUP
		1- 15 AND 1+
		BEGIN
			?DUP
		WHILE
			SWAP
			DUP C@
			2 .R SPACE
			1+ SWAP 1-
		REPEAT
		DROP

		2DUP 1- 15 AND 1+
		BEGIN
			?DUP
		WHILE
			SWAP
			DUP C@
			DUP 32 128 WITHIN IF
				EMIT
			ELSE
				DROP '.' EMIT
			THEN
			1+ SWAP 1-
		REPEAT
		DROP
		CR

		DUP 1- 15 AND 1+
		TUCK
		-
		>R + R>
	REPEAT

	DROP
	BASE !
;

( case statement is just a series of if statements chained together )
: CASE IMMEDIATE
	0
;

: OF IMMEDIATE
	' OVER ,
	' = ,
	[COMPILE] IF
	' DROP ,
;

: ENDOF IMMEDIATE
	[COMPILE] ELSE
;

: ENDCASE IMMEDIATE
	' DROP ,
	BEGIN
		?DUP
	WHILE
		[COMPILE] THEN
	REPEAT
;

( this word tries to find a specified codeword in the dictionary, and returns a 0 if it cannot find one )
( this is really inefficiant since there is no back pointer included, fix this later? )
: CFA>
	LATEST @
	BEGIN
		?DUP
	WHILE
		2DUP SWAP
		< IF
			NIP
			EXIT
		THEN
		@
	REPEAT
	DROP
	0
;

( this long word decompiles a given forth word )
: SEE
	WORD FIND
	HERE @
	LATEST @
	BEGIN
		2 PICK
		OVER
		<>
	WHILE
		NIP
		DUP @
	REPEAT
	
	DROP
	SWAP
	
	':' EMIT SPACE DUP ID. SPACE ( print out the first part of the word definition )
	DUP ?IMMEDIATE IF ." IMMEDIATE " THEN
	
	>DFA
	BEGIN
		2DUP >
	WHILE
		DUP @
		
		CASE
		' LIT OF
			8 + DUP @
			.
		ENDOF
		' LITSTRING OF
			[ CHAR S ] LITERAL EMIT '"' EMIT SPACE
			8 + DUP @
			SWAP 8 + SWAP
			2DUP TELL
			'"' EMIT SPACE
			+ ALIGNED
			8 -
		ENDOF
		' 0BRANCH OF
			." 0BRANCH ( "
			8 + DUP @
			.
			." ) "
		ENDOF
		' BRANCH OF
			." BRANCH ( "
			8 + DUP @
			.
			." ) "
		ENDOF
		' ' OF
			[ CHAR ' ] LITERAL EMIT SPACE
			8 + DUP @
			CFA>
			ID. SPACE
		ENDOF
		' EXIT OF
			2DUP
			8 +
			<> IF
				." EXIT "
			THEN
		ENDOF
			DUP
			CFA>
			ID. SPACE
		ENDCASE
		8 +
	REPEAT
	
	';' EMIT CR
	2DROP
;

( apparently forth has a thing called execution tokens that are similar to function pointers in C )
( :NONAME creates a dummy dictionary entry and calls it with EXECUTE )

: :NONAME
	0 0 CREATE
	HERE @
	DOCOL ,
	]
;

: ['] IMMEDAITE
	' LIT ,
;

( even weirder, forth has an exception mechanism! )\


." KForth, by Kyle Neil." CR
