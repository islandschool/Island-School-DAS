# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  config.time_zone = 'UTC'

  # limit log to 3 x 5 MB files, log to STDOUT for console
  #config.logger = Logger.new(Rails.root.join("log", Rails.env + ".log"),3,5*1024*1024)  
  
end