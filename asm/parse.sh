RP=$(cat $1 | grep -c "(")
LP=$(cat $1 | grep -c ")")

if [ RP != LP ]
then
	echo 'missing set of ()'
	echo "(: $RP, ): $LP"
fi

