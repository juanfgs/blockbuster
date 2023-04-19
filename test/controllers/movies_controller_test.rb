require "test_helper"

class MoviesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movie = movies(:one)
  end

  test "should get index" do
    get movies_url, as: :json
    assert_response :success
  end

  test "should create movie" do
    assert_difference("Movie.count") do
      post movies_url, params: { movie: { available_copies: @movie.available_copies, daily_rental_price: @movie.daily_rental_price, description: @movie.description, genre: @movie.genre, name: @movie.name, release_year: @movie.release_year } }, as: :json
    end

    assert_response :created
  end

  test "should show movie" do
    get movie_url(@movie), as: :json
    assert_response :success
  end

  test "should update movie" do
    patch movie_url(@movie), params: { movie: { available_copies: @movie.available_copies, daily_rental_price: @movie.daily_rental_price, description: @movie.description, genre: @movie.genre, name: @movie.name, release_year: @movie.release_year } }, as: :json
    assert_response :success
  end

  test "should destroy movie" do
    assert_difference("Movie.count", -1) do
      delete movie_url(@movie), as: :json
    end

    assert_response :no_content
  end
end
