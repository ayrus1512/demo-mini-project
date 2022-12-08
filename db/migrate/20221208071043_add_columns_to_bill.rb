class AddColumnsToBill < ActiveRecord::Migration[6.1]
  def change
    add_column :bills, :cash_given, :integer
    add_column :bills, :total_purchased_prize, :float
    add_column :bills, :total_tax_amount, :float
    add_column :bills, :total_bill_amount, :float
    add_column :bills, :rounded_bill_amount, :float
    add_column :bills, :balance_amount, :float
  end
end
