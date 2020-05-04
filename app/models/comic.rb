class Comic < ApplicationRecord
  has_many :pages

  def get_pages(episode)
    result = []
    episode_url = url + "?ch=#{episode}-1"
    driver = Crawler.chrome
    driver.get(episode_url)
    max_page = driver.max_page

    (1..max_page).each do |page_num|
      puts page_num
      result << pages.create(episode: episode, 
                             url: driver.img_url, 
                             number: page_num
                             )

      if page_num < max_page
        next_page = url + "?ch=#{episode}-#{page_num + 1}"
        driver.get(next_page)
      end

    end

    driver.close

    return result

  end

  
  def self.search(comic_name, page)

    driver = Crawler.open_uri
    driver.get(search_link(comic_name, page))
    
    return driver.search_result
  end

  def self.get_comic_url(url)
    "#{$comiclive}/online/comic-#{web_id(url)}.html"
  end

  private
  def self.search_link(comic_name, page_num)
    pattern = (comic_name.length > 0 ? "k=#{comic_name.big5}&" : "")
    "#{$comicbus}/member/search.aspx?#{pattern}page=#{page_num}"
  end
  def self.web_id(url)
    url.split(/\W/)[-2].to_i
  end

end
