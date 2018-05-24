: '\n' 10 ;
: BL 32 ;

\ emit a \n
: CR '\n' EMIT ;
: SPACE BL EMIT ;

\logical defns
: TRUE 1 ;
: FALSE 0 ;
: NOT 0= ;

\take top of stack and compile LIT <top of stack>
: LITERAL IMMEDIATE
	' LIT ,
	,
;

\a literal ':'
: ':'
	[
	CHAR :
	]
	LITERAL
;

\ defining some character constants
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

\here we turn assembly-like "branch if zero" into
\structured programming constructs like "if" statements
: IF IMMEDIATE
	' 0BRANCH , \ compile a 0BRANCH
	HERE @ \save offset on stack
	0 , \ compile a dummy offset
;

\terminating the "if" statement
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

\allows for for-loop like construct
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

( print out all words previously defined )
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

\: ['] IMMEDAITE
\	' LIT ,
\;

( even weirder, forth has an exception mechanism! )
( verified up to here? )
: EXCEPTION-MARKER
	RDROP
	0
;

: CATCH
	DSP@ 8+ >R
	' EXCEPTION-MARKER 8+
	>R
	EXECUTE
;

: THROW
	?DUP IF
		RSP@
		BEGIN
			DUP R0 8- <
		WHILE
			DUP @
			' EXCEPTION-MARKER 8+ = IF
				8+
				RSP!
				
				DUP DUP DUP
				R>
				8-
				SWAP OVER
				!
				DSP! EXIT
			THEN
			8+
		REPEAT
		DROP
		
		CASE
		0 1- OF
			." Aborted!" CR
		ENDOF
			." Uncaught exception "
			DUP . CR
		ENDCASE
		QUIT
	THEN
;

: ABORT
	0 1- THROW
;

: PRINT-STACK-TRACE
	RSP@
	BEGIN
		DUP R0 8- <
	WHILE
		DUP @
		CASE
		' EXCEPTION-MARKER 8+ OF
			." CATCH ( DSP="
			8+ DUP @ U.
			." ) "
		ENDOF
			DUP
			CFA>
			?DUP IF
				2DUP
				ID.
				[ CHAR + ] LITERAL EMIT
				SWAP >DFA 8+ - .
			THEN
		ENDCASE
		8+
	REPEAT
	DROP
	CR
;

 ( C strings are a thing! )



( ." KForth, by Kyle Neil." CR )

( WARNING - this code is copy pasted.  Does not work on a 64-bit system. )

: Z" IMMEDIATE
	STATE @ IF	( compiling? )
		' LITSTRING ,	( compile LITSTRING )
		HERE @		( save the address of the length word on the stack )
		0 ,		( dummy length - we don't know what it is yet )
		BEGIN
			KEY 		( get next character of the string )
			DUP '"' <>
		WHILE
			HERE @ C!	( store the character in the compiled image )
			1 HERE +!	( increment HERE pointer by 1 byte )
		REPEAT
		0 HERE @ C!	( add the ASCII NUL byte )
		1 HERE +!
		DROP		( drop the double quote character at the end )
		DUP		( get the saved address of the length word )
		HERE @ SWAP -	( calculate the length )
		8-		( subtract 4 (because we measured from the start of the length word) )
		SWAP !		( and back-fill the length location )
		ALIGN		( round up to next multiple of 4 bytes for the remaining code )
		' DROP ,	( compile DROP (to drop the length) )
	ELSE		( immediate mode )
		HERE @		( get the start address of the temporary space )
		BEGIN
			KEY
			DUP '"' <>
		WHILE
			OVER C!		( save next character )
			1+		( increment address )
		REPEAT
		DROP		( drop the final " character )
		0 SWAP C!	( store final ASCII NUL )
		HERE @		( push the start address )
	THEN
;

: STRLEN 	( str -- len )
	DUP		( save start address )
	BEGIN
		DUP C@ 0<>	( zero byte found? )
	WHILE
		1+
	REPEAT

	SWAP -		( calculate the length )
;

: CSTRING	( addr len -- c-addr )
	SWAP OVER	( len saddr len )
	HERE @ SWAP	( len saddr daddr len )
	CMOVE		( len )

	HERE @ +	( daddr+len )
	0 SWAP C!	( store terminating NUL char )

	HERE @ 		( push start address )
;

: ARGC
	S0 @ @
;

: ARGV ( n -- str u )
	1+ CELLS S0 @ +	( get the address of argv[n] entry )
	@		( get the address of the string )
	DUP STRLEN	( and get its length / turn it into a FORTH string )
;

: ENVIRON	( -- addr )
	ARGC		( number of command line parameters on the stack to skip )
	2 +		( skip command line count and NULL pointer after the command line args )
	CELLS		( convert to an offset )
	S0 @ +		( add to base stack address )
;


: BYE		( -- )
	0		( return code (0) )
	SYS_EXIT	( system call number )
	SYSCALL1
;

: GET-BRK	( -- brkpoint )
	0 SYS_BRK SYSCALL1	( call brk(0) )
;

: UNUSED	( -- n )
	GET-BRK		( get end of data segment according to the kernel )
	HERE @		( get current position in data segment )
	-
	8 /		( returns number of cells )
;

(
	MORECORE increases the data segment by the specified number of (4 byte) cells.

	NB. The number of cells requested should normally be a multiple of 1024.  The
	reason is that Linux can't extend the data segment by less than a single page
	(4096 bytes or 1024 cells).

	This FORTH doesn't automatically increase the size of the data segment "on demand"
	(ie. when , (COMMA), ALLOT, CREATE, and so on are used).  Instead the programmer
	needs to be aware of how much space a large allocation will take, check UNUSED, and
	call MORECORE if necessary.  A simple programming exercise is to change the
	implementation of the data segment so that MORECORE is called automatically if
	the program needs more memory.
)
: BRK		( brkpoint -- )
	SYS_BRK SYSCALL1
;

: MORECORE	( cells -- )
	CELLS GET-BRK + BRK
;

(
	Standard FORTH provides some simple file access primitives which we model on
	top of Linux syscalls.

	The main complication is converting FORTH strings (address & length) into C
	strings for the Linux kernel.

	Notice there is no buffering in this implementation.
)

: R/O ( -- fam ) O_RDONLY ;
: R/W ( -- fam ) O_RDWR ;

: OPEN-FILE	( addr u fam -- fd 0 (if successful) | c-addr u fam -- fd errno (if there was an error) )
	-ROT		( fam addr u )
	CSTRING		( fam cstring )
	SYS_OPEN SYSCALL2 ( open (filename, flags) )
	DUP		( fd fd )
	DUP 0< IF	( errno? )
		NEGATE		( fd errno )
	ELSE
		DROP 0		( fd 0 )
	THEN
;

: CREATE-FILE	( addr u fam -- fd 0 (if successful) | c-addr u fam -- fd errno (if there was an error) )
	O_CREAT OR
	O_TRUNC OR
	-ROT		( fam addr u )
	CSTRING		( fam cstring )
	420 -ROT	( 0644 fam cstring )
	SYS_OPEN SYSCALL3 ( open (filename, flags|O_TRUNC|O_CREAT, 0644) )
	DUP		( fd fd )
	DUP 0< IF	( errno? )
		NEGATE		( fd errno )
	ELSE
		DROP 0		( fd 0 )
	THEN
;

: CLOSE-FILE	( fd -- 0 (if successful) | fd -- errno (if there was an error) )
	SYS_CLOSE SYSCALL1
	NEGATE
;

: READ-FILE	( addr u fd -- u2 0 (if successful) | addr u fd -- 0 0 (if EOF) | addr u fd -- u2 errno (if error) )
	>R SWAP R>	( u addr fd )
	SYS_READ SYSCALL3

	DUP		( u2 u2 )
	DUP 0< IF	( errno? )
		NEGATE		( u2 errno )
	ELSE
		DROP 0		( u2 0 )
	THEN
;

(
	PERROR prints a message for an errno, similar to C's perror(3) but we don't have the extensive
	list of strerror strings available, so all we can do is print the errno.
)
: PERROR	( errno addr u -- )
	TELL
	':' EMIT SPACE
	." ERRNO="
	. CR
;

(
	ASSEMBLER CODE ----------------------------------------------------------------------

	This is just the outline of a simple assembler, allowing you to write FORTH primitives
	in assembly language.

	Assembly primitives begin ': NAME' in the normal way, but are ended with ;CODE.  ;CODE
	updates the header so that the codeword isn't DOCOL, but points instead to the assembled
	code (in the DFA part of the word).

	We provide a convenience macro NEXT (you guessed what it does).  However you don't need to
	use it because ;CODE will put a NEXT at the end of your word.

	The rest consists of some immediate words which expand into machine code appended to the
	definition of the word.  Only a very tiny part of the i386 assembly space is covered, just
	enough to write a few assembler primitives below.
)

HEX

( Equivalent to the NEXT macro )
: NEXT IMMEDIATE AD C, FF C, 20 C, ;

: ;CODE IMMEDIATE
	[COMPILE] NEXT		( end the word with NEXT macro )
	ALIGN			( machine code is assembled in bytes so isn't necessarily aligned at the end )
	LATEST @ DUP
	HIDDEN			( unhide the word )
	DUP >DFA SWAP >CFA !	( change the codeword to point to the data area )
	[COMPILE] [		( go back to immediate mode )
;

( The i386 registers )
: EAX IMMEDIATE 0 ;
: ECX IMMEDIATE 1 ;
: EDX IMMEDIATE 2 ;
: EBX IMMEDIATE 3 ;
: ESP IMMEDIATE 4 ;
: EBP IMMEDIATE 5 ;
: ESI IMMEDIATE 6 ;
: EDI IMMEDIATE 7 ;

( i386 stack instructions )
: PUSH IMMEDIATE 50 + C, ;
: POP IMMEDIATE 58 + C, ;

( RDTSC instruction )
: RDTSC IMMEDIATE 0F C, 31 C, ;

DECIMAL

(
	RDTSC is an assembler primitive which reads the Pentium timestamp counter (a very fine-
	grained counter which counts processor clock cycles).  Because the TSC is 64 bits wide
	we have to push it onto the stack in two slots.
)
: RDTSC		( -- lsb msb )
	RDTSC		( writes the result in %edx:%eax )
	EAX PUSH	( push lsb )
	EDX PUSH	( push msb )
;CODE

(
	INLINE can be used to inline an assembler primitive into the current (assembler)
	word.

	For example:

		: 2DROP INLINE DROP INLINE DROP ;CODE

	will build an efficient assembler word 2DROP which contains the inline assembly code
	for DROP followed by DROP (eg. two 'pop %eax' instructions in this case).

	Another example.  Consider this ordinary FORTH definition:

		: C@++ ( addr -- addr+1 byte ) DUP 1+ SWAP C@ ;

	(it is equivalent to the C operation '*p++' where p is a pointer to char).  If we
	notice that all of the words used to define C@++ are in fact assembler primitives,
	then we can write a faster (but equivalent) definition like this:

		: C@++ INLINE DUP INLINE 1+ INLINE SWAP INLINE C@ ;CODE

	One interesting point to note is that this "concatenative" style of programming
	allows you to write assembler words portably.  The above definition would work
	for any CPU architecture.

	There are several conditions that must be met for INLINE to be used successfully:

	(1) You must be currently defining an assembler word (ie. : ... ;CODE).

	(2) The word that you are inlining must be known to be an assembler word.  If you try
	to inline a FORTH word, you'll get an error message.

	(3) The assembler primitive must be position-independent code and must end with a
	single NEXT macro.

	Exercises for the reader: (a) Generalise INLINE so that it can inline FORTH words when
	building FORTH words. (b) Further generalise INLINE so that it does something sensible
	when you try to inline FORTH into assembler and vice versa.

	The implementation of INLINE is pretty simple.  We find the word in the dictionary,
	check it's an assembler word, then copy it into the current definition, byte by byte,
	until we reach the NEXT macro (which is not copied).
)
HEX
: =NEXT		( addr -- next? )
	   DUP C@ AD <> IF DROP FALSE EXIT THEN
	1+ DUP C@ FF <> IF DROP FALSE EXIT THEN
	1+     C@ 20 <> IF      FALSE EXIT THEN
	TRUE
;
DECIMAL

( (INLINE) is the lowlevel inline function. )
: (INLINE)	( cfa -- )
	@			( remember codeword points to the code )
	BEGIN			( copy bytes until we hit NEXT macro )
		DUP =NEXT NOT
	WHILE
		DUP C@ C,
		1+
	REPEAT
	DROP
;

: INLINE IMMEDIATE
	WORD FIND		( find the word in the dictionary )
	>CFA			( codeword )

	DUP @ DOCOL = IF	( check codeword <> DOCOL (ie. not a FORTH word) )
		." Cannot INLINE FORTH words" CR ABORT
	THEN

	(INLINE)
;

HIDE =NEXT

(
	NOTES ----------------------------------------------------------------------

	DOES> isn't possible to implement with this FORTH because we don't have a separate
	data pointer.
)

(
	WELCOME MESSAGE ----------------------------------------------------------------------

	Print the version and OK prompt.
)

: WELCOME
	S" TEST-MODE" FIND NOT IF
		." Kforth, version " VERSION . CR
		UNUSED . ." cells remaining." CR
		." ok "
	THEN
;

WELCOME
HIDE WELCOME
