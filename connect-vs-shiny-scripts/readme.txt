Requirements:

- sysstat installed on the server.
- shinyloadtest log file to replay with shinycannon
    shinyloadtest::record_session("http://example.com/shinyapp", output_file = "recording.log")

Scripts:

- run_connect.sh to load test an RStudio Connect server
- run_shinyproxy.sh to load test a ShinyProxy Server

Parameters that are configured inside the scripts:

  slt_url - **Required** The full url of the Shiny app to run the test on.
  sleep_time - The amount of time to allow the system to settle before starting the servers and after starting the servers.

Both scripts can be executed with their default configuration as they are.

Both scripts can accept the following arguments:

  run_***.sh sar_output_file sar_interval sar_duration slt_recording slt_duration slt_max_workers

    sar_output_file - The file name sar will save to on the server. Defaults to connect_test and shinyproxy_test.
    sar_interval - The frequency of system data logging. View the scripts for default values.
    sar_duration - The length of time to log data. View the scripts for default values.

    slt_recording - The shinyloadtest log file to replay. Defaults to rsconnect.log and shinyproxy.log.
    slt_duration - The length of time to run a shinyloadtest replay. View the scripts for default values.
    slt_max_workers - The maximum concurrent users for shinyloadtest. The script starts with 1 worker then doubles the workers after slt_duration. So it does 1, 2, 4, 8, and so on. View the scripts for default values.

Both scripts ssh into a "sandbox" server.

To get the sar output data after the load tests, log in to the server via ssh.
Then run the following to convert the sar binary data into csv:

  sadf -dh -- -r -u $sar_output_file > $filename.csv

  Where $sar_output_file is the output filename configured for the test.

Download the CSV file to your local machine via SFTP or other means available.

The CSV file will have the following data.

# hostname;interval;timestamp;CPU;%user;%nice;%system;%iowait;%steal;%idle[...];kbmemfree;kbavail;kbmemused;%memused;kbbuffers;kbcached;kbcommit;%commit;kbactive;kbinact;kbdirty

Please refer to the sysstat sar manpage for the descriptions. https://manpages.ubuntu.com/manpages/xenial/man1/sar.sysstat.1.html

