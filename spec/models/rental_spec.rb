require 'rails_helper'

RSpec.describe Rental, type: :model do
  before(:all) do
    @movie = FactoryBot.create(:movie)
    @user = FactoryBot.create(:user)
  end
  describe 'calculate fine amount' do
    it 'it calculates the amount of the fine' do
      rental = Rental.create({ rental_days: 5,
                               user_id: @user.id,
                               movie_id: @movie.id,
                               created_at: 10.days.ago,
                               updated_at: 10.days.ago })
      expect(rental.calculate_total_fine).to eq(25.0)
    end
    it 'it returns zero if the rent is not overdue' do
      rental = Rental.create({ rental_days: 5,
                               user_id: @user.id,
                               movie_id: @movie.id })
      expect(rental.calculate_total_fine).to eq(0.00)
    end

    it 'does not create records if parameters are not valid' do
      movie = Movie.create @invalid_parameters
      expect(movie).not_to be_valid
    end
  end
end
