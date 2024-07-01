class CardsController < ApiController
  before_action :authenticate_admin, except: [:issue, :cancel, :generate_report]
  def issue
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

  def cancel
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
end
