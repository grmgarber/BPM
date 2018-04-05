require 'rails_helper'

RSpec.describe Book, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:release_date) }

  context 'price is required' do
    before do
      allow(subject).to receive(:base_price_required?).and_return(true)
    end

    it { should validate_presence_of(:price) }
  end

  context 'price is NOT required' do
    before do
      allow(subject).to receive(:base_price_required?).and_return(false)
    end

    it { should_not validate_presence_of(:price) }
  end

  context 'acceptable price' do
    it 'accepts positive price' do
      book = build(:book)
      book.validate
      expect(book.errors[:price].blank?).to be_truthy
    end

    it 'accepts zero price' do
      book = build(:book, price: 0.0)
      book.validate
      expect(book.errors[:price].blank?).to be_truthy
    end
  end

  context 'unacceptable price' do
    it 'complains about negative price' do
      book = build(:book, price: -5)
      book.validate
      expect(book.errors[:price].first).to eq(
        'must be greater than or equal to 0'
      )
    end

    it 'accepts zero price' do
      book = build(:book, price: nil)
      book.validate
      expect(book.errors[:price].first).to eq("can't be blank")
    end
  end
end
