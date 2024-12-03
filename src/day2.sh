#!/bin/bash
#set -x
mapfile -t input < <(tr -d '\r' < "day2_input.txt") #hardcode input. remove '\r' in file. annoying windows bug

# 1 is var. 2 is list, 3 is problem index, 4 is size
function dampen() {
	local __resultVar=$1
	local list=($2)
	local toIgnore=$3
	local result=()
	for (( a = 0; a < $4; a++ )); do
	  if [ "$toIgnore" -eq "$a" ]
	    then
	      continue
	  fi
	  result+=(${list[a]})
	done
  eval $__resultVar="(${result[*]})"
}

function isvalid() {
  local row=($1)
  local pass=1
	for (( y = 0; y < $(( ${#row[*]} - 1 )); y++ )); do
      local pass=-1
      local distance="$((row[y] - row[y+1]))"

      #if first index, determine direction
      if [ $y -eq 0 ];
        then
          local direction=$([ $distance -gt 0 ] && echo "desc" || echo "asc")
      fi
      #ensure they are in 1 direction
      if [ "$direction" == "asc" ] && [ $distance -gt 0 ];
        then
          #echo 'wrong direction asc'
          pass=$y
          break
      fi
      if [ "$direction" == "desc" ] && [ $distance -lt 0 ];
        then
          #echo 'wrong direction desc'
          pass=$y
          break
      fi

      #Any two adjacent levels differ by at least one and at most three.
      if [ ${distance#-} -gt 3 ] || [ ${distance} -eq 0 ]
        then
          pass=$y
          break
      fi
      done

      echo $pass
}

safeCount=0
for (( i = 0; i < ${#input[*]}; i++ )); do
  IFS=" " read -r -a row <<< "${input[i]}"
  result=$(isvalid "${row[*]}")

  if [ $result -eq -1 ]
    then
      safeCount=$((safeCount + 1))
  fi
done

echo "safe count below"
echo $safeCount
echo ""

safeCountWithDampener=0
i=0
for (( i = 0; i < ${#input[*]}; i++ )); do
  IFS=" " read -r -a row <<< "${input[i]}"

  result=$(isvalid "${row[*]}")
  if [ $result -eq -1 ]
    then
      safeCountWithDampener=$(($safeCountWithDampener + 1))
      continue
  fi

  #if fails, last chance to save this row
  dampen left "${row[*]}" "$((result-1))" ${#row[@]}
  dampen mid "${row[*]}" "$((result))" ${#row[@]}
  dampen right "${row[*]}" "$((result+1))" ${#row[@]}
  resultLeft=$(isvalid "${left[*]}")
  resultMid=$(isvalid "${mid[*]}")
  resultRight=$(isvalid "${right[*]}")
  if [ $resultLeft -eq -1 ] || [ $resultMid -eq -1 ] || [ $resultRight -eq -1 ]
    then
      safeCountWithDampener=$(($safeCountWithDampener + 1))
      continue
  fi

done

echo "safe count with dampener below"
echo $safeCountWithDampener