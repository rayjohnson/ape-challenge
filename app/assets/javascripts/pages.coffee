# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

resultHandler = (data) ->
	console.log(data)
	# We do the same on success or failure - kind of boring I know...
	$('#connection_result').text( data['message'] )

	$('#messageModal').modal('show');
	return

checkConnectionHandler = (event) ->
	event.preventDefault()

	post_data = 
		from_name: $("#from-name").val()
		from_city: $("#from-city").val()
		from_state: $("#from-state").val()
		to_name: $("#to-name").val()
		to_city: $("#to-city").val()
		to_state: $("#to-state").val()

	$.post("/pages/find_connection", post_data).done(resultHandler)

	return


$(document).on "click", "#check-con-but", checkConnectionHandler
