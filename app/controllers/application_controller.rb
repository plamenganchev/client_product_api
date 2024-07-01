class ApplicationController < ActionController::API
  include Authenticatable
  before_action :set_paper_trail_whodunnit

end
