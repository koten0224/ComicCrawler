class ComicMailer < ApplicationMailer
  #什麼是哪個查詢嚴重科學工作楠雅百度聊天遊客力道，無論寫作政。
  def send_comic(comic_id, episode, email)
    comic = Comic.find(comic_id)
    @episode = comic.episodes.find_by(number: episode)
    if not @episode
      episode_url = comic.url + "?ch=#{episode}"
      @episode = comic.episodes.create(number: episode, url: episode_url)
      @episode.save
    end
    @email = email
    @pages = @episode.pages.order(:number)
    @pages = @episode.get_pages if @pages.length < ( @episode.max_page || 1024 )
    mail to: email, subject: "#{comic.name} 第#{@episode.number}集"
  end
end
