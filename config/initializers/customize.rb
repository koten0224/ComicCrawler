require 'open-uri'
require 'cgi'
class String
  
  def big5
    CGI::escape(encode('big5'))
  end

  def utf_8
    encode('utf-8')
  end
end

$comicbus = "https://comicbus.com"
$comiclive = "https://comicbus.live"
