# API to the provided WP service
require 'faraday'
require 'faraday_middleware'

  # load "wp/con_api.rb"
  # Wp::ConApi.get_separations(Wp::Sample1)


  module Wp
	Sample1 =  { :from_name => 'Rick Porter', :from_city => 'Spencer', :from_state => 'IN', :to_name => "Rick Porter", :to_city => "Spencer", :to_state => "IN"}
	Sample2 =  { :from_name => 'Kevin Porter', :from_city => 'Omaha', :from_state => 'NE', :to_name => "K Fadila", :to_city => "Omaha", :to_state => "NE"}
	Sample3 =  { :from_name => 'Matt Porter', :from_city => 'Tulsa', :from_state => 'OK', :to_name => "Stephen Newton", :to_city => "Yukon", :to_state => "OK"}
	Sample4 =  { :from_name => 'Matt Porter', :from_city => 'Tulsa', :from_state => 'OK', :to_name => "Stephen Newton", :to_city => "Yukon", :to_state => "OK", :max_links => 3}
	Sample5 =  { :from_name => 'bbbssssjjf nneidjsshh', :from_city => 'Tulsa', :from_state => 'OK', :to_name => "Stephen Newton", :to_city => "Yukon", :to_state => "OK"}
	Sample6 =  { :from_name => 'Matt Porter', :from_city => 'Tulsa', :from_state => 'OK', :to_name => "Stephen Newton", :to_city => "Yukon", :to_state => "XY"}
	Sample7 =  { :from_name => 'Raymond Johnson', :from_city => 'Glendale', :from_state => 'CA', :to_name => "Sheryl Johnson", :to_city => "Vancouver", :to_state => "Washington"}
	Sample8 =  { :from_name => 'Raymond Johnson', :from_city => 'Glendale', :from_state => 'CA', :to_name => "Cynthia Nyquist", :to_city => "Glendale", :to_state => "California"}
	Sample9 =  { :from_name => 'Raymond Johnson', :from_city => 'Alameda', :from_state => 'CA', :to_name => "Cynthia Nyquist", :to_city => "Alameda", :to_state => "California"}
    
    Sample10 =  { :from_name => 'Rick Porter', :from_city => 'Spencer', :from_state => 'IN', :to_name => "Roma Steckling", :to_city => "Saint Cloud", :to_state => "MN"}
    Sample11 =  { :from_name => 'Ray Johnson', :from_city => 'Los Angeles', :from_state => 'CA', :to_name => "Ron Johnson", :to_city => "Tigard", :to_state => "OR"}



    class WpApiError < StandardError; end

	module ConApi
		API_VERSION = "v1"
		# API_URL = "http://DESKTOP-8O0TNFC.localdomain:3000"  # Need from ENV
		API_URL = ENV.fetch("WP_SERVICE_URL")

		def self.get_separations(parameters)
			service_url = "#{API_VERSION}/separations"
			if ![:from_name, :from_city, :from_state, :to_name, :to_city, :to_state].all? {|s| parameters[s].present?}
				raise WpApiError, "missing or empty parameters to get_separations call"
			end

			conn = Faraday.new(url: API_URL) do |faraday|
				faraday.response :logger  # Log to stdout
				faraday.response :json
				faraday.adapter Faraday.default_adapter
			end

			response = conn.get(service_url, parameters)

			case response.status
				when 500
					raise WpApiError, "try again - backend service failed"
            	when 400
                	raise WpApiError, "Some kind of input error..."
                when 422
                	case response.body["status"]
                		when "no_from_endpoints"
                			raise WpApiError, "Could not find the 1st person"
                		when "no_to_endpoints"
                			raise WpApiError, "Could not find the 2nd person"
                		when "no_endpoints"
                			raise WpApiError, "Could not find the 1st or 2nd person"
                		when "input_errors"
                			msg = ""
                      		if ! response.body["from_errors"].empty?
                      			msg = "For the first person: "
                				msg += response.body["from_errors"].join(", ") + ".  "
                			end
                      		if ! response.body["to_errors"].empty?
                      			msg = "For the second person: "
                				msg += response.body["to_errors"].join(", ") + ".  "
                			end

                			if msg == ""
                				msg = "Sorry.  We got some kind of inoput error"
                			end

                			raise WpApiError, msg
                	end
                	puts "other error: #{response.body}"
            end

            puts "Body: #{response.body.to_s}"
			response.body

			# TODO: parse for errors and handle them
		end
	end
end

