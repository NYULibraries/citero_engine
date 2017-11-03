class CreateEmptyModels < ActiveRecord::Migration
  def change
    create_table :empty_models do |t|

      t.timestamps null: false
    end
  end
end
