class Rental < ApplicationRecord
  FINE_AMOUNT = 5.00
  belongs_to :user
  belongs_to :movie
  has_one :returnal
  validates :user_id, presence: true
  validates :movie_id, presence: true
  validates :rental_days, presence: true, numericality: { less_than_or_equal_to: 7 }

  def calculate_total_fine
    limit_date = created_at.to_date + rental_days.days
    days_overdue = (Time.current.to_date - limit_date).to_i
    fine = days_overdue * FINE_AMOUNT
    return 0 unless fine.positive?

    days_overdue * FINE_AMOUNT
  end
end
