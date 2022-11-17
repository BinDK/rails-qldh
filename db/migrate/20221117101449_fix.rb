class Fix < ActiveRecord::Migration[7.0]
  def change
    rename_column :addresses, :sub_district, :ward
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
