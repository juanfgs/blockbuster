class MoviesController < ApplicationController
  before_action :set_movie, only: %i[show update destroy]
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!, only: %i[index]
  prepend_before_action :authenticate_with_admin_key!, only: %i[show create update destroy]
  # GET /movies
  def index
    @movies = if params.has_key? :movie
                Movie.filter(params.fetch(:movie).slice(:release_year, :name, :description, :genre))
              else
                Movie.all
              end
    render json: @movies.as_json(methods: :image_url)
  end

  # GET /movies/1
  def show
    render json: @movie, include: [rentals: { include: :returnal }]
  end

  # POST /movies
  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      render json: @movie, status: :created, location: @movie
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /movies/1
  def update
    if @movie.update(movie_params)
      render json: @movie
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  # DELETE /movies/1
  def destroy
    @movie.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_movie
    @movie = Movie.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def movie_params
    params.require(:movie).permit(:name, :description, :genre, :release_year,
                                  :available_copies, :daily_rental_price, :image)
  end
end
