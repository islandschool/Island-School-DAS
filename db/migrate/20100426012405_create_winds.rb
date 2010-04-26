class CreateWinds < ActiveRecord::Migration
  def self.up
    create_table :winds do |t|
      t.float :speed
      t.float :direction
      t.references :reading
    end
  end

  def self.down
    drop_table :winds
  end
end
