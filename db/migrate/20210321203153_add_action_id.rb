class AddActionId < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :action_id, :integer
    add_column :transactions, :cashback_sum, :float
  end
end
