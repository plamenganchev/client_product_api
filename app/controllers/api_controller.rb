class ApiController < ApplicationController
  include Authenticatable
  include UserForPaperTrail

  before_action :set_record, only: [:show, :update, :destroy]
  before_action :authenticate_admin, only: [:create, :update, :destroy]

  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10
  def index
    records = model_class.page(params[:page]).per(params[:per_page])
    render json: records, status: :ok
  end

  def show
    render json: @record, status: :ok
  end

  def create
    record = model_class.new(record_params)
    if record.save
      render json: record, status: :created
    else
      render json: record.errors, status: :unprocessable_entity
    end
  end

  def update
    if @record.update(record_params)
      render json: @record, status: :ok
    else
      render json: @record.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @record.destroy
    head :no_content
  end

  private

  def set_record
    @record = model_class.find(params[:id])
  end

  def model_class
    raise NotImplementedError, "This #{self.class} cannot respond to 'model_class'"
  end

  def record_params
    raise NotImplementedError, "This #{self.class} cannot respond to 'record_params'"
  end
  def authenticate_admin
    # Can be extended with RolePermissions model
    render json: { error: 'Forbidden' }, status: :forbidden unless current_user&.admin?
  end

  def paginate_records(records)
    page = (params[:page] || DEFAULT_PAGE).to_i
    per_page = (params[:per_page] || DEFAULT_PER_PAGE).to_i
    paginated_records = records.page(page).per(per_page)
    {
      records: paginated_records,
      total_records: paginated_records.total_count,
      page: page,
      per_page: per_page
    }
  end
end