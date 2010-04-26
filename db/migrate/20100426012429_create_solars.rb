class CreateSolars < ActiveRecord::Migration
  def self.up
    create_table :solars do |t|
      t.float :irradiance
      t.references :reading
    end
  end

  def self.down
    drop_table :solars
  end
end
