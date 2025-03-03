class CategorizationRule < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :pattern, presence: true
end
