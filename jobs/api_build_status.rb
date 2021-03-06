SCHEDULER.every '5s' do
  require 'open-uri'
  require 'json'
  image_hash = {"SUCCESS" => "/success.png", "FAILURE" => "/failure.png", "PROGRESS" => "/hourglass.png"}
  jenkins_url = ENV['JENKINS_HOST_PORT']

  basic_auth = [ENV['JENKINS_USERNAME'], ENV['JENKINS_TOKEN']]
  api_build_status_response = open("http://#{jenkins_url}/job/core-api/lastBuild/api/json", http_basic_authentication: basic_auth).read()
  json_api_build_response = JSON.parse(api_build_status_response)
  #api_latest_build_number=json_api_build_response['displayName']
  api_latest_status_state=json_api_build_response['result']||"PROGRESS"
  image_name = image_hash[api_latest_status_state]
  api_coverage_value = "NA"
  if(api_latest_status_state == "SUCCESS")
    api_coverage_response = open("http://#{jenkins_url}/job/core-api/lastBuild/cobertura/api/json?depth=2", http_basic_authentication: basic_auth).read()
    json_api_coverage_response=JSON.parse(api_coverage_response)
    api_coverage_value = json_api_coverage_response['results']['elements'].select { |e| e['name'] == 'Lines'}[0]['ratio']
  end
  send_event('apibuild', { image: image_name, moreinfo: "#{api_coverage_value}% code coverage",status: "#{api_latest_status_state.downcase}"})
end
