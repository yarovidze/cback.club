class ChangeTypeColumns < ActiveRecord::Migration[6.1]
  def change
    change_column :categories, :name, :string
    change_column :offers, :name, :string
    change_column :offers, :image, :string
    change_column :offers, :link, :string
  end
end
