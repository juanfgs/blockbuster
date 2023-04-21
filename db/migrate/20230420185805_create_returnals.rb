class CreateReturnals < ActiveRecord::Migration[7.0]
  def change
    create_table :returnals do |t|
      t.references :rental, null: false, foreign_key: true
      t.decimal :total_fine

      t.timestamps
    end
    add_foreign_key :returnals, :rentals
  end
end
