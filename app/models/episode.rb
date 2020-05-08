class Episode < ApplicationRecord
  has_many :pages, dependent: :destroy
  belongs_to :comic

  alias_method :native_pages, :pages

  def pages
    result = native_pages.order(:number)
    if result.length < ( max_page || 1024 )
      driver = EightComic.chrome
      driver.get(url)
      update_attribute( :max_page, driver.max_page )
      result = (1..max_page).map do |page_num|
        page = Page.new(episode_id: id,
                        url: driver.img_url, 
                        number: page_num
        )
        page.save
        if page_num < max_page
          next_page = url + "-#{page_num + 1}"
          driver.get(next_page)
        end # sub if scope
        page
      end # loop
      driver.close
    end # if scope
    return result
  end

  def page_list
    return native_pages.map{|pg| pg.number }.sort
  end
end
