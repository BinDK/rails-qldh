class AddNullToOrders < ActiveRecord::Migration[7.0]
  def change
    change_column :orders, :referrer_id,:bigint,:null => true
  end
end
