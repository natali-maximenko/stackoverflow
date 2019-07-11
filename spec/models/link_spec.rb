RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  context 'validate url format' do
    let(:invalid_url) { 'yandex_ru' }
    let(:valid_url) { 'http://yandex.ru' }

    it { should allow_value(valid_url).for(:url) }
    it { should_not allow_value(invalid_url).for(:url) }  
  end
end
