class CustomersController < ApplicationController
  before_action :set_customer, only: %i[ show edit update destroy ]

  # GET /customers or /customers.json
  def index
    @customers = Customer.all
  end

  # GET /customers/1 or /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
    @customer.customer_products.build
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers or /customers.json
  def create
    denomination_check
    if @condition
      @customer = Customer.find_or_create_by(email: params[:customer][:email])

      calculation_part(params[:customer][:customer_products_attributes], @customer, params[:cash].to_i)

      respond_to do |format|
        if @customer.valid? && !@bill.nil?
          format.html { redirect_to bill_url(@bill), notice: "New Bill was successfully created." }
          format.json { render :show, status: :created, location: @customer }
        else
          format.html { redirect_to new_customer_url, notice: "Given Cash Amount is insufficient." }
          format.json { render json: @customer.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to new_customer_url, notice: "Given Cash Amount does not tally with given denomination." }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1 or /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to customer_url(@customer), notice: "Customer was successfully updated." }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1 or /customers/1.json
  def destroy
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to customers_url, notice: "Customer was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.require(:customer)
            .permit(:email, :product, customer_products_attributes: [:id, :quantity, :_destroy])
    end

    def denomination_check
      condition = (params[:denomination_500].to_i * 500) +
        (params[:denomination_100].to_i * 100) +
        (params[:denomination_50].to_i * 50) +
        (params[:denomination_10].to_i * 10) +
        (params[:denomination_5].to_i * 5) + (params[:denomination_1].to_i * 1)
      if condition == params[:cash].to_i
        @condition = true
      else
        @condition = false
      end
    end

    def calculation_part(customer_product_attributes, customer, cash_given)
      @customer_products = []
      calculation_list = []
      total_purchased_prize, total_tax_amount, total_bill_amount = 0, 0, 0

      customer_product_attributes.each do |key, value|
        puts key, value
        if value[:_destroy] != "removed" && value[:quantity] != "" && value[:id] != ""
          puts value[:_destroy]
          puts value[:id]
          puts value[:quantity]
          puts "----------------"
          quantity = value[:quantity]
          product_id = value[:id]
          product = Product.find(product_id)
          purchased_prize = quantity.to_f * (product.unit_prize)
          tax_amount = ((product.tax_percentage/ 100) * purchased_prize).truncate(2)
          total_prize = purchased_prize + tax_amount
          calculation_list.append([purchased_prize, tax_amount, total_prize])

          customer_product = CustomerProduct.create(product_id: product.id, customer_id: customer.id,
                                                    quantity: quantity, purchased_prize: purchased_prize,
                                                    tax_amount: tax_amount, total_prize: total_prize)

          @customer_products.append(customer_product)
        end
      end

      calculation_list.each do |c|
        total_purchased_prize += c[0]
        total_tax_amount += c[1]
        total_bill_amount += c[2]
      end

      rounded_bill_amount = total_bill_amount

      if cash_given >= rounded_bill_amount
        balance_amount = cash_given - rounded_bill_amount

        @bill = Bill.create(customer_id: customer.id,
                            cash_given: cash_given,
                            total_purchased_prize: total_purchased_prize.round(2),
                            total_tax_amount: total_tax_amount.round(2),
                            total_bill_amount: total_bill_amount.round(2),
                            rounded_bill_amount: (rounded_bill_amount.round()).to_f,
                            balance_amount: balance_amount.round())

        @customer_products.each do |customer_product|
          customer_product = CustomerProduct.find(customer_product.id)
          @bill.customer_products << customer_product
        end

      else
        @customer_products.each do |customer_product|
          customer_product.destroy
        end
      end

    end
end
