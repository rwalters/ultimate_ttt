Janus::Client.configure do |options|
  options[:url] = "http://#{ ENV.fetch('API_HOST'){ 'server' } }:#{ ENV.fetch('API_PORT'){ '3002' } }/api"
end
