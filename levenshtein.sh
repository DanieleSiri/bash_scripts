#!/bin/bash
# the levenshtein distance between two strings is the minimum number of single-character edits required to change 1 string into the other

# arguments check
if [ $# -ne 2 ]
then
	echo "script requires two arguments to execute"
	echo "usage: `basename $0` string1 string2"
	exit 1
fi

# function to calculate the minimum
min() {
	printf "%s\n" "$@" | sort -g | head -n1
}

levenshtein() {
# if strings are equal
if [ $1 = $2 ]
then
	echo "strings are equal, levenshtein distance = 0"
	exit 0
fi

# create array of chars
declare -a str1
declare -a str2
# declaring 2 integers of cost and minimum value to calculate
declare -i subcost
declare -i k

for i in `echo $1 | grep -o .`
do
	str1+=("$i")
done

for j in `echo $2 | grep -o .`
do
	str2+=("$j")
done

# create matrix and initialize it
declare -A matrix
# initialize all values to 0
for i in `seq 0 ${#1}`
do
	for j in `seq 0 ${#2}`
	do
		matrix[$i,$j]=0
	done
done

# initialize it with values from the range
for i in `seq 0 ${#1}`
do
	matrix[$i,0]=$i
done
for j in `seq 0 ${#2}`
do
	matrix[0,$j]=$j
done

# iterative algorithm with full matrix analysis
for i in `seq 1 ${#1}`
do
	for j in `seq 1 ${#2}`
        do
			if [ "${str1[($i-1)]}" = "${str2[($j-1)]}" ]
			then
				subcost=0
			else
				subcost=1
			fi
			k=$(min ${matrix[$(($i-1)),$(($j))]}+1 ${matrix[$(($i)),$(($j-1))]}+1 ${matrix[$(($i-1)),$(($j-1))]}+$subcost)
			matrix[$(($i)),$(($j))]=$(($k))
        done
done
echo "levenshtein distance between $1 and $2 = ${matrix[${#1},${#2}]}"
}

levenshtein $1 $2