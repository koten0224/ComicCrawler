class ComicsController < ApplicationController
  def index
    @comics = Comic.all
    driver = Crawler.open_uri
    @comics.each do |comic|
      if Time.now - comic.updated_at > 40000
        driver.get(comic.url)
        comic.latest_episode = driver.get_latest_episode
        comic.save
      end
    end
  end

  def search_form
    @comic = Comic.new
  end

  def search
    result = Comic.search(params[:comic_name])
    render json: result
  end

  def create
    url = Comic.get_comic_url(params[:comic_link])
    name = params[:comic_name]
    driver = Crawler.open_uri
    driver.get(url)
    episode = driver.get_latest_episode
    comic = Comic.new(name: name, url: url, readed: episode, latest_episode: episode)
    if comic.save
      render json: { status: 200 }
    else
      render json: { status: 404 }
    end
  end

  def show
    @comic = Comic.find(params[:id])
  end

  def send_comic
    email = params[:email]
    comic = Comic.find(params[:id])
    start = (params[:start] || (comic.readed + 1)).to_i
    stop = (params[:stop] || comic.latest_episode).to_i
    if stop < start
      start -= 1
    end
    (start..stop).each do |episode|
      ComicMailer.send_comic(comic, episode, email).deliver_later
    end
    if stop > comic.readed
      comic.readed = stop
      comic.save
    end
    render json: {}
  end


end
