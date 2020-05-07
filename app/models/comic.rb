class Comic < ApplicationRecord
  has_many :episodes

  def get_latest_episode
    driver = EightComic.open_uri
    driver.get(url)
    episode = driver.get_latest_episode
    write_attribute( :latest_episode, episode )
    return episode
  end

  def self.search(comic_name, page)
    driver = EightComic.open_uri
    driver.search_result(comic_name, page)
  end

  def self.get_comic_url(url)
    "#{$comiclive}/online/comic-#{web_id(url)}.html"
  end

  private
  def self.web_id(url)
    url.split(/\W/)[-2].to_i
  end

end
