class ReportsController < ApiController
  before_action :authenticate_admin, except: [:transactions_report]
  def by_brand
    brand = Brand.find(params[:brand_id])
    products = brand.products
    render json: paginate_records(products)
  end

  def by_client
    client = User.find(params[:client_id])
    cards = client.cards
    render json: paginate_records(cards)
  end

  def transactions_report
    start_date = params[:start_date].presence || Time.zone.now.beginning_of_month
    end_date = params[:end_date].presence || Time.zone.now.end_of_month

    transactions = Transaction.where(created_at: start_date..end_date)

    report_data = transactions.group_by(&:transaction_type).transform_values do |trans|
      {
        count: trans.count,
        total_amount: trans.sum(&:amount)
      }
    end

    render json: { report: report_data }, status: :ok
  end
end
