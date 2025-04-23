require 'rails_helper'

RSpec.describe SubscriptionLookUp do
  describe '.call' do
    it 'creates an instance and calls it' do
      instance = instance_double(described_class)
      expect(described_class).to receive(:new).with(3).and_return(instance)
      expect(instance).to receive(:call)
      described_class.call(3)
    end
  end

  describe '#call' do
    context 'with user ID 3 (successful case)' do
      let(:service) { described_class.new(3) }

      it 'returns the subscription status' do
        result = service.call
        expect(result).to be_a(String)
        puts "Subscription status for user 3: #{result}"
      end
    end

    context 'with user ID 5 (intermittent failures)' do
      let(:service) { described_class.new(5) }

      it 'handles intermittent failures and eventually succeeds' do
        result = service.call
        expect(result).to be_a(String)
        puts "Subscription status for user 5: #{result}"
      end
    end

    context 'with user ID 101 (not found)' do
      let(:service) { described_class.new(101) }

      it 'raises a SubscriptionError for non-existent user' do
        expect { service.call }.to raise_error(described_class::SubscriptionError)
      end
    end
  end
end 