# API to the provided WP service
require 'faraday'
require 'faraday_middleware'

module Wp
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

