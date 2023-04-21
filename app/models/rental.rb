class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  has_one :returnal
  validates :user_id, presence: true
  validates :movie_id, presence: true
  validates :rental_days, presence: true, numericality: { less_than_or_equal_to: 7 }
end
