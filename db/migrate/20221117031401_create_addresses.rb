class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :province_city
      t.string :district
      t.string :sub_district
      t.string :street

      t.timestamps
    end
  end
end
