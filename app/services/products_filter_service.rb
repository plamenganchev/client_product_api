class ProductsFilterService
  def initialize(products, params)
    @products = products
    @params = params
  end

  def run
    filter_by_name
    filter_by_description
    filter_by_brand_name
    filter_by_price_range
    @products
  end

  private

  def filter_by_name
    @products = @products.search_by_name(@params[:name])
  end

  def filter_by_description
    @products = @products.search_by_description(@params[:description])
  end

  def filter_by_brand_name
    @products = @products.search_by_brand_name(@params[:brand_name])
  end

  def filter_by_price_range
    @products = @products.filter_by_price_range(@params[:min_price], @params[:max_price])
  end
end
