#!/bin/bash

function sortInput() {
	local __resultVar=$1
	local list=()
	for num in $2; do list+=($num) ; done
	
	IFS=$'\n'
	local result=($(sort -n <<<"${list[*]}"))
	eval $__resultVar="(${result[@]})"
	unset IFS
}

echo "Day 1 - distance between 2 lists"
read -p "Enter the first list using space separated input (e.g. 5 3 2):  " input1
read -p "Enter the second list using space separated input (e.g. 5 3 2):  " input2

sortInput firstList "$input1"
sortInput secondList "$input2"

totalDistance=0

length=${#firstList[@]} #assume 2 list should have the same size always or else this code won't work lol
for (( i = 0; i < length; i++ )); do
	distance=$((firstList[i] - secondList[i]))
	abs=${distance#-}
	totalDistance=$((totalDistance + abs))
done

echo 'part 1 answer:'
echo $totalDistance

#part 2 below
totalSimilarity=0

for num in ${firstList[@]}; do
	instances=$(echo ${secondList[*]} | grep -o $num | wc -l)
	similarity=$((instances * num))
	totalSimilarity=$((totalSimilarity + similarity))
done

echo "part 2 answer:"
echo $totalSimilarity