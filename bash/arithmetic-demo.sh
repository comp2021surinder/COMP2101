#!/bin/bash
#
# this script demonstrates doing arithmetic

# Task 1: Remove the assignments of numbers to the first and second number variables. Use one or more read commands to get 3 numbers from the user.
# Task 2: Change the output to only show:
#    the sum of the 3 numbers with a label
#    the product of the 3 numbers with a label

firstnum=6
secondnum=2
thirdnum=4
sum=$((firstnum + secondnum + thirdnum))
multiply=$((firstnum * secondnum * thirdnum))
#fpdividend=$(awk "BEGIN{printf \"%.2f\", $firstnum/$secondnum/$thirdnum}")

cat <<EOF
$firstnum plus $secondnum plus $thirdnum is $sum
Product of the 3 numbers is : $multiply 
EOF
