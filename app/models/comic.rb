class Comic < ApplicationRecord
  has_many :pages
  
  def self.search(comic_name)

    driver = Crawler.open_uri
    page_num = 1
    driver.get(search_link(comic_name, page_num))
    max_page = driver.search_result_max_page
    result = []

    while page_num <= max_page
      result += driver.search_result
      page_num += 1
      driver.get(search_link(comic_name, page_num))
    end

    return result
  end

  private
  def self.search_link(comic_name, page_num)
    "#{$comicbus}/member/search.aspx?k=#{comic_name.big5}&page=#{page_num}"
  end
  def self.web_id(url)
    url.split(/\W/)[-2].to_i
  end
  def self.get_comic_url(comic_web_id)
    "#{$comiclive}/online/comic-#{comic_web_id}.html"
  end

end
