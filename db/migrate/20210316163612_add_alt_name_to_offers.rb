class AddAltNameToOffers < ActiveRecord::Migration[6.1]
  def change
   add_column :offers, :alt_name, :string

  end
end
