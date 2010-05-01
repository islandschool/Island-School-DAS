class CreateSourceTypes < ActiveRecord::Migration
  def self.up
    create_table :source_types do |t|
      t.string :name, :null => false
      t.boolean :production
      t.timestamps
    end
  end

  def self.down
    drop_table :source_types
  end
end
