class ReturnalsController < ApplicationController
  before_action :set_returnal, only: %i[show]
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!, only: %i[create show]

  # GET /returnals/1
  def show
    render json: @returnal
  end

  # POST /returnals
  def create
    rental = Rental.find_by_id(returnal_params[:rental_id])

    @returnal = Returnal.new(returnal_params.merge({ total_fine: rental.calculate_total_fine }))
    if rental && @returnal.save
      rental.movie.increase_availability!
      render json: @returnal, status: :created, location: @returnal
    else
      render json: @returnal.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_returnal
    @returnal = Returnal.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def returnal_params
    params.require(:returnal).permit(:rental_id, :total_fine)
  end
end
