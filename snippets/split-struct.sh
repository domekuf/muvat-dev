START=$(cat $1 | grep -nE "(struct +$2 +{|})" | grep -nEA1 "struct +$2 +{" | tr ":" "\n" | tr "-" "\n" | sed -n '2,2p')
END=$(cat $1 | grep -nE "(struct +$2 +{|})" | grep -nEA1 "struct +$2 +{" | tr ":" "\n" | tr "-" "\n" | sed -n '5,5p')

if [ -z "$START" -a "${START+xxx}" = "xxx" ];
then

START=$(cat $1 | grep -nE "(struct +{|} +$2)" | grep -nEB1 "$2" | tr ":" "\n" | tr "-" "\n" | sed -n '2,2p')
END=$(cat $1 | grep -nE "(struct +{|} +$2)" | grep -nEB1 "$2" | tr ":" "\n" | tr "-" "\n" | sed -n '5,5p')

fi

echo "/*"
echo "start:$START"
echo "end:$END"
echo "*/"

sed -n "$START","$END"p $1

