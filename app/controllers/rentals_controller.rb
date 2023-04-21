class RentalsController < ApplicationController
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!, only: %i[create]

  # POST /rentals
  def create
    rental_with_user_id = rental_params.merge(user_id: @current_bearer.id)

    movie = Movie.find_by_id(rental_params[:movie_id])
    @rental = Rental.new(rental_with_user_id)
    # Do not allow rental if not available copies exist
    if movie && movie.available_copies >= 1 && @rental.save
      movie.decrease_availability!
      render json: @rental, status: :created, location: @rental
    else
      render json: @rental.errors, status: :unprocessable_entity
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def rental_params
    params.require(:rental).permit(:user_id, :movie_id, :rental_days)
  end
end
