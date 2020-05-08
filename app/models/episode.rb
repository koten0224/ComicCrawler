class Episode < ApplicationRecord
  has_many :pages, dependent: :destroy
  belongs_to :comic

  def get_pages
    
    driver = EightComic.chrome
    driver.get(url)
    update_attribute( :max_page, driver.max_page )

    result = (1..max_page).map do |page_num|
      page = pages.create(url: driver.img_url, 
                          number: page_num
      )
      if page_num < max_page
        next_page = url + "-#{page_num + 1}"
        driver.get(next_page)
      end
      page
    end

    driver.close
    return result

  end

end
