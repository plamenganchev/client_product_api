class AccessibleProductsController < ApiController
  private

  def model_class
    AccessibleProduct
  end

  def record_params
    params.require(:accessible_product).permit(:user_id, :product_id)
  end
end