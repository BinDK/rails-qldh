class ChangeTypeToCustomer < ActiveRecord::Migration[7.0]
  def change
    change_column :customers,:phone,:string
  end
end
