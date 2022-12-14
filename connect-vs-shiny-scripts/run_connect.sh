#!/bin/bash

sar_output_file=${1:-connect_test}
sar_interval=${2:-5}     # 5 seconds
sar_duration=${3:-1020}   # 17 minutes

slt_recording=${4:-rsconnect.log}
slt_duration=${5:-1}     # 1 minutes
slt_max_workers=${6:-64}

slt_url=http://example.com/01_hello/

sleep_time=60            # 60 seconds

echo "Starting system log"
ssh sandbox "rm $sar_output_file"
nohup ssh sandbox "sar -r $sar_interval $sar_duration -o $sar_output_file" &>/dev/null&

echo "Get a baseline reading"
sleep $sleep_time

echo "Start connect"
ssh sandbox "sudo service rstudio-connect start"
sleep $sleep_time

echo "Start load testing"

rm -rf connect_run_*

for ((work=1; work<=slt_max_workers; work=work*2)) 
do
  echo "Running $work workers."
  shinycannon $slt_recording $slt_url \
    --workers $work \
    --loaded-duration-minutes $slt_duration \
    --output-dir connect_run_$work
done

echo "Stop docker and shinyproxy"
ssh sandbox "sudo service rstudio-connect stop"

echo "Clear RAM"
ssh sandbox "sudo sync"
ssh sandbox 'sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"'

echo "Done!"

