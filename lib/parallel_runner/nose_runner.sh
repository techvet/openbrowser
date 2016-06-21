# Pass an argument of a comma seperated list of tests to run
# example: ./parallel_runner.sh "test_file.py, test_file.py:TestClass, test_file.py:TestClass.test_case"

IN=$(echo "$1" | tr -d ' ')
set -- "$IN"
IFS=","; declare -a TEST_FILE_ARRAY=($*)
i=0
task_length=${#TEST_FILE_ARRAY[@]}

for test in "${TEST_FILE_ARRAY[@]}"
do
  echo "Running $test"
  if [ $((i+1)) -ge "$task_length" ]; then
    echo '------------------AT THE END OF TEST FILE LIST-------------'
    nosetests --with-xunit --xunit-file="$test".xml "$test" & wait
  else
    i=$((i+1))
    nosetests --with-xunit --xunit-file="$test".xml "$test" &
  fi
done
