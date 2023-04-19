class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :name
      t.text :description
      t.string :genre
      t.date :release_year
      t.integer :available_copies
      t.decimal :daily_rental_price

      t.timestamps
    end
  end
end
