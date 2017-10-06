require 'wp/con_api.rb'

class PagesController < ApplicationController

	# Our basic web site page
	def home
	end

  # POST for our returned results
  def find_connection
  	result_hash = {}

  	# Some basic validation
	if ![:from_name, :from_city, :from_state, :to_name, :to_city, :to_state].all? {|s| params[s].present?}
    	result_hash[:status] = "fail"
  		result_hash[:message] = "No Seriously.  You have to enter all the fields."
  		render json: result_hash
  		return
	end

	# Call backend service and Mapping of results to something readable
	# This should really happen somewhere else (like in a Model)
  	begin
  		result = Wp::ConApi.get_separations(params)

  		result_hash[:status] = "success"
  		if result.nil?
  			result_hash[:message] = "Sorry no connection between these two people could be found."
  		else
  			logger.debug result.to_s
  			result_hash[:message] = "We found a connection: #{result.to_s}"
  		end
  	rescue Wp::WpApiError => err
   		result_hash[:status] = "fail"
  		result_hash[:message] = "Something is wrong with your inout: #{err}"
  	rescue StdardError => err
    	result_hash[:status] = "fail"
  		result_hash[:message] = "Something went wrong: #{err}"
  	end

  	render json: result_hash
  end
end
