class CreateTemperatures < ActiveRecord::Migration
  def self.up
    create_table :temperatures do |t|
      t.float :value
      t.references :reading
    end
  end

  def self.down
    drop_table :temperatures
  end
end
