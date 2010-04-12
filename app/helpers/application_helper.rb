require 'httparty'

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def get_sda
	# TODO error handling
  	return HTTParty.get('http://192.168.1.202/data/CAPE01-RTD.xml')["DAS"]
  end

end
