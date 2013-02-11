class CreateCiteroEngineRecords < ActiveRecord::Migration
  def change
    create_table :citero_engine_records do |t|
      t.string :formatting
      t.text :title
      t.string :raw

      t.timestamps
    end
  end
end
