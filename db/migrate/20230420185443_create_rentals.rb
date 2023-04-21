class CreateRentals < ActiveRecord::Migration[7.0]
  def change
    create_table :rentals do |t|
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true
      t.integer :rental_days

      t.timestamps
    end

    add_foreign_key :rentals, :movies
    add_foreign_key :rentals, :users
  end
end
