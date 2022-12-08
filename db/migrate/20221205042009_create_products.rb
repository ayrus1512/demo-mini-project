class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.float :unit_prize
      t.float :tax_percentage

      t.timestamps
    end
  end
end
