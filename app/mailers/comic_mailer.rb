class ComicMailer < ApplicationMailer
  #什麼是哪個查詢嚴重科學工作楠雅百度聊天遊客力道，無論寫作政。
  def send_comic(comic_id, episode, email)
    comic = Comic.find(comic_id)
    @pages = comic.episode(episode).pages
    mail to: email, subject: "#{comic.name} 第#{episode}集"
  end
end
