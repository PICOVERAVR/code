: '\n' 10 ;
: BL 32 ;

: CR '\n' EMIT ;
: SPACE BL EMIT ;
: NEGATE 0 SWAP - ;

: TRUE 1 ;
: FALSE 0 ;
: NOT 0= ;


