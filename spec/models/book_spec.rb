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
end