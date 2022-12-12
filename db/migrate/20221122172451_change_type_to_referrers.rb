class ChangeTypeToReferrers < ActiveRecord::Migration[7.0]
  def change
    change_column :referrers,:phone,:string
  end
end
