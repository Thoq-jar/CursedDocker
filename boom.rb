#!/usr/bin/env ruby

require 'open3'
require 'thread'

# Array to store container IDs with thread-safe access
@containers = Queue.new

def cleanup
  puts "\nReceived interrupt signal. Cleaning up all containers..."
  # Stop and remove all containers with the swift-mem image
  system("docker rm -f $(docker ps -q --filter ancestor=swift-mem) 2>/dev/null")
  exit(0)
end

# Set up cleanup on interrupt
Signal.trap("INT") { cleanup }
Signal.trap("TERM") { cleanup }

# Build the image once
system("docker build -t swift-mem .")

# Create containers simultaneously using threads
threads = []
100.times do |i|
  threads << Thread.new do
    output, status = Open3.capture2("docker run -d --rm swift-mem")
    container_id = output.strip
    @containers.push(container_id)
    puts "Started container #{i + 1} with ID: #{container_id}"
  end
end

# Wait for all threads to complete
threads.each(&:join)

puts "All containers started. Press Ctrl+C to stop all containers."

# Keep the script running until interrupted
sleep while true
