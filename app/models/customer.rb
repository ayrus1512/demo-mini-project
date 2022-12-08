class Customer < ApplicationRecord
  has_many :bills, dependent: :destroy

  has_many :customer_products
  has_many :products, through: :customer_products
  accepts_nested_attributes_for :customer_products, allow_destroy: true

  # def customer_products_attributes=(customer_products_attributes)
  #   if customer_products_attributes[:id].length > 0 && customer_products_attributes[:quantity].length > 0
  #     self.customer_products.build(customer_products_attributes)
  #   end
  # end

  # ===================== Validations =====================
  validates :email, presence: true, uniqueness: true
end
