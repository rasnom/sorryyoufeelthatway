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
     }}

  describe 'POST create' do
    describe 'If all the necessary params are included and valid' do
      it 'Creates a new card' do
        post :create, params: { card_template_id: template.id, card: card_params }
        expect(Card.last[:custom_message]).to eq card_params[:custom_message]
      end
    end

    describe 'If there are problems with the params' do
      it 'Rerenders the page with the error summary attached' do
        card_params[:recipient_name] = nil
        post :create, params: { card_template_id: template.id, card: card_params }
        expect(response).to redirect_to :new_card_template_card
        expect(flash[:error]).to be_present
      end
    end
  end
end
