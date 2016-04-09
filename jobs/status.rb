SCHEDULER.every '5s' do
  require 'open-uri'
  require 'json'
  server_url = ENV['SERVER_HOST_PORT']
  response = open("http://#{server_url}/stats/now").read()
  json_response = JSON.parse(response)
  cpu_percent = json_response["cpu"]["used_percent"]
  cpu_text = json_response["cpu"]["text"]
  disk_percent = json_response["disk_space"]["used_percent"]
  disk_text = json_response["disk_space"]["text"]
  memory_percent = json_response["memory"]["percent_used"]
  memory_text = json_response["memory"]["text"]
  node_running = json_response["node"]
  worker_running = json_response["worker"]
  coreapi_running = json_response["api"]
  send_event('disk', { value: disk_percent, moreinfo: disk_text})
  send_event('memory', { value: memory_percent, moreinfo: memory_text})
  send_event('cpu', { value: cpu_percent, moreinfo: cpu_text})
  send_event('nodejs', { image: "#{node_running ? '/lighton.png' : '/lightoff.png'}", moreinfo: "UI is #{node_running ? 'running': 'down'}"}) 
  send_event('worker', { image: "#{worker_running ? '/lighton.png' : '/lightoff.png'}", moreinfo: "Worker is #{worker_running ? 'running': 'down'}"}) 
  send_event('coreapi', { image: "#{coreapi_running ? '/lighton.png' : '/lightoff.png'}", moreinfo: "API is #{coreapi_running ? 'running': 'down'}"}) 
end
