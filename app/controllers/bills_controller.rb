class BillsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_bill, only: %i[ show edit update destroy ]

  # GET /bills or /bills.json
  def index
    @bills = Bill.all
  end

  # GET /bills/1 or /bills/1.json
  def show
    balance_denomination(@bill)
  end

  # GET /bills/new
  def new
    @bill = Bill.new
  end

  # GET /bills/1/edit
  def edit
  end

  # POST /bills or /bills.json
  def create
    @bill = Bill.new(bill_params)

    respond_to do |format|
      if @bill.save
        format.html { redirect_to bill_url(@bill), notice: "Bill was successfully created." }
        format.json { render :show, status: :created, location: @bill }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bills/1 or /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to bill_url(@bill), notice: "Bill was successfully updated." }
        format.json { render :show, status: :ok, location: @bill }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1 or /bills/1.json
  def destroy
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to bills_url, notice: "Bill was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_customer
      @customer = Customer.find_or_create_by(email: params[:email])
    end

    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bill_params
      params.require(:bill).permit(:email)
    end

    def balance_denomination(bill)
      balance = bill.balance_amount
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
