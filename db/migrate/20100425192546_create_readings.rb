class CreateReadings < ActiveRecord::Migration
  def self.up
    create_table :readings do |t|
      t.timestamp "created_at"
    end
  end

  def self.down
    drop_table :readings
  end
end
