
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Container High CPU Utilization
---

Container high CPU utilization is an incident type that occurs when a container's CPU utilization exceeds a certain threshold. It may indicate an issue with the containerized application or the container itself, and can potentially cause performance issues or even service downtime. This incident type requires immediate attention to identify the root cause and take necessary actions to prevent further impact.

### Parameters
```shell
export CONTAINER_NAME="PLACEHOLDER"

export PROCESS_NAME="PLACEHOLDER"

export CPU_LIMIT="PLACEHOLDER"
```

## Debug

### Get the list of containers running on the instance
```shell
docker ps
```

### Check the CPU usage of a specific container
```shell
docker stats ${CONTAINER_NAME}
```

### Check the CPU usage of the instance
```shell
top
```

### Check the CPU usage of all processes
```shell
ps aux
```

### Check the CPU usage of a specific process
```shell
ps aux | grep ${PROCESS_NAME}
```

### Check the memory usage of the instance
```shell
free -m
```

### Check the disk usage of the instance
```shell
df -h
```

### Check the system logs
```shell
dmesg
```

### Check the logs of a specific container
```shell
docker logs ${CONTAINER_NAME}
```

### Check the logs of a specific process
```shell
journalctl -u ${PROCESS_NAME}
```

### Check the network connections and status
```shell
netstat -tupan
```

### Check the open files and their owners
```shell
lsof
```

### The container has been assigned more CPU resources than it actually needs, leading to high utilization.
```shell


#!/bin/bash



# Set the threshold for high CPU utilization (in percentage)

THRESHOLD=80



# Get the CPU utilization of the container

CPU_UTILIZATION=$(docker stats ${CONTAINER_NAME} --no-stream --format "{{.CPUPerc}}")



# Remove the '%' character from the CPU utilization value

CPU_UTILIZATION=${CPU_UTILIZATION%\%}



# Check if the CPU utilization exceeds the threshold

if (( $(echo "$CPU_UTILIZATION > $THRESHOLD" |bc -l) )); then

  echo "Container CPU utilization is high: $CPU_UTILIZATION%"

  

  # Get the CPU limit of the container

  CPU_LIMIT=$(docker inspect ${CONTAINER_NAME} --format '{{.HostConfig.CpuShares}}')

  echo "Container CPU limit: $CPU_LIMIT"

  

  # Get the CPU usage of the host machine

  HOST_CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

  echo "Host machine CPU usage: $HOST_CPU_USAGE%"



  # Check if the container is using more CPU resources than it has been allocated

  if (( $(echo "$CPU_LIMIT < $CPU_UTILIZATION" |bc -l) )); then

    echo "Container has been assigned more CPU resources than it actually needs."

  else

    echo "Container is using the allocated CPU resources efficiently."

  fi

else

  echo "Container CPU utilization is normal: $CPU_UTILIZATION%"

fi


```

## Repair

### Adjust the container's CPU limits to better match its actual usage.
```shell


#!/bin/bash



# Set the container name and CPU limit values

CONTAINER_NAME=${CONTAINER_NAME}

CPU_LIMIT=${CPU_LIMIT}



# Stop the container

docker stop $CONTAINER_NAME



# Update the container's CPU limits

docker update --cpus=$CPU_LIMIT $CONTAINER_NAME



# Start the container

docker start $CONTAINER_NAME


```