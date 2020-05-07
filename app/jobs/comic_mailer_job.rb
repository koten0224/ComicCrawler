class ComicMailerJob < ApplicationJob
  queue_as :delayed_job

  def perform(comic_id, episode, email)
    # Do something later
    ComicMailer.send_comic(comic_id, episode, email).deliver
  end
end
