class Book < ApplicationRecord
  belongs_to :format
  has_and_belongs_to_many :authors

  validates :title, presence: true
  validates :release_date, presence: true
  validates :price,
            numericality: { allow_nil: true, greater_than_or_equal_to: 0 }
  validates :price, presence: true, if: :base_price_required?
  validates :authors,
            length: { minimum: 1, message: 'At least one is required' }

  MAX_MONTHS_BEFORE_PUB_WITHOUT_PRICE = 2
  AUTHORS_SEPARATOR = ', '.freeze

  scope :report, ->(year, format_id) do
    start_date = Date.new(year, 1, 1)
    end_date   = start_date.end_of_year
    where('release_date between ? and ?', start_date, end_date)
      .where('format_id = ?', format_id)
      .order('release_date, title')
  end

  before_validation { self.title = title.to_s.strip }

  def authors_for_display
    authors.map(&:name).join(AUTHORS_SEPARATOR)
  end

  def format_for_display
    format.name
  end

  def authors_for_client
    authors.map { |a| { id: a.id, name: a.name } }
  end

  private

  def base_price_required?
    release_date &&
      release_date - MAX_MONTHS_BEFORE_PUB_WITHOUT_PRICE.months <= Date.today
  end
end
