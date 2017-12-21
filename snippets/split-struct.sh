START=$(cat $1 | grep -nE "(struct +$2 +{|})" | grep -nEA1 "struct +$2 +{" | tr ":" "\n" | tr "-" "\n" | sed -n '2,2p')
END=$(cat $1 | grep -nE "(struct +$2 +{|})" | grep -nEA1 "struct +$2 +{" | tr ":" "\n" | tr "-" "\n" | sed -n '5,5p')

echo "/*"
echo "start:$START"
echo "end:$END"
echo "*/"

sed -n "$START","$END"p $1

