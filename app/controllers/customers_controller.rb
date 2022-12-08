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
    4.times do
      @customer.customer_products.build
    end
  end

  # GET /customers/1/edit
  def edit
  end

  # GET /display_bills
  def display_bills
    @customer = Customer.last
    @product = Product.last
    @customer_products = CustomerProduct.last(4)
    @bill_generated = Bill.last
    balance_denomination(@bill_generated)
  end

  # POST /customers or /customers.json
  def create
    helpers.denomination_check

    @customer = Customer.find_or_create_by(email: params[:customer][:email])

    calculation_part(params[:customer][:customer_products_attributes], @customer, params[:cash].to_i)

    respond_to do |format|
      if @customer.valid?
        format.html { redirect_to display_bills_url, notice: "Entry Created." }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new, status: :unprocessable_entity }
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
            .permit(:email, :product, customer_products_attributes: [:id, :quantity])
    end

    def calculation_part(customer_product_attributes, customer, cash)
      @customer_products = []
      calculation_list = []
      total_purchased_prize, total_tax_amount, total_bill_amount = 0, 0, 0

      customer_product_attributes.each do |key, value|
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

      calculation_list.each do |c|
        total_purchased_prize += c[0]
        total_tax_amount += c[1]
        total_bill_amount += c[2]
      end

      total_bill_amount
      rounded_bill_amount = total_bill_amount
      balance_amount = cash - rounded_bill_amount

      @bill_generated = Bill.create(customer_id: customer.id,
                                    cash_given: cash,
                                    total_purchased_prize: total_purchased_prize.round(2),
                                    total_tax_amount: total_tax_amount.round(2),
                                    total_bill_amount: total_bill_amount.round(2),
                                    rounded_bill_amount: (rounded_bill_amount.round()).to_f,
                                    balance_amount: balance_amount.round(2))
    end

    def balance_denomination(bill_generated)
      balance = bill_generated.balance_amount
      @denomination_500, @denomination_100, @denomination_50 = 0, 0, 0
      @denomination_10, @denomination_5, @denomination_1 = 0, 0, 0
      while balance != 0
        if balance >= 500
          @denomination_500 = (balance/500).to_i
          balance -= (@denomination_500 * 500)
        elsif balance >= 100 && balance < 500
          @denomination_100 = (balance/100).to_i
          balance -= (@denomination_100 * 100)
        elsif balance >= 50 && balance < 100
          @denomination_50 = (balance/50).to_i
          balance -= (@denomination_50 * 50)
        elsif balance >= 10 && balance < 50
          @denomination_10 = (balance/10).to_i
          balance -= (@denomination_10 * 10)
        elsif balance >= 5 && balance < 10
          @denomination_5 = (balance/5).to_i
          balance -= (@denomination_5 * 5)
        elsif balance >= 1
          @denomination_1 = (balance/1).to_i
          balance -= (@denomination_1 * 1)
        end
      end
    end
end
