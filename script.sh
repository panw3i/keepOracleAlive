#!/bin/bash

# Calculate available memory in bytes
MEM_AVAILABLE=$(awk '/MemAvailable/{print $2}' /proc/meminfo)

# Calculate target memory usage in bytes
MEM_TARGET=$(echo "$MEM_AVAILABLE * 0.8" | bc | awk '{printf("%d", $1)}')

# Start infinite loop to consume memory
while true; do
  # Check current memory usage
  MEM_USED=$(awk '/Active/{print $2}' /proc/meminfo)
  
  # If current usage is less than target usage, allocate more memory
  if [ "$MEM_USED" -lt "$MEM_TARGET" ]; then
    BLOCK_SIZE=$(echo "($MEM_TARGET - $MEM_USED) / 1024" | bc)
    BLOCK_COUNT=$(echo "$BLOCK_SIZE / 4096" | bc)
    dd if=/dev/zero of=/dev/null bs=4096 count=$BLOCK_COUNT iflag=fullblock
  fi
  
  # Wait for 1 second before checking memory usage again
  sleep 1
done
