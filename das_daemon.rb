require 'rubygems'
require 'logger'
require "win32/service"
include Win32

# installs polling loop as Windows service
# based on http://blog.saush.com/2006/10/22/processing-rails-task-in-the-background/

SERVICE_NAME = "DAS Polling Daemon"
SERVICE_DISPLAYNAME = "DasPollingDaemon"

if ARGV[0] == "install"
  svc = Service.new
  svc.create_service{ |s|
    s.service_name = SERVICE_NAME
    s.display_name = SERVICE_DISPLAYNAME
    s.binary_path_name = 'ruby ' + File.expand_path($0)
    s.dependencies = []
  }
  svc.close
  puts "installed"
elsif ARGV[0] == "start"
  Service.start(SERVICE_NAME)
  # do stuff before starting
  puts "Ok, started"
elsif ARGV[0] == "stop"
  Service.stop(SERVICE_NAME)
  # do stuff before stopping
  puts "Ok, stopped"
elsif ARGV[0] == "uninstall" || ARGV[0] == "delete"
  begin
    Service.stop(SERVICE_NAME)
  rescue
  end
  Service.delete(SERVICE_NAME)
  # do stuff before deleting
  puts "deleted"
elsif ARGV[0] == "pause"
  Service.pause(SERVICE_NAME)
  # do stuff before pausing
  puts "Ok, paused"
elsif ARGV[0] == "resume"
  Service.resume(SERVICE_NAME)
  # do stuff before resuming
  puts "Ok, resumed"
else

  if ENV["HOMEDRIVE"]!=nil
  puts "No option provided.  You must provide an option.  Exiting..."
  exit
  end

## SERVICE BODY START
class Daemon
  logger = Logger.new("c:/das/log/development.log")

  def service_stop
    logger.info "Service stopped"
  end

  def service_pause
    logger.info "Service paused"
  end

  def service_resume
    logger.info "Service resumed"
  end

  def service_init
    logger.info "Service initializing"
    # some initialization code for your process
  end

  ## worker function
  def service_main
    begin
      while state == RUNNING || state == PAUSED
        while state == RUNNING

        # --- start processing code
        messages = Message.find :all,
        :conditions => ['sent = (?)', 0], # check if the message has been sent
        :limit => 20 # retrieve and process 20 at a time

# array of threads
threads = []

# iterate through each message
for message in messages do
# start a new thread to process the message
threads <  e
# do some rescuing
puts "Failed: #{e.message}"
end
end
end

    # --- end processing code

    end
      if state == PAUSED
      # if you want do something when the process is paused
      end
    end
      rescue StandardError, Interrupt => e
        logger.error "Service error : #{e}"
      end
    end
  end

  d = Daemon.new
  d.mainloop

end #if