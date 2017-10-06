require File.expand_path(File.join(File.dirname(__FILE__), "../..", "test_helper"))
require 'wp/con_api.rb'

class ConApiTest < ActiveSupport::TestCase
	test "get_separations" do
		params = { :from_name => nil }
		
		exception = assert_raises Wp::WpApiError do 
    		Wp::ConApi.get_separations(params)
  		end
		assert_equal('missing or empty parameters to get_separations call', exception.message)

	    params = {
	      from_name: 'x', from_city: 'x', from_state: 'x',
	      to_name: 'x', to_city: 'x', to_state: 'x'
	    }
	    url = ENV.fetch("WP_SERVICE_URL") + "/v1/separations"
	    headers = {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.13.1'}
		
		# 400
		stub_request(:get, url)
			.with(headers: headers, query: params)
			.to_return(status: 400, body: nil)
		exception = assert_raises Wp::WpApiError do 
    		Wp::ConApi.get_separations(params)
  		end
		assert_equal('Some kind of input error...', exception.message)

		# 500
		stub_request(:get, url)
			.with(headers: headers, query: params)
			.to_return(status: 500, body: nil)
		exception = assert_raises Wp::WpApiError do 
    		Wp::ConApi.get_separations(params)
  		end
		assert_equal('try again - backend service failed', exception.message)

		# 422 - no_from_endpoints
		stub_request(:get, url)
			.with(headers: headers, query: params)
			.to_return(status: 422, body: {"status" => "no_from_endpoints"}.to_json)
		exception = assert_raises Wp::WpApiError do 
    		Wp::ConApi.get_separations(params)
  		end
		assert_equal('Could not find the 1st person', exception.message)

		# 422 - no_to_endpoints
		stub_request(:get, url)
			.with(headers: headers, query: params)
			.to_return(status: 422, body: {"status" => "no_to_endpoints"}.to_json)
		exception = assert_raises Wp::WpApiError do 
    		Wp::ConApi.get_separations(params)
  		end
		assert_equal('Could not find the 2nd person', exception.message)

		# 422 - no_endpoints
		stub_request(:get, url)
			.with(headers: headers, query: params)
			.to_return(status: 422, body: {"status" => "no_endpoints"}.to_json)
		exception = assert_raises Wp::WpApiError do 
    		Wp::ConApi.get_separations(params)
  		end
		assert_equal('Could not find the 1st or 2nd person', exception.message)

		# 422 - input_errors
		stub_request(:get, url)
			.with(headers: headers, query: params)
			.to_return(status: 422, body: {"status" => "input_errors", "from_errors" => ["an error"], "to_errors" => ["an error"]}.to_json)
		exception = assert_raises Wp::WpApiError do 
    		Wp::ConApi.get_separations(params)
  		end
		assert_equal('For the second person: an error.  ', exception.message)


	end
end