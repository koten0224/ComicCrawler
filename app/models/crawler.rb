require 'open-uri'

class Crawler
  attr_accessor :driver, :mode
  private_class_method :new

  def initialize(mode = nil, driver = nil)
    @mode = mode
    @driver = driver
    @page = nil
  end

  def get(url)
    case @mode
    when :chrome
      @driver.get(url)
      
      @page = Nokogiri::HTML(@driver.page_source.utf_8)
    when :open_uri
      @driver = open(url)
      def recursive_encode()
        res = ''
        begin
          @driver.each { |x| res += x.utf_8 }
        rescue
          res += recursive_encode
        end
        return res
      end
      @page = Nokogiri::HTML(recursive_encode)
    end
    return nil
  end

  def css(pattern)
    @page.css(pattern)
  end

  def search_result
    res = @page.css("table")[12].css("tr")
    res.map do |elem| 
      a = elem.css("td")[1]
              .css("a")
              .first
      link = $comicbus + a.attr("href") 
      title = a.css("b font")
                .first
                .text
      {title: title, link: link}
    end
  end

  def get_latest_episode
    @page.css("#lastvol")
         .first
         .text
         .scan(/\d+/)
         .last
         .to_i
  end

  def max_page
    res = @page.css("#pageindex")
          .first
          .children
          .last
    return res.attr('value').to_i if res
    return 1
  end

  def img_url
    begin
      return "https:" + @page.css("#TheImg")
                              .first
                              .attr("src")
    rescue
      sleep 5
      return img_url
    end
  end

  def close
    @driver.close
  end

  #instead self.new function with 2 mode
  def self.chrome
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    new :chrome, (Selenium::WebDriver.for(:chrome, options: options))
  end

  def self.open_uri
    new :open_uri
  end

end