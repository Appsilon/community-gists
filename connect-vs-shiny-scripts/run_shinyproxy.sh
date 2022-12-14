#!/bin/bash

sar_output_file=${1:-shinyproxy_test}
sar_interval=${2:-5}     # 5 seconds
sar_duration=${3:-900}   # 15 minutes

slt_recording=${4:-shinyproxy.log}
slt_duration=${5:-1}     # 1 minutes
slt_max_workers=${6:-8}

slt_url=http://example.com/01_hello/

sleep_time=60            # 60 seconds

echo "Starting system log"
ssh sandbox "rm $sar_output_file"
nohup ssh sandbox "sar -r $sar_interval $sar_duration -o $sar_output_file" &>/dev/null&

echo "Get a baseline reading"
sleep $sleep_time

echo "Start docker and shinyproxy"
ssh sandbox "sudo service docker start"
ssh sandbox "sudo service shinyproxy start"
sleep $sleep_time

echo "Start load testing"

rm -rf shinyproxy_run_*

for ((work=1; work<=slt_max_workers; work=work*2)) 
do
  echo "Running $work workers."
  shinycannon $slt_recording slt_url \
    --workers $work \
    --loaded-duration-minutes $slt_duration \
    --output-dir shinyproxy_run_$work
done

echo "Stop docker and shinyproxy"
ssh sandbox "sudo service docker stop"
ssh sandbox "sudo service shinyproxy stop"

echo "Clear RAM"
ssh sandbox "sudo sync"
ssh sandbox 'sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"'

echo "Done!"

