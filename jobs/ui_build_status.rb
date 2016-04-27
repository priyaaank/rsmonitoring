SCHEDULER.every '5s' do
  require 'open-uri'
  require 'json'
  image_hash = {"SUCCESS" => "/success.png", "FAILURE" => "/failure.png", "PROGRESS" => "/hourglass.png"}
  jenkins_url = ENV['JENKINS_HOST_PORT']

  basic_auth = [ENV['JENKINS_USERNAME'], ENV['JENKINS_TOKEN']]
  ui_build_status_response = open("http://#{jenkins_url}/job/amazon-api/lastBuild/api/json", http_basic_authentication: basic_auth).read()
  functional_test_status_response = open("http://#{jenkins_url}/job/Functional-test-amazon-api/lastBuild/api/json", http_basic_authentication: basic_auth).read()
  json_ui_build_response = JSON.parse(ui_build_status_response)
  json_functional_build_response = JSON.parse(functional_test_status_response)
  ui_latest_status_state=json_ui_build_response['result']||"PROGRESS"
  functional_latest_status_state=json_functional_build_response['result']||"PROGRESS"
  ui_image_name = image_hash[ui_latest_status_state]
  funtional_image_name = image_hash[functional_latest_status_state]
  send_event('uibuild', { image: ui_image_name, moreinfo: "code coverage not available",status: "#{ui_latest_status_state.downcase}"})
  send_event('functionaltestbuild', { image: funtional_image_name, moreinfo: "",status: "#{functional_latest_status_state.downcase}"})
end
