class Game < ApplicationRecord
  validates :name, presence: true
  validates :gid, presence: true, uniqueness: true

  def self.search(query)
    games = Game.where('lower(name) LIKE ?', "%#{query.downcase}%").limit(10)
    if games.empty?
      games = self.fetch(query)
    end
    games
  end

  def self.fetch(query)
    igdb_fetch = IgdbFetch.new
    igdb_fetch.search(query)
  end
end
