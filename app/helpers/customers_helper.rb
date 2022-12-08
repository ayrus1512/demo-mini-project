module CustomersHelper
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


end
