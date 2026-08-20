# Server Performance Statistics

A simple Bash script to analyze basic Linux server performance statistics.

https://github.com/venkatesh-mutyala-ai/server-stats


## Features

The script displays:

- Total CPU usage
- Total memory usage
- Used memory
- Free memory
- Memory usage percentage
- Disk usage
- Disk free space
- Disk usage percentage
- Top 5 processes by CPU usage
- Top 5 processes by memory usage
- Hostname
- Server uptime
- Report date and time

## Requirements

The script works on most Linux distributions.

Tested commands:

- Bash
- ps
- free
- df
- awk
- sleep
- hostname
- uptime

No additional software installation is required on most Linux servers.

## Installation

Clone the repository:

    git clone https://github.com/venkatesh-mutyala-ai/server-stats

Go to the project directory:

    cd server-stats

Make the script executable:

    chmod +x server-stats.sh

Run the script:

    ./server-stats.sh

Alternatively:

    bash server-stats.sh

## Example

    ./server-stats.sh

Example output:

    ============================================================
                  SERVER PERFORMANCE STATISTICS
    ============================================================
    Hostname : APP-SERVER-01
    Date     : Thu Aug 20 11:15:20 IST 2026
    Uptime   : up 15 days, 4 hours

    CPU USAGE
    ------------------------------------------------------------
    Total CPU Usage : 18.42%

    MEMORY USAGE
    ------------------------------------------------------------
    Total Memory : 64000 MB
    Used Memory  : 28450 MB
    Free Memory  : 35550 MB
    Usage        : 44.45%

    DISK USAGE
    ------------------------------------------------------------
    SIZE       USED       FREE       USAGE    MOUNT
    100G       42G        58G        42%      /

    TOP 5 PROCESSES BY CPU USAGE
    ------------------------------------------------------------
        PID USER         %CPU %MEM COMMAND
       2451 mysql        31.2  8.5 mysqld
       1842 root         12.4  1.2 java
       3261 appuser       7.8  3.4 dotnet

    TOP 5 PROCESSES BY MEMORY USAGE
    ------------------------------------------------------------
        PID USER         %CPU %MEM COMMAND
       2451 mysql        31.2  8.5 mysqld
       1842 root         12.4  7.1 java
       3261 appuser       7.8  3.4 dotnet

## How CPU Usage Is Calculated

CPU usage is calculated using `/proc/stat`.

The script:

1. Reads the CPU counters.
2. Waits for one second.
3. Reads the counters again.
4. Calculates the difference.
5. Calculates the percentage of time spent doing non-idle work.

This provides a more meaningful CPU utilization measurement than simply reading a single CPU value.

## Memory Usage

Memory information is collected using:

    free -m

The script calculates used memory based on available memory.

This gives a more useful representation of actual memory pressure than simply treating Linux filesystem cache as unavailable memory.

## Disk Usage

Disk information is collected using:

    df -h

Temporary filesystems such as `tmpfs` and `devtmpfs` are excluded from the report.

## Process Monitoring

CPU processes are obtained using:

    ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu

Memory processes are obtained using:

    ps -eo pid,user,%cpu,%mem,comm --sort=-%mem

Only the top five processes are displayed.

## Compatibility

The script is intended for Linux systems such as:

- Ubuntu
- Debian
- RHEL
- CentOS
- Rocky Linux
- AlmaLinux
- Amazon Linux

## Project Structure

    server-stats/
    ├── server-stats.sh
    └── README.md

## Future Improvements

Possible improvements include:

- Network usage statistics
- Load average
- TCP connection count
- Logged-in users
- Process count
- Disk I/O
- Network I/O
- CPU temperature
- Alert thresholds
- CSV output
- JSON output
- Log file generation
- Email notifications
- HTML reports
- Historical performance tracking
- Prometheus integration

## License

This project is available for learning and educational purposes.
