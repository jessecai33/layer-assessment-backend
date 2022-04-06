class Game < ApplicationRecord
  validates :name, presence: true
  validates :gid, presence: true, uniqueness: true
end
