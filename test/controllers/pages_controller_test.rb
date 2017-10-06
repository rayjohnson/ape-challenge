require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
	test "should get root" do
	  get '/'
	  assert_response :success
	end

  test "should get home" do
    get pages_home_url
    assert_response :success
  end

  test "should post find_connection - params not empty" do
  	# params can not be emptry
    params = {
      from_name: '', from_city: '', from_state: '',
      to_name: '', to_city: '', to_state: ''
    }

    post pages_find_connection_url, params: params
    assert_response :success, @response.body
    result = JSON.parse(@response.body)
    assert(result['status'], "fail")
    assert(result['message'])
  end

  test "should post find_connection - even one not empty" do
  	# params can not be emptry
    params = {
      from_name: 'Bob Hope', from_city: '', from_state: '',
      to_name: '', to_city: '', to_state: ''
    }

    post pages_find_connection_url, params: params
    assert_response :success, @response.body
    result = JSON.parse(@response.body)
    assert(result['status'], "fail")
    assert(result['message'])
  end

# find_connection
end
