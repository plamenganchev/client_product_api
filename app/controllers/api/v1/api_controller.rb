module Api::V1
  class ApiController < ApplicationController
    before_action :set_record, only: [:show, :update, :destroy]
    before_action :authenticate_admin

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
      record = model_class.new(permitted_params)
      if record.save
        render json: record, status: :created
      else
        render json: record.errors, status: :unprocessable_entity
      end
    end

    def update
      if @record.update(permitted_params)
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

    def permitted_params
      raise NotImplementedError, "This #{self.class} cannot respond to 'permitted_params'"
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
        data: paginated_records,
        page: page,
        per_page: per_page,
        total_pages: paginated_records.total_pages,
        total_records: paginated_records.total_count,
      }
    end
  end
end
