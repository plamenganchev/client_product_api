module UserForPaperTrail
  extend ActiveSupport::Concern

  included do
    before_action :set_paper_trail_whodunnit
  end

  private

  def set_paper_trail_whodunnit
    PaperTrail.request.whodunnit = @current_user.id if @current_user
  end
end
