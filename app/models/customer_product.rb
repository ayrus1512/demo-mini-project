class CustomerProduct < ApplicationRecord
  belongs_to :customer
  belongs_to :product

  has_and_belongs_to_many :bills
end
