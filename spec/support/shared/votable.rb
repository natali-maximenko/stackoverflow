RSpec.shared_examples_for 'votable' do
  let(:resource) { create(described_class.name.underscore) }

  describe '#rating' do
    it 'sum votes' do
      expect(resource.rating).to eq(resource.votes.sum(:value))
    end
  end 

  describe '#like' do
    before { resource.like }

    it 'create like vote' do
      change { resource.votes.count }.from(0).to(1)
    end

    it 'vote belong to user and is positive' do
      expect(resource.votes.first).to have_attributes(votable: resource, value: 1)  
    end

    context 'change vote' do
      it 'from positive to negative' do
        expect(resource.votes.count).to eq(1)
        resource.dislike
        expect(resource.votes.count).to eq(1)
        expect(resource.votes.first).to have_attributes(votable: resource, value: -1)  
      end
    end
  end

  describe '#dislike' do
    before { resource.dislike }

    it 'create like vote' do
      change { resource.votes.count }.from(0).to(1)
    end

    it 'vote belong to user and is positive' do
      expect(resource.votes.first).to have_attributes(votable: resource, value: -1)  
    end
   
    it 'change vote from positive to negative' do
      expect(resource.votes.count).to eq(1)
      resource.like
      expect(resource.votes.count).to eq(1)
      expect(resource.votes.first).to have_attributes(votable: resource, value: 1)  
    end
  end
end
