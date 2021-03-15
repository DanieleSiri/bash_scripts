#!/bin/bash
# The "fog index" of a passage of text estimates its reading difficulty, as a number corresponding roughly to a school grade level.
# For example, a passage with a fog index of 12 should be comprehensible to anyone with 12 years of schooling.
# This script uses Gunning algorithm.

if [ $# != 1 ]
then
	echo "script requires 1 argument to run"
	echo "usage: `basename $0` path/to/file"
	exit 1
fi

file=$1

# get a segment of text with at least 100 words
until [ `wc -w <<< $selection` -gt 100 ]
do
	selection=`shuf -n 10 $file`
done

# total words in the segment
word_count=$(wc -w <<< $selection)

# create an array called "sentences" splitting the sentences by .
readarray sentences -d'\n' <<< $(echo $selection | awk 'BEGIN{RS="\\. "}1')

# counting how many sentences
sentence_count=${#sentences[@]}
echo "sentence count: $sentence_count"

# average words per sentence using bc for floating division
avg_words_per_sentence=$(bc -l <<< "$word_count / $sentence_count")
printf "average words per sentence: %.5g\n" $avg_words_per_sentence

# creating a tmp file for analyzing the syllables by splitting all the words in the segment
for word in $selection
do
        echo $word >> tmp
done

# counts how many words have more than 3 syllables
long_words=$(awk -F '[aeiouy]+' 'NF{if (NF>2) print NF}' tmp | column -t | wc -l)
echo "long words: $long_words"

# cleanup tmp file
rm tmp

# count number of difficult words by using bc for floating division
difficult_words=$(bc -l <<< "$long_words / $word_count")
printf  "difficult words: %.2g\n" $difficult_words

# Gunning algorithm formula for calculating fog index
g_fog_index=$(echo "(0.4 * ( $avg_words_per_sentence + $difficult_words ))" | bc)
# rounding the value to the closest int
printf "FOG INDEX = %.0f\n" $g_fog_index