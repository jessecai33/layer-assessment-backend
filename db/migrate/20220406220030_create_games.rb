class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.integer :gid
      t.string :genres
      t.string :name
      t.string :platforms
      t.string :release_dates
      t.text :summary
      t.string :cover_url

      t.timestamps
    end
  end
end
