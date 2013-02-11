class CreateTypeOnes < ActiveRecord::Migration
  def change
    create_table :type_ones do |t|
      t.string :formatting
      t.string :title
      t.string :raw

      t.timestamps
    end
  end
end
