class AddIconToCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :category_icon, :text
  end
end
