require 'rails_helper'

RSpec.describe Movie, type: :model do
  before(:all) do
    @valid_parameters = {
      name: 'The Matrix',
      description: 'When computer programmer Thomas Anderson...',
      genre: 'Sci-Fi',
      release_year: 1999,
      available_copies: 9,
      daily_rental_price: 9.5
    }
    @invalid_parameters = {
      name: nil,
      description: nil,
      genre: nil,
      release_year: nil,
      available_copies: nil,
      daily_rental_price: nil
    }
  end
  describe 'creation' do
    it 'it allows creation with valid parameters' do
      movie = Movie.create @valid_parameters
      expect(movie).to be_valid

      expect(movie[:name]).to eq(@valid_parameters[:name])
      expect(movie[:description]).to eq(@valid_parameters[:description])
      expect(movie[:genre]).to eq(@valid_parameters[:genre])
      expect(movie[:release_year]).to eq(@valid_parameters[:release_year])
      expect(movie[:available_copies]).to eq(@valid_parameters[:available_copies])
      expect(movie[:daily_rental_price]).to eq(@valid_parameters[:daily_rental_price])
    end

    it 'does not create records if parameters are not valid' do
      movie = Movie.create @invalid_parameters
      expect(movie).not_to be_valid
    end
  end
  describe 'destruction' do
    before(:each) do
      @movie = Movie.create({
                              name: 'The Matrix',
                              description: 'When computer programmer Thomas Anderson...',
                              genre: 'Sci-Fi',
                              release_year: 1999,
                              available_copies: 9,
                              daily_rental_price: 9.5
                            })
    end
    it 'successfully destroys a record' do
      @movie.destroy
      expect { Movie.find(@movie.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
  describe 'update' do
    before(:all) do
      @movie = Movie.create @valid_parameters
    end
    it 'it allows updating with valid parameters' do
      @movie.update({ name: 'Jaws' })

      expect(@movie[:name]).to eq('Jaws')
    end

    it 'does not update records if parameters are not valid' do
      @movie.update({ name: nil })

      expect(@movie).not_to be_valid
    end
  end
end
