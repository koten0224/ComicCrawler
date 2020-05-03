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
      @page = Nokogiri::HTML.parse(@driver.page_source)
    when :open_uri
      @driver = open(url)
      @page = Nokogiri::HTML(@driver)
    end
    return nil
  end

  def css(pattern)
    @page.css(pattern)
  end

  def search_result_max_page
    @page.css("#search_pager")
          .first
          .css("a")
          .map{ |elem| elem.attr("href").split("=").last.to_i }
          .max || 1
  end

  def search_result
    @page.css("table")[12]
          .css("tr")
          .map do |elem| 
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
         .match(/\d+/)
         .to_a
         .last
         .to_i
  end

  def max_page
    @page.css("#pageindex")
          .first
          .children
          .last
          .attr('value')
          .to_i
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