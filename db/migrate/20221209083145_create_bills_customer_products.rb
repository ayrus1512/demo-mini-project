class CreateBillsCustomerProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :bills_customer_products do |t|
      t.references :bill, null: false, foreign_key: true
      t.references :customer_product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
