require 'net/http'

def send_request(request)
  hostname = 'localhost'
  port = 2000

  connection = TCPSocket.open(hostname, port)
  connection.print(request)
  response = connection.read
  header, body = response.split("\r\n\r\n", 2)
  print body
end #send_request

def get_file
  "GET index.html HTTP/1.0\n" +
  "From: genericuser@gmail.com\n" +
  "User-Agent: HTTPTool/1.0\n" +
  "\r\n\r\n"

end #get_file

loop do
  puts "What would you like to do?"
  puts "1) Open index.html"
  puts "2) Exit"
  choice = gets.chomp
  case choice
  when "1"
    send_request(get_file)
  when "2"
    exit
  end
end #loop
