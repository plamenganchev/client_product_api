class ApplicationController < ActionController::API
  include Api::V1::Authenticatable
  before_action :set_paper_trail_whodunnit

end
