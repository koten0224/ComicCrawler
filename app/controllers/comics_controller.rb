class ComicsController < ApplicationController
  def index
    @comics = Comic.all
    @comics.each do |comic|
      if Time.now - comic.updated_at > 40000
        comic.get_latest_episode
        comic.updated_at = Time.now
        comic.save
      end
    end
  end

  def search_form
  end

  def search
    result = Comic.search(params[:comic_name], params[:page])
    render json: result
  end

  def create
    comic = Comic.new(comic_params)
    episode = comic.get_latest_episode
    comic.readed = episode
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
      ComicMailer.send_comic(comic.id, episode, email).deliver_later
    end
    if stop > comic.readed
      comic.readed = stop
      comic.save
    end
    render json: {}
  end

  private
  def comic_params
    url = Comic.get_comic_url(params[:comic_link])
    name = params[:comic_name]
    return {name: name, url: url}
  end


end
