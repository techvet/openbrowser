# Pass an argument of a comma seperated list of tests to run
# example: ./parallel_runner.sh "first_test, second_test"

# set the input and remove any spaces
IN=$(echo "$1" | tr -d ' ')
set -- "$IN"

# split on the comma and create a an array of test commands we can iterate through
IFS=","; declare -a TEST_FILE_ARRAY=($*)

i=0
task_length=${#TEST_FILE_ARRAY[@]}

for test in "${TEST_FILE_ARRAY[@]}"
do
  echo "Running $test"
  # detect if we are on the last command to run and add a wait at the end
  if [ $((i+1)) -ge "$task_length" ]; then
    echo '------------------AT THE END OF TEST FILE LIST-------------'
    test_execution_command "$test" & wait
  else
    i=$((i+1))
    test_execution_command "$test" &
  fi
done

