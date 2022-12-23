class ChangeOrderCol < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :discount_unit,:integer,default: 0
    rename_column :orders,:discount,:discount_value
  end
end
