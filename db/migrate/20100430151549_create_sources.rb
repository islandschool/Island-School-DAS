class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.string :key, :null => false
      t.string :name, :null => false
      t.references :campus
      t.references :source_type
      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end
