class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :payment_method
      t.decimal :shipping_cost
      t.decimal :discount
      t.string :status
      t.datetime :completed_at
      t.text :note

      t.timestamps
    end
  end
end
