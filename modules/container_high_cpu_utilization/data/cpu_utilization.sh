

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