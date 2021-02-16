class CreateOffers < ActiveRecord::Migration[6.1]
  def change
    create_table :offers do |t|
      t.text :name
      t.text :image
      t.text :link
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
