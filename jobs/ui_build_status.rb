SCHEDULER.every '5s' do
  require 'open-uri'
  require 'json'
  jenkins_url = ENV['JENKINS_HOST_PORT']

  basic_auth = [ENV['JENKINS_USERNAME'], ENV['JENKINS_TOKEN']]
  ui_build_status_response = open("http://#{jenkins_url}/job/amazon-api/lastBuild/api/json", http_basic_authentication: basic_auth).read()
  functional_test_status_response = open("http://#{jenkins_url}/job/Functional-test-amazon-api/lastBuild/api/json", http_basic_authentication: basic_auth).read()
  json_ui_build_response = JSON.parse(ui_build_status_response)
  json_functional_build_response = JSON.parse(functional_test_status_response)
  ui_latest_status_success=json_ui_build_response['result']=="SUCCESS"
  functional_latest_status_success=json_functional_build_response['result']=="SUCCESS"
  send_event('uibuild', { image: "#{ui_latest_status_success ? '/success.png' : '/failure.png'}", moreinfo: "code coverage not available",status: "#{ui_latest_status_success ? 'success' : 'failure'}"})
  send_event('functionaltestbuild', { image: "#{functional_latest_status_success ? '/success.png' : '/failure.png'}", moreinfo: "",status: "#{functional_latest_status_success ? 'success' : 'failure'}"})
end
