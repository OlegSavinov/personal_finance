class Category < ApplicationRecord
  belongs_to :user, optional: true
  has_many :transactions, dependent: :nullify
  has_many :categorization_rules, dependent: :destroy

  validates :name, presence: true
end
