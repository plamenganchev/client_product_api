class BrandsController < ApiController
  private
  def model_class
    Brand
  end


  def record_params
    params.require(:brand).permit(:name, :country, :description, :status)
  end
end
