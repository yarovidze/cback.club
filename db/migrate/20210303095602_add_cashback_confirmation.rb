class AddCashbackConfirmation < ActiveRecord::Migration[6.1]
  def change
    add_column :offers, :confirmation, :integer
  end
end
