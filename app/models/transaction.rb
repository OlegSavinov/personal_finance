class Transaction < ApplicationRecord
  belongs_to :bank_statement
  belongs_to :category

  validates :amount, presence: true #, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :date, presence: true
  validates :raw_string, presence: true

  before_create :assign_category_based_on_rules

  private

  def assign_category_based_on_rules
    # Find rules for the user and match them with raw_string or description
    rule = user.categorization_rules.find do |rule|
      raw_string.match?(rule.pattern)
    end

    self.category = rule&.category if rule
  end
end
