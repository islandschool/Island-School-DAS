require 'httparty'

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def get_sda
	# TODO error handling
  	return HTTParty.get('http://192.168.1.202/data/CAPE01-RTD.xml')["DAS"]
  end
  
  def get_cache(key, serialize = false)
    value = Rails.cache.read(key)

    if serialize && value
      value = YAML::load(value)
    end

    # TODO: ensure that value is from "today" not "yesterday"
    
    return value
  end
  
  def set_cache(key, value, expiry, serialize = false)
    
    if serialize
      value = value.to_yaml
    end
    
    Rails.cache.write(key, value, :expires_in => expiry.hours) 
  end

end
