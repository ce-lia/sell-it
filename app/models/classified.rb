class Classified < ApplicationRecord
  belongs_to :user

  validates :user, :title, :price, :description, presence: true
  validates :price, numericality: true
end
