require 'open-uri'

class EightComic < Crawler

  def search_result(comic_name, page_num)

    pattern = (comic_name.length > 0 ? "k=#{comic_name.big5}&" : "")
    url = "#{$comicbus}/member/search.aspx?#{pattern}page=#{page_num}"

    @driver = open(url)
    res = ''
    finish = false
    while not finish
      begin
        @driver.each { |x| res += x.utf_8 }
        finish = true
      rescue
      end
    end
    @page = Nokogiri::HTML(res)

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
    @page.css("#lastchapter")
         .text
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
      @page = Nokogiri::HTML(@driver.page_source)
      return img_url
    end
  end

end