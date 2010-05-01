class CreateEnergyReadings < ActiveRecord::Migration
  def self.up
    create_table :energy_readings do |t|
      t.float :frequency
      t.float :voltage
      t.float :voltage_a
      t.float :voltage_b
      t.float :current
      t.float :current_a
      t.float :current_b
      t.float :power
      t.float :power_a
      t.float :power_b
      t.float :energy
      t.float :energy_a
      t.float :energy_b
      t.references :reading
      t.references :source
    end
  end

  def self.down
    drop_table :energy_readings
  end
end
