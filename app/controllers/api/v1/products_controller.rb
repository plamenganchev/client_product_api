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
      filtered_products = ProductsFilterService.new(products, params).run
      render json: paginate_records(filtered_products)
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
