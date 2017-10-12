require 'rails_helper'

RSpec.describe CardsController, type: :controller do
  let(:template) { CardTemplate.create(greeting: "Whoa Nellie", image_file: "wn.png") }
  let(:card_params) {
    {
      card_template_id: template.id,
      custom_message: 'errrr.....',
      signature: '-neemur neemur',
      recipient_name: 'the bees',
      street_address: 'over yonder',
      city: 'Oakland',
      state: 'CA',
      zip_code: '04294'
    }
  }

  describe 'POST create' do
    describe 'If all the necessary params are included and valid' do
      it 'Creates a new card' do
        post :create, params: { card_template_id: template.id, card: card_params }
        expect(Card.last[:custom_message]).to eq card_params[:custom_message]
      end

      it 'Redirects to the show view for the card' do
        post :create, params: { card_template_id: template.id, card: card_params }
        expect(response).to redirect_to card_template_card_url(id: Card.last.id)
      end
    end

    describe 'If there are problems with the params' do
      xit 'Rerenders the page with an error notice' do

      end

      xit 'Autofills the fields with the existing input' do

      end
    end
  end

  describe 'PUT update' do

  end
end
