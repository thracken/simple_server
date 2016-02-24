require "net/http"
require "json"

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
  file = File.read("index.html")
  return "GET index.html HTTP/1.0\n" + "From: genericuser@gmail.com\n" + "User-Agent: HTTPTool/1.0\n" + "Content-Length: #{file.length}\n" + "\r\n\r\n"
end #get_file

def post_form_viking
  puts "What is your Viking's name?"
  name = gets.chomp
  puts "What is your Viking's email?"
  email = gets.chomp
  viking = {:viking => {:name => name, :email => email} }
  return "POST thanks.html HTTP/1.0\n" + "From: genericuser@gmail.com\n" + "User-Agent: HTTPTool/1.0\n" + "Content-Length: #{viking.to_json.length}\n" + "\r\n\r\n" + viking.to_json
end #post_form

loop do
  puts "What would you like to do?"
  puts "1) Open index.html"
  puts "2) Submit a new viking form"
  puts "3) Exit"
  choice = gets.chomp
  case choice
  when "1"
    send_request(get_file)
  when "2"
    send_request(post_form_viking)
  when "3"
    exit
  end
end #loop
