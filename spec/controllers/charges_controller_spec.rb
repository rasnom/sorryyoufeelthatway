require 'rails_helper'

RSpec.describe ChargesController, type: :controller do
  let(:template) { CardTemplate.create(greeting: "Whoa Nellie", image_file: "wn.png") }
  let(:card) { Card.create({
       card_template_id: template.id,
       custom_message: 'errrr.....',
       signature: '-neemur neemur',
       recipient_name: 'the bees',
       street_address: 'over yonder',
       city: 'Oakland',
       state: 'CA',
       zip_code: '04294'
     }) }

  describe 'POST create' do
    it 'sets @amount to 499 cents' do
      post :create
      expect(assigns(:amount)).to eq 499
    end

    describe 'if there is a Stripe error' do
      it 'redirects to the show page for the card if possible' do
        post :create, params: { card_id: card.id }
        # expect(response).to redirect_to card_template_card_path(
        #   id: card.id,
        #   card_template_id: card.card_template_id
        # )
      end

      it 'redirects to the home page if no card id was specified' do
        post :create
        expect(response).to redirect_to '/'
      end
    end
  end
end
