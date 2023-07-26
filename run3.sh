#!/bin/bash
source configs/run.env
shopt -s globstar
lockdir=/tmp/mcsp_ll.lock
write_output () {
  if mkdir -- "$lockdir" 2> /dev/null
  then
    # echo ${@: -1}
    echo ${@:1:$#-1} >> ${@: -1}
    rm -rf $lockdir
    return 0
  else
    return 1
  fi
}

task () {
  out1=$(./bin/run.o $MCSP_HEURISTIC ./${1} ./${2} -l -q -t ${TIMEOUT})
  out1="${1}, ${2}, ${out1}"
#   out1=${out1//[,]/' '} 
  # echo $out1
  available=1
  while [ "$available" -eq 1 ]
  do
    write_output ${out1} ${3}
    available=$?
  done
  return
}

files=("si" "scalefree" "scalefree" "meshes-CVIU11" "LV" "largerLV" "images-CVIU11" "images-PR15" "biochemicalReactions")
files=("biochemicalReactions")
for f in ${files[@]}; do
    file_name=indicators/${f}_data.txt
    results_file_name=results/${f}_${MCSP_HEURISTIC}_${TIMEOUT}.txt
    # rm -f $results_file_name
    let i=0
    let j=0
    if [ -e $results_file_name ]
    then
      while IFS= read -r line
      do 
          j=$((j + 1))
      done <"$results_file_name"
    fi
    
    while IFS=',' read -r file1 file2
    do
        if [[ $j -ne 0 ]]
        then
          j=$((j - 1))
          continue
        fi
        # echo $file1 $file2 $results_file_name
        task $file1 $file2 $results_file_name
        if [[ $i%$N_PARALLEL -eq 0 ]]
        then
            wait
        fi
        i=$((i + 1))
    done <"$file_name"
done



