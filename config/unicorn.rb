worker_processes 2 # amount of unicorn workers to spin up
timeout 3000

@resque_pid2 = nil
before_fork do |server, worker|
  @resque_pid2 ||= spawn("bundle exec clockwork config/clock.rb")
end