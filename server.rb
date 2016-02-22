require 'socket'

server = TCPServer.open(2000)

def respond_200(request, file)
  request.print "HTTP/1.0 200 OK\r\n"
  request.print "Date: #{Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S")} GMT\r\n"
  request.print "File-Size: \r\n"
  request.print "\r\n"
  request.print File.read(file)
end #respond_200

def respond_404
  request.print "HTTP/1.0 404 Not Found\r\n"
  request.print "\r\n"
  request.print "The requested file was not found.\r\n"
end #respond_404

loop do
  request = server.accept
  header = ""
  while line = request.gets
    header += line
    break if header =~ /\r\n\r\n$/
  end
  request_type = header.split[0]
  request_file = header.split[1]

  case request_type
    when "GET"
      if File.exist?(request_file)
        respond_200(request, request_file)
      else
        respond_404
      end
    when "POST"
      request.print "This is a POST response.. or, it will be.\r\n"
    else
      request.print "Request not valid. Please try again.\r\n"
  end

  request.close
end #loop
