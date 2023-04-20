class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :name, null: false
      t.text :description
      t.string :genre
      t.integer :release_year
      t.integer :available_copies, null: false, default: 0
      t.decimal :daily_rental_price, null: false, default: 0

      t.timestamps
    end
  end
end
