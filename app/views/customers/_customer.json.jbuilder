json.extract! customer, :id, :email, :created_at, :updated_at
json.url customer_url(customer, format: :json)
