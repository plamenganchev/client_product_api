class ApplicationController < ActionController::API
  include Authenticatable
  include UserForPaperTrail
end
