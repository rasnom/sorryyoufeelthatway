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
    it 'can create a new card with all the required fields' do
      card = Card.new(valid_inputs)
      expect(card.save).to be true
    end
  end

end
