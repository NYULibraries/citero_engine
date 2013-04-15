class CreateTypeTwos < ActiveRecord::Migration
  def change
    create_table :type_twos do |t|
      t.string :from_format
      t.string :item
      t.string :data

      t.timestamps
    end
  end
end
