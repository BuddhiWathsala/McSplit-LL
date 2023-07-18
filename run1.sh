#!/bin/bash

source configs/run.env
shopt -s globstar
file_name=results/${DATA_DIR}_${MCSP_HEURISTIC}_${TIMEOUT}.txt
lockdir=/tmp/mcsp_ll.lock
rm -f $file_name
rm -f $execution_file
echo "Pattern, Target, Solution size, Nodes, Cut branches, Conflicts, Elapsed time, Best time" >> ${file_name}
echo $TYPE
echo $DATA_DIR
echo ${TIMEOUT}

write_output () {
  if mkdir -- "$lockdir" 2> /dev/null
  then
    # echo $2
    echo $* >> $file_name
    rm -rf $lockdir
    return 0
  else
    return 1
  fi
}

task () {
  out1=$(./bin/run.o $MCSP_HEURISTIC ./${1} ./${2} -l -q -t ${TIMEOUT})
  out1="${1}, ${2}, ${out1}"
  # echo $out1
  available=1
  while [ "$available" -eq 1 ]
  do
    write_output $out1
    available=$?
  done
  return
}

if [[ $TYPE -eq 1 ]]
then
  files=($(ls -la -d data/${DATA_DIR}/** | grep -v "^[d]" | awk '{print $(NF)}'))
  len=$([ $TEST == true ] && echo ${TEST_MAX} || echo ${#files[@]})
  echo $len
  let len=$len-1
  for i in $(seq 0 2 $len)
  do
    task ./${files[i]} ./${files[i+1]} &
    if [[ $i%$N_PARALLEL-1 -eq 0 ]]
    then
      wait
    fi
  done
  wait
elif [[ $TYPE -eq 2 ]] 
then
  patterns=($(ls -la -d data/${DATA_DIR}/patterns/** | grep -v "^[d]" | awk '{print $(NF)}'))
  targets=($(ls -la -d data/${DATA_DIR}/targets/** | grep -v "^[d]" | awk '{print $(NF)}'))
  len_patterns=$([ $TEST == true ] && echo ${TEST_MAX} || echo ${#patterns[@]})
  len_targets=$([ $TEST == true ] && echo ${TEST_MAX} || echo ${#targets[@]})
  total=$(($len_patterns*$len_targets))
  echo $total
  let len_patterns=$len_patterns-1
  let len_targets=$len_targets-1
  for i in $(seq 0 $len_patterns)
  do
    for j in $(seq 0 $len_targets)
    do
      task ${patterns[i]} ${targets[j]} &
      if [[ $j%$N_PARALLEL -eq 0 ]]
      then
        wait
      fi
    done
  done
  wait
else
  files=($(ls -la -d data/${DATA_DIR}/** | grep -v "^[d]" | awk '{print $(NF)}'))
  len=$([ $TEST == true ] && echo ${TEST_MAX} || echo ${#files[@]})
  total=$(($len*($len-1)/2))
  echo $total
  let len=$len-1
  for i in $(seq 0 1 $len)
  do
    let num=i+1
    for j in $(seq $num 1 $len)
    do
      task ${files[i]} ${files[j]} &
      if [[ $i%$N_PARALLEL-1 -eq 0 ]]
      then
        wait
      fi
    done
  done
  wait
fi

