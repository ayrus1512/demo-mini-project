class Customer < ApplicationRecord
  has_many :bills, dependent: :destroy

  has_many :customer_products
  has_many :products, through: :customer_products
  accepts_nested_attributes_for :customer_products, allow_destroy: true, reject_if: :all_blank

  # ===================== Validations =====================
  validates :email, presence: true, uniqueness: true
end
