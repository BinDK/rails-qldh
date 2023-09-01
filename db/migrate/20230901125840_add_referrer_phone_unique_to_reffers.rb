class AddReferrerPhoneUniqueToReffers < ActiveRecord::Migration[7.0]
  def change
    add_index :referrers, :phone, unique: true
  end
end
