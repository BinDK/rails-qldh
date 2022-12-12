class CreateReferrers < ActiveRecord::Migration[7.0]
  def change
    create_table :referrers do |t|
      t.string :name
      t.integer :phone
      t.text :banking_informations

      t.timestamps
    end
  end
end
