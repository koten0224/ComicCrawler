class Episode < ApplicationRecord
  has_many :pages
  belongs_to :comic

  def get_pages
    
    driver = EightComic.chrome
    driver.get(url)
    update_attribute( :max_pages, driver.max_page )

    result = (1..max_pages).map do |page_num|
      pages.create(url: driver.img_url, 
                   number: page_num
      )
      if page_num < max_pages
        next_page = url + "-#{page_num + 1}"
        driver.get(next_page)
      end
    end

    driver.close
    return result

  end

end
