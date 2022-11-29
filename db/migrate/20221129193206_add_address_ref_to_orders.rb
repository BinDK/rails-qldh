class AddAddressRefToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :address, foreign_key: true
  end
end
