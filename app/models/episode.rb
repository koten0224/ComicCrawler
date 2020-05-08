class Episode < ApplicationRecord
  has_many :pages, dependent: :destroy
  belongs_to :comic

  alias_method :native_pages, :pages

  def pages
    result = native_pages.order(:number)
    len = result.length
    if len < ( max_page || 1024 )
      driver = EightComic.chrome
      start = [1, len + 1].max
      (start..1024).each do |page_num|
        break if page_num > ( max_page || 1024 )
        driver.get( url + "-#{page_num}" )
        if not max_page
          update_attribute( :max_page, driver.max_page )
        end
        page = Page.new(episode_id: id,
                        url: driver.img_url, 
                        number: page_num
        )
        page.save
        result << page
      end # loop
      driver.close
    end # if scope
    return result
  end

  def page_list
    return native_pages.map{|pg| pg.number }.sort
  end
end
