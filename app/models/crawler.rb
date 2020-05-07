require 'open-uri'

class Crawler
  attr_accessor :driver, :mode
  private_class_method :new

  def initialize(mode = nil, driver = nil)
    @mode = mode
    @driver = driver
    @page = nil
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

  def get(url)
    case @mode
    when :chrome
      @driver.get(url)
      @page = Nokogiri::HTML(@driver.page_source)
    when :open_uri
      @driver = open(url)
      @page = Nokogiri::HTML(@driver.read)
    end
    return nil
  end

  def css(pattern)
    @page.css(pattern)
  end

  def close
    @driver.close
  end

  

end