

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