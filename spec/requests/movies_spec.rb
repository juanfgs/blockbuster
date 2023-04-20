require 'rails_helper'

RSpec.describe 'Movies', type: :request do
  before(:all) do
    @valid_parameters = {
      name: 'The Matrix',
      description: 'When computer programmer Thomas Anderson...',
      genre: 'Sci-Fi',
      release_year: 1999,
      available_copies: 9,
      daily_rental_price: 9.5
    }
  end

  describe 'GET /movies' do
    it 'returns the current movies successfully' do
      Movie.create(@valid_parameters)
      get '/movies'
      expect(response).to be_successful
      expect(response.body).to include('The Matrix')
    end
  end

  describe 'POST /movies' do
    it 'it creates a new movie' do
      Movie.create(@valid_parameters)
      post '/movies', params: { movie: @valid_parameters }
      expect(response.status).to eq(201)
      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:name]).to eq('The Matrix')
    end
    it 'it does not create a new movie with invalid parameters' do
      invalid_parameters = @valid_parameters.merge(name: nil)
      Movie.create(invalid_parameters)
      post '/movies', params: { movie: invalid_parameters }
      expect(response.status).to eq(422)
    end
  end
end
