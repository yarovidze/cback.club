class AddUaNameToOffers < ActiveRecord::Migration[6.1]
  def change
    add_column :offers, :ua_name, :string
  end
end
