# Requires the Gemfile
require 'bundler' ; Bundler.require

def hostalive(host)
	checkthis = Net::Ping::External.new(host)
	checkthis.ping?
end

def hostcontent(host,port)
	port = 80 if port.nil?
	result = String.new
	begin	
		getresult = HTTParty.get("http://#{host}:#{port}/")
		result << "HTTP response colde: " << getresult.code.to_s << "\n"
		result << "message: " << getresult.message.to_s << "\n"
		result << "content generator: " << getresult.headers['x-generator'] << "\n" unless getresult.headers['x-generator'].nil?
	rescue Errno::ECONNREFUSED
		result = "TCP connection to #{host}:#{port} failed"
	rescue SocketError
		result = "TCP connection to #{host} failed"
	end
	result
end

# By default Sinatra will return the string as the response.
get '/checkhost' do
	host = params[:host]
	port = params[:port]
	result = String.new
	if hostalive(host)
		result = hostcontent(host,port)
	else
		result = "#{host} is down"
	end
	result
end

get '/hello' do
	"Simon says hello"
end
