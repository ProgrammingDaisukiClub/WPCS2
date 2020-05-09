class Admin::AwardsController < Admin::ControllerBase
  before_action :set_award

  # GET /awards
  # GET /awards.json
  def index
    # @awards = Award.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_award
      # @award = Award.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def award_params
      params.require(:award).permit(:index)
    end
end
