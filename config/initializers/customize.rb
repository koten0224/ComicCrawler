require 'open-uri'
require 'cgi'
class String
  
  def big5
    CGI::escape(self.encode('big5'))
  end
end

$comicbus = "https://comicbus.com"
$comiclive = "https://comicbus.live"
