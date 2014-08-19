if File.exist?("/etc/govuk/unicorn.rb")
  # Include the default config file.
  self.instance_eval(File.read("/etc/govuk/unicorn.rb"))

  # EFG lives in its own little world - it has a server all to itself.
  worker_processes 3

  # Currently we have some reports on the request thread that take a long-time
  # to generate. Change the timeout for a worker to finish the response from
  # default of 60 seconds to 120 seconds.
  timeout 120
else
  worker_processes 2

  before_fork do |server, worker|
    Signal.trap 'TERM' do
      puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
      Process.kill 'QUIT', Process.pid
    end

    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
  end

  after_fork do |server, worker|
    Signal.trap 'TERM' do
      puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
    end

    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
  end
end
