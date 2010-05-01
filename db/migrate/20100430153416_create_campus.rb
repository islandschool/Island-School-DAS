class CreateCampus < ActiveRecord::Migration
  def self.up
    create_table :campus do |t|
      t.string :name, :null => false
      t.float :latitute
      t.float :longitude
      t.timestamps
    end
  end

  def self.down
    drop_table :campus
  end
end
