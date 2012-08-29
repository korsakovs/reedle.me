require 'httpclient'

$config = {
    :url_prefix => "http://localhost:4567/",

    :threads_num => 100,

    :requests_num => 5000,

    :delay_between_threads_start => 0.1,

    :uri => "cities/by-prefix.json?name=New&latitude=54.97&longitude=73.39"
    # :uri => "cities/by-prefix.json?latitude=54.97&longitude=73.39"
    # :uri => "cities/by-prefix.json?name=new",
    # :uri => "topnews?location=114015&level=country"


}

threads = []
$req_num = 0
$err_num = 0
$exc_num = 0
$timer = 0
$started_at = Time.new

$config[:threads_num].times { |i|

  threads[i] = Thread.new {
    sleep $config[:delay_between_threads_start] * i

    puts "New thread started"

    http_client = HTTPClient.new
    http_client.connect_timeout = 3
    http_client.send_timeout = 3
    http_client.receive_timeout = 10
    http_client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE

    $config[:requests_num].times { |_|
      st = Time.new
      exc = false

      begin
        response = http_client.get($config[:url_prefix] + $config[:uri])
      rescue Exception => e
        exc = true
        # puts e.inspect
        $exc_num += 1
      end

      gather_st = (Time.new - $started_at).to_i > ( $config[:threads_num] * $config[:delay_between_threads_start] ).to_i

      $req_num += 1 if gather_st

      begin

        unless exc
          $timer += (Time.new - st).to_f if gather_st

          # puts response.content.inspect

          # puts response.http_header.status_code.inspect
          if !response.nil? && response.http_header.status_code != 200
            # puts "Error: #{response.inspect}"
            $err_num += 1 if gather_st
          end
        end

      rescue Exception => e
        puts e.inspect
      end

      # puts response.inspect
      # puts response.content.to_s
    }
  }
}

while true
  one_running = false
  threads.each { |t|
    # puts t.status.inspect
    if !t.status.nil? and !(t.status == false)
      one_running = true
    end
  }

  puts "Requests: #{$req_num}"
  puts "Good: #{$req_num - $err_num - $exc_num}, #{100 * ($req_num - $err_num - $exc_num) / $req_num}" if $req_num > 0
  puts "Errors: #{$err_num}, #{100 * $err_num/$req_num}" if $req_num > 0
  puts "Exceptions: #{$exc_num}, #{100 * $exc_num/$req_num}" if $req_num > 0
  puts "Avg response time: #{$timer/$req_num}" if $req_num > 0
  puts "Requests per sec:#{($req_num/(Time.new - $started_at).to_f)}"
  puts "---"

  sleep 1
  exit unless one_running
end

