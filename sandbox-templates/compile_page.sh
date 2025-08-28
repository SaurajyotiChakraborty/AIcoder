#!/bin/bash

# Function to wait until Next.js server is accepting requests on localhost:3000
function ping_server() {
    counter=0
    response=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:3000")
    while [[ ${response} -ne 200 ]]; do
      let counter++
      if  (( counter % 20 == 0 )); then
        echo "Waiting for server to start..."
        sleep 0.1
      fi

      response=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:3000")
    done
}

# Start pinging server in the background
ping_server &

# Change to working directory and start Next.js dev server with Turbopack
cd /home/user && npx next dev --turbopack
