class CreateCustomerProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :customer_products do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.float :purchased_prize
      t.float :tax_amount
      t.float :total_prize

      t.timestamps
    end
  end
end
