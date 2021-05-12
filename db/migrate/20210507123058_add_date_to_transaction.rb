class AddDateToTransaction < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :action_date, :datetime
  end
end
