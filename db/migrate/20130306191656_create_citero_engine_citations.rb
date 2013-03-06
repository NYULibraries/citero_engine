class CreateCiteroEngineCitations < ActiveRecord::Migration
  def change
    create_table :citero_engine_citations do |t|
      t.string :data
      t.string :from_format
      t.string :resource_key

      t.timestamps
    end
  end
end
