class RentalsController < ApplicationController
  # POST /rentals
  def create
    @rental = Rental.new(rental_params)
    # Do not allow rental if not available copies exist
    if @rental.movie.available_copies >= 1 && @rental.save
      @rental.movie.decrease_availability!
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
