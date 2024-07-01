class ProductsController < ApiController
  before_action :authenticate_admin, only: [:create, :update, :destroy, :assign_to_user]

  def search
    products = Product.where('name LIKE ?', "%#{params[:query]}%")
    render json: paginate_records(products)
  end

  def issue_card
    product = Product.find(params[:product_id])
    card = Card.new(
      product: product,
      user: current_user,
      activation_number: SecureRandom.hex(10),
      pin: params[:pin],
      status: 'active'
    )

    if card.save
      render json: card, status: :created
    else
      render json: card.errors, status: :unprocessable_entity
    end
  end

  def cancel_card
    card = current_user.cards.find_by(id: params[:id])

    if card&.update(status: 'cancelled')
      render json: card
    else
      render json: { error: 'Card not found or cannot be cancelled' }, status: :unprocessable_entity
    end
  end

  def generate_report
    cards = current_user.cards
    render json: paginate_records(cards)
  end

  def assign_to_user
    user = User.find(params[:user_id])
    product = Product.find(params[:product_id])
    begin
      if user.products << product
        render json: { message: 'Product assigned to user successfully' }, status: :ok
      else
        render json: { error: 'Failed to assign product to user' }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique
      render json: { error: 'Already assigned' }, status: :unprocessable_entity
    end
  end

  def accessible
    products = current_user.products
    render json: paginate_records(products)
  end

  private

  def model_class
    Product
  end

  def record_params
    params.require(:product).permit(:name, :description, :price, :status, :brand_id)
  end
end
