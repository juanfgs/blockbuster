require 'rails_helper'

RSpec.describe 'Movies', type: :request do
  describe 'GET /movies' do
    before { @token = authenticate(:user) }
    it 'returns the current movies successfully' do
      movie = FactoryBot.create(:movie)
      get '/movies', headers: { Authorization: "Bearer #{@token}" }
      expect(response).to be_successful
      expect(response.body).to include(movie.name)
    end
    it 'allows to search movies by date' do
      movie = FactoryBot.create(:movie, release_year: 2011)
      movie2 = FactoryBot.create(:movie, release_year: 2012)
      get '/movies', params: { movie: { release_year: movie.release_year } },
                     headers: { Authorization: "Bearer #{@token}" }
      expect(response).to be_successful
      expect(response.body).to include(movie.name)
      expect(response.body).not_to include(movie2.name)
    end
    it 'allows to search movies by name' do
      movie = FactoryBot.create(:movie, name: 'El Gato Con Botas')
      movie2 = FactoryBot.create(:movie, name: 'Shrek')
      get '/movies', params: { movie: { name: 'Gato' } },
                     headers: { Authorization: "Bearer #{@token}" }
      expect(response).to be_successful
      expect(response.body).to include(movie.name)
      expect(response.body).not_to include(movie2.name)
    end
    it 'allows to search movies by genre' do
      movie = FactoryBot.create(:movie, genre: 'Horror')
      movie2 = FactoryBot.create(:movie, genre: 'Sci-Fi')
      get '/movies', params: { movie: { genre: 'Horror' } },
                     headers: { Authorization: "Bearer #{@token}" }
      expect(response).to be_successful
      expect(response.body).to include(movie.name)
      expect(response.body).not_to include(movie2.name)
    end
  end

  describe 'POST /movies' do
    before { @token = authenticate(:admin) }

    it 'it creates a new movie' do
      movie = FactoryBot.attributes_for(:movie)
      post '/movies', params: { movie: }, headers: { Authorization: "Bearer #{@token}" }
      expect(response.status).to eq(201)
      json = JSON.parse(response.body)
      expect(json[:name]).to eq(movie['name'])
    end
    it 'it does not create a new movie with invalid parameters' do
      post '/movies', params: { movie: FactoryBot.attributes_for(:movie, name: nil) },
                      headers: { Authorization: "Bearer #{@token}" }
      expect(response.status).to eq(422)
    end
    it 'it does not create a new movie if unauthenticated' do
      movie = FactoryBot.attributes_for(:movie)
      post '/movies', params: { movie: }
      expect(response.status).to eq(401)
    end
    it 'it does not create a new movie if user is not an admin' do
      token = authenticate(:user)
      movie = FactoryBot.attributes_for(:movie)
      post '/movies', params: { movie: }, headers: { Authorization: "Bearer #{token}" }

      expect(response.status).to eq(401)
    end
  end

  describe 'PATCH /movies/{id}' do
    before { @token = authenticate(:admin) }

    it 'it modifies a  movie' do
      movie = FactoryBot.create(:movie)
      patch "/movies/#{movie.id}", params: { movie: { name: 'The Lord of The Rings' } },
                                   headers: { Authorization: "Bearer #{@token}" }

      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json['name']).to eq('The Lord of The Rings')
    end
    it 'it does not create a new movie with invalid parameters' do
      movie = FactoryBot.create(:movie)
      patch "/movies/#{movie.id}", params: { movie: { name: nil } },
                                   headers: { Authorization: "Bearer #{@token}" }
      expect(response.status).to eq(422)
    end
    it 'it does not create a new movie if unauthenticated' do
      movie = FactoryBot.create(:movie)
      patch "/movies/#{movie.id}", params: { movie: { name: nil } }
      expect(response.status).to eq(401)
    end
    it 'it does not create a new movie if user is not an admin' do
      token = authenticate(:user)
      movie = FactoryBot.create(:movie)
      patch "/movies/#{movie.id}", params: { movie: { name: 'The Lord of The Rings' } },
                                   headers: { Authorization: "Bearer #{token}" }

      expect(response.status).to eq(401)
    end
  end

  private

  def authenticate(role)
    @user = FactoryBot.create(:user, role:)

    encoded_credentials = ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, @user.password)
    post '/api-keys', headers: { Authorization: encoded_credentials }
    json = JSON.parse(response.body).deep_symbolize_keys
    json[:token]
  end
end
