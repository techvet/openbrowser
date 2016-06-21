## Parallel Runner 

### Purpose:
Document different methods of running parallel integration tests and provide scripts you can use or modify for running your own tests.

#### General Idea:
If you have integration tests that you want to run in small groups this is a very simple pattern that is easy to run on any continuous integration server or locally. Ideally you should be able to sub-divide test execution into individual shell commands and leverage parallel shells for concurrency and creating reports for each test run to be read by a continuous integration server. 

parallel shell commands can be executed using `&` and `wait` like this

```
first_test_execution_command & second_test_execution_command & wait
```
The best thing about this is it's extremely flexible, doesn't require invasive code changes to your tests or installing additional packages. This can be used easily on local dev machines as well to speed up executing tests and debugging pesky tests that have concurrency.

You can even just pass the tests into a script and now have a handy source controlled script for running any subset of your tests on jenkins. 

```
# Pass an argument of a comma seperated list of tests to run
# example: ./parallel_runner.sh "test_health.py,test_login.py:TestLogin.test_login"

# set the input and remove any spaces
IN=$(echo "$1" | tr -d ' ')
set -- "$IN"

# split on the command and create a an array of test commands we can iterate through
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
```


Included example scripts demonstrate how we do this for different test frameworks.