class AddAddressRefToOrders < ActiveRecord::Migration[7.0]
  # def change
  #   add_reference :orders, :address, foreign_key: true
  # end
  def change
    add_column :orders,:address_info, :text
  end
end
