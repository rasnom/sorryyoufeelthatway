require 'rails_helper'
require 'stripe'

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
  let(:token) { get_test_stripe_token }
  let(:customer_email) { "anybody@indeterminate.net" }

  describe 'Stripe API test token' do
    it 'should be a valid test token' do
      expect(token[:object]).to eq "token"
      expect(token[:type]).to eq "card"
      expect(token[:livemode]).to eq false
    end
  end

  describe 'POST create' do
    it 'sets @amount to 499 cents' do
      post :create, params: { card_id: card.id }
      expect(assigns(:amount)).to eq 499
    end

    describe 'if there is a Stripe error' do
      it 'redirects to the show page for the card if possible' do
        post :create, params: { card_id: card.id }
        expect(response).to redirect_to card_template_card_path(
          id: card.id,
          card_template_id: card.card_template_id
        )
      end

      it 'redirects to the home page if no card exists' do
        post :create, params: { card_id: -1 }
        expect(response).to redirect_to '/'
      end
    end

    describe 'if the Stripe transaction is successful' do
      let(:valid_post) { post :create, params: {
        card_id: card.id,
        stripeEmail: customer_email,
        stripeToken: token.id
      } }

      it 'renders the success page' do
        valid_post
        expect(response).to render_template 'create'
      end

      xit 'creates a new charge' do
        expect(valid_post).to change
      end
    end
  end
end

def get_test_stripe_token
  Stripe.api_key = ENV['STRIPE_TEST_PUBLISHABLE_KEY']

  token = Stripe::Token.create(
    :card => {
      :number => "4242424242424242",
      :exp_month => 10,
      :exp_year => 2018,
      :cvc => "314"
    },
  )
end
