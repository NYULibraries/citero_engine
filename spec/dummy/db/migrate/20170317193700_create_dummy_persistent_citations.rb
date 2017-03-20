class CreateDummyPersistentCitations < ActiveRecord::Migration
  def change
    create_table :dummy_persistent_citations do |t|
      t.string :format
      t.string :data

      t.timestamps null: false
    end
  end
end
