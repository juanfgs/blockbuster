require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe '/rentals', type: :request do
  before(:all) do
    @user = FactoryBot.create(:user, role: :user)
    @movie = FactoryBot.create(:movie)
  end
  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # RentalsController, or in your router and rack
  # middleware. Be sure to keep this updated too.

  let(:valid_headers) do
    encoded_credentials = ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, @user.password)
    post '/api-keys', headers: { Authorization: encoded_credentials }
    json = JSON.parse(response.body).deep_symbolize_keys
    token = json[:token]

    { Authorization: "Bearer #{token}" }
  end

  # This should return the minimal set of attributes required to create a valid
  # Rental. As you add validations to Rental, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { rental_days: 4 }
  end

  let(:invalid_attributes) do
    { rental_days: 8 }
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Rental' do
        valid_attr = valid_attributes.merge({ user_id: @user.id, movie_id: @movie.id })
        expect do
          post rentals_url,
               params: { rental: valid_attr }, headers: valid_headers, as: :json
        end.to change(Rental, :count).by(1)
      end
      it 'Renting a movie decreases availability' do
        available_copies = @movie.available_copies
        valid_attr = valid_attributes.merge({ user_id: @user.id, movie_id: @movie.id })
        post rentals_url,
             params: { rental: valid_attr }, headers: valid_headers, as: :json
        expect(@movie.reload.available_copies).to eq(available_copies - 1)
      end

      it 'renders a JSON response with the new rental' do
        valid_attr = valid_attributes.merge({ user_id: @user.id, movie_id: @movie.id })
        post rentals_url,
             params: { rental: valid_attr }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Rental' do
        expect do
          post rentals_url,
               params: { rental: invalid_attributes }, as: :json
        end.to change(Rental, :count).by(0)
      end

      it 'renders a JSON response with errors for the new rental' do
        post rentals_url,
             params: { rental: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end
end