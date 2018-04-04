class Book < ApplicationRecord
  belongs_to :format
  has_and_belongs_to_many :authors

  validates :title, presence: true
  validates :release_date, presence: true
  validates :price,
            numericality: { allow_nil: true, greater_than_or_equal_to: 0 }
  validates :price, presence: true, if: :base_price_required?
  validates :authors, length: { minimum: 1, message: 'An author is required' }

  MAX_MONTHS_BEFORE_PUB_WITHOUT_PRICE = 2
  AUTHORS_SEPARATOR = ', '.freeze

  def authors_for_display
    authors.map(&:name).join(AUTHORS_SEPARATOR)
  end

  private

  def base_price_required?
    release_date - MAX_MONTHS_BEFORE_PUB_WITHOUT_PRICE.months <= Date.today
  end
end
