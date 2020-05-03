class ComicMailer < ApplicationMailer
  def send_comic(comic, episode, email)
    @episode = episode
    @email = email
    mail to: email, subject: "#{comic.name} 第#{episode}集"

  end
end
