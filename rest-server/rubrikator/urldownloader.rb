require 'mechanize'
require 'mongo'
require 'uri'
require 'logger'
require 'readability'

require '../config'

connection = Mongo::Connection.new( $config[:db][:address], $config[:db][:port], :pool_size => $config[:db][:pool_size], :pool_timeout => $config[:db][:timeout] )
$db = connection.db $config[:db][:database]
$web_locations = $db.collection $config[:db][:collections][:web_locations]

$logger = Logger.new $config[:logger][:log_to]


old_host=''


def get_text_from_html(html)
  Readability::Document.new(html, {:tags => %w[]}).content
end

location = $web_locations.find_one(:text => nil)

while !location.nil?
  $logger.debug 'Downloading ' + location['url'] + ' ...'

  my_uri = URI.parse location['url']
  sleep 1 if my_uri.host == old_host
  old_host = my_uri.host

  user_agent = [ 'Linux Firefox', 'Linux Konqueror', 'Linux Mozilla', 'Mac Mozilla', # 'Mac Firefox',
                 'Mac Safari', 'Mac Safari 4', 'Windows IE 8', 'Windows IE 9', 'Windows Mozilla' ].sample

  doc = Mechanize.new
  doc.user_agent_alias = user_agent

  is_error = false

  skip_hosts = [ 'www.youtube.com', 'youtube.com' ]

  if skip_hosts.include? my_uri.host
    $logger.debug 'Skipping ' + location['url']
    is_error = true
  else
    # doc.log = $logger
    begin
      doc.get location['url']
      $logger.debug 'Downloaded ' + doc.page.title
      text = get_text_from_html doc.page.body
    rescue Exception => e
      is_error = true
      $logger.warn() { "Warning: Could not find download url. Error: #{e.inspect}" }
    end
  end

  # $logger.debug doc.inspect
  # $logger.debug doc.page.body

  begin
    $web_locations.update({
                              :_id => location['_id']
                          }, {
                              :"$set" => {
                                  :text => is_error ? false : text
                              }
                          }, {:safe => true})
  rescue BSON::InvalidStringEncoding => e
    $logger.warn() { "Warning: Could not update db record. Error: #{e.inspect}" }
    $web_locations.update({
                              :_id => location['_id']
                          }, {
                              :"$set" => {
                                  :text => false
                              }
                          }, {:safe => true})
  end

  begin
    location = $web_locations.find_one(:text => nil)
  rescue Exception => e
    location = nil
  end
end

