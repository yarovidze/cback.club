class CreateTrials < ActiveRecord::Migration[6.1]
  def change
    create_table :trials do |t|
      t.string :name
      t.string :test_field1
      t.string :test_field2
      t.string :test_field3

      t.timestamps
    end
  end
end
