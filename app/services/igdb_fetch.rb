require 'dotenv'
require 'rest-client'
require 'date'
Dotenv.load

class IgdbFetch
  attr_reader :auth_token, :auth_headers

  def initialize
    response = RestClient.post ENV['TWITCH_AUTH_URL'], { client_id: ENV['IGDB_CLIENT_ID'], client_secret: ENV['IGDB_CLIENT_SECRET'], grant_type: 'client_credentials' }
    if response.code == 200
      @auth_token = JSON.parse(response.body)['access_token']
      @auth_headers = { 'Client-ID' => ENV['IGDB_CLIENT_ID'], 'Authorization' => "Bearer #{@auth_token}" }
    else
      raise 'Failed to get token'
    end
  end

  def search(query)
    search_results = []
    response = RestClient::Request.execute(method: :post, url: URI.join(ENV['IGDB_BASE_URL'], 'games').to_s, payload: "search \"#{query}\"; fields name, cover, platforms, release_dates, summary, genres; limit 5;", headers: @auth_headers)
    if response.code == 200
      results = JSON.parse(response.body)
      return nil if results.empty?
      results.each do |result|
        next if Game.where(gid: result['id']).exists?
        gid = result['id']
        name = result['name']
        summary = result['summary'].nil? ? '' : result['summary']
        genres = result['genres'].nil? ? '' : result['genres'].map { |genre_id| get_genre(genre_id) }.join(', ')
        platforms = result['platforms'].nil? ? '' : result['platforms'].map { |platform_id| get_platform(platform_id) }.join(', ')
        release_dates = result['release_dates'].nil? ? '' : result['release_dates'].map { |release_date_id| get_release_date(release_date_id) }.join(', ')
        cover_url = result['cover'].nil? ? '' : get_cover(result['cover'])
        puts "#{gid} - #{name} - #{genres} - #{platforms} - #{release_dates} - #{cover_url}"
        search_results << Game.create(gid: gid, name: name, summary: summary, genres: genres, platforms: platforms, release_dates: release_dates, cover_url: cover_url)
      end
      search_results
    else
      raise 'Failed to search'
    end
  end

  def get_cover(id)
    response = RestClient::Request.execute(method: :post, url: URI.join(ENV['IGDB_BASE_URL'], 'covers').to_s, payload: "fields image_id; where id = #{id};", headers: @auth_headers)
    if response.code == 200
      "https://images.igdb.com/igdb/image/upload/t_cover_big/#{JSON.parse(response.body)[0]['image_id']}.jpg"
    else
      ''
    end
  end


  def get_genre(id)
    response = RestClient::Request.execute(method: :post, url: URI.join(ENV['IGDB_BASE_URL'], 'genres').to_s, payload: "fields name; where id = #{id};", headers: @auth_headers)
    if response.code == 200
      JSON.parse(response.body)[0]['name']
    else
      ''
    end
  end

  def get_platform(id)
    response = RestClient::Request.execute(method: :post, url: URI.join(ENV['IGDB_BASE_URL'], 'platforms').to_s, payload: "fields abbreviation; where id = #{id};", headers: @auth_headers)
    if response.code == 200
      JSON.parse(response.body)[0]['abbreviation']
    else
      ''
    end
  end

  def get_release_date(id)
    response = RestClient::Request.execute(method: :post, url: URI.join(ENV['IGDB_BASE_URL'], 'release_dates').to_s, payload: "fields date; where id = #{id};", headers: @auth_headers)
    if response.code == 200 && JSON.parse(response.body)[0]['date'].present?
      Time.at(JSON.parse(response.body)[0]['date']).strftime('%Y-%m-%d')
    else
      ''
    end
  end
end
