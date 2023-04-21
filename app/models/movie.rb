class Movie < ApplicationRecord
  include Filterable
  has_one_attached :image
  validates :name, presence: true, uniqueness: true
  has_many :rentals

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end

  scope :filter_by_release_year, ->(release_year) { where release_year: }
  scope :filter_by_name, ->(name) { where('name like ? ', "%#{name}%") }
  scope :filter_by_description, ->(description) { where('description like ? ', "%#{description}%") }
  scope :filter_by_genre, ->(genre) { where('genre like ? ', "%#{genre}%") }

  def decrease_availability!
    update_attribute(:available_copies, available_copies - 1)
  end

  def increase_availability!
    update_attribute(:available_copies, available_copies - 1)
  end
end
