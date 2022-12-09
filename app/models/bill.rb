class Bill < ApplicationRecord
  belongs_to :customer

  has_and_belongs_to_many :customer_products
end
