module Api::V1
  class ProductsController < ApiController
    before_action :authenticate_admin, except: [:accessible]

    def search
      products = Product.where('name LIKE ?', "%#{params[:query]}%")
      render json: paginate_records(products)
    end

    def assign_to_user
      user = User.find(params[:user_id])
      products =  Product.where(id: params[:product_ids] || [])
      begin
        if user.products << products
          render json: { message: 'Product assigned to user successfully' }, status: :ok
        else
          render json: { error: 'Failed to assign product to user' }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotUnique
        render json: { error: 'Already assigned' }, status: :unprocessable_entity
      end
    end

    def accessible
      products = current_user.products.active
      products = Product.where("products.name LIKE ?", "%#{params[:name]}%") if params[:name]
      products = products.where("products.description LIKE ?", "%#{params[:description]}%") if params[:description]
      products = products.joins(:brand).where("brands.name LIKE ?", "%#{params[:brand_name]}%") if params[:brand_name]
      products = products.where(price: params[:min_price]..params[:max_price]) if params[:min_price].present? && params[:max_price].present?
      render json: paginate_records(products)
    end

    private

    def model_class
      Product
    end

    def permitted_params
      params.require(:product).permit(:name, :description, :price, :status, :brand_id)
    end
  end
end
