class ComicMailer < ApplicationMailer
  def send_comic(comic, episode, email)
    @episode = episode
    @email = email
    @pages = comic.pages.where(episode: episode).order(:number).to_a
    @pages = comic.get_pages(episode) if @pages.length == 0
    mail to: email, subject: "#{comic.name} 第#{episode}集"
  end
end
