module Api::V1
  class TransactionsController < ApiController

    def create
      transaction = Transaction.new(permitted_params)
      if transaction.save
        render json: transaction, status: :created
      else
        render json: transaction.errors, status: :unprocessable_entity
      end
    end

    private

    def permitted_params
      params.require(:transaction).permit(:client_id, :product_id, :transaction_type, :amount)
    end
  end
end
