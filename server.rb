require "socket"
require "json"

server = TCPServer.open(2000)

def respond_200(request,file,type)
  request.print "HTTP/1.0 200 OK\r\n"
  request.print "Date: #{Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S")} GMT\r\n"
  request.print "Content-Length: #{file.length}\r\n"
  request.print "\r\n"
  if type == "GET"
    request.print File.read(file)
  elsif type == "POST"
    request.print file
  end
end #respond_200

def respond_404
  request.print "HTTP/1.0 404 Not Found\r\n"
  request.print "\r\n"
  request.print "The requested file was not found.\r\n"
end #respond_404

def modify_html(params)
  return_page = File.read("thanks.html")
  insert = ""
  params.values.each do |value|
    value.each do |key, val|
      insert += "<li>#{key.capitalize}: #{val}</li>"
    end
  end
  modified = return_page.gsub("<%= yield %>", insert)
end #modify_html

puts "Server initialized..."
loop do
  request = server.accept
  header = ""
  while line = request.gets
    header += line
    break if header =~ /\r\n\r\n$/
  end
  request_type = header.split[0]
  request_file = header.split[1]
  body_length = header.scan(/Content-Length:\s(\d+)/)[0][0].to_i

  case request_type
    when "GET"
      if File.exist?(request_file)
        respond_200(request, request_file,"GET")
      else
        respond_404
      end
    when "POST"
      if File.exist?(request_file)
        request_body = request.read(body_length)
        params = JSON.parse(request_body)
        file = modify_html(params)
        respond_200(request, file,"POST")
      else
        respond_404
      end
    else
      request.print "Request not valid. Please try again.\r\n"
  end

  request.close
end #loop
