class Movie < ApplicationRecord
  has_one_attached :image
  validates :name, presence: true

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end
end
