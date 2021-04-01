class AddSlugToOffers < ActiveRecord::Migration[6.1]
  def change
    add_column :offers, :slug, :string
    add_index :offers, :slug, unique: true
  end
end
