class AddCashbackPercent < ActiveRecord::Migration[6.1]
  def change
    add_column :offers, :cashback_percent, :float, :default => 0.5
  end
end
