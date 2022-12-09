class Customer < ApplicationRecord
  has_many :bills, dependent: :destroy

  has_many :customer_products
  has_many :products, through: :customer_products
  accepts_nested_attributes_for :customer_products, allow_destroy: true

  # ===================== Validations =====================
  validates :email, presence: true, uniqueness: true
end
