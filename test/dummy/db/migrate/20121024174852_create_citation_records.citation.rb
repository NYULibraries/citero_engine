# This migration comes from citation (originally 20121024153148)
class CreateCitationRecords < ActiveRecord::Migration
  def change
    create_table :citation_records do |t|
      t.string :formatting
      t.string :title
      t.text :raw

      t.timestamps
    end
  end
end
