require 'rails_helper'

RSpec.describe Card, type: :model do
  let(:template) { CardTemplate.create(greeting: 'oh noes', image_file: 'oh.noes') }
  let(:valid_inputs) {{
    card_template_id: template.id,
    custom_message: 'Not having the sorry',
    signature: 'Kindly, James',
    recipient_name: 'Bad Friend',
    street_address: '123 Main Street',
    city: 'Oakland',
    state: 'CA',
    zip_code: '04294'
  }}

  describe 'Creating a new card' do
    let(:inputs) { valid_inputs }

    it 'can create a new card with all the required fields' do
      card = Card.new(valid_inputs)
      expect(card.save).to be true
    end

    it 'will not create a card without a card_template_id' do
      inputs[:card_template_id] = nil
      card = Card.new(inputs)
      expect(card.save).to be false
    end

    it 'will not create a card without a recipient' do
      inputs[:recipient_name] = nil
      card = Card.new(inputs)
      expect(card.save).to be false
    end

    it 'will not create a card without an address' do
      inputs[:street_address] = nil
      card = Card.new(inputs)
      expect(card.save).to be false
    end

    it 'will not create a card without a city' do
      inputs[:city] = nil
      card = Card.new(inputs)
      expect(card.save).to be false
    end

    it 'will not create a card without a state' do
      inputs[:state] = nil
      card = Card.new(inputs)
      expect(card.save).to be false
    end

    it 'will not create a card without a zip code' do
      inputs[:zip_code] = nil
      card = Card.new(inputs)
      expect(card.save).to be false
    end

    it 'will create a card without a custom message or signature' do
      inputs[:custom_message] = nil
      inputs[:signature] = nil
      card = Card.new(inputs)
      expect(card.save).to be true
    end
  end

end
