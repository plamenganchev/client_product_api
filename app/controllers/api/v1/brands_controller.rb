module Api::V1
  class BrandsController < ApiController
    private
    def model_class
      Brand
    end


    def permitted_params
      params.require(:brand).permit(:name, :country, :description, :status)
    end
  end
end