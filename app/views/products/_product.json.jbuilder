json.extract! product, :id, :name, :unit_prize, :tax_percentage, :created_at, :updated_at
json.url product_url(product, format: :json)
