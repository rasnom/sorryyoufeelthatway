require 'rails_helper'
require 'stripe'

RSpec.describe ChargesController, type: :controller, controller: true do
  let(:template) { CardTemplate.create(greeting: "Whoa Nellie", image_file: "wn.png") }
  let(:card) do
    Card.create({
       card_template_id: template.id,
       custom_message: 'errrr.....',
       signature: '-neemur neemur',
       recipient_name: 'the bees',
       street_address: 'over yonder',
       city: 'Oakland',
       state: 'CA',
       zip_code: '04294'
     })
  end
  let(:token) do
    Stripe.api_key = ENV['STRIPE_TEST_PUBLISHABLE_KEY']
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 10,
        :exp_year => 2018,
        :cvc => "314"
      },
    )
  end
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
      before(:each) { valid_post }

      it 'renders the success page' do
        expect(response).to render_template 'create'
      end

      it 'creates a new charge' do
        expect(assigns(:charge)["status"]).to eq "succeeded"
        expect(assigns(:charge)["livemode"]).to be false
      end

      it 'includes relevant data and metadata in the charge' do
        expect(assigns(:charge)["amount"]).to eq assigns(:amount)
        expect(assigns(:charge)["currency"]).to eq "usd"
        expect(assigns(:charge)["description"]).to eq "Handwritten greeting card"
        expect(assigns(:charge)["outcome"]["network_status"]).to eq "approved_by_network"
        expect(assigns(:charge)["receipt_email"]).to eq customer_email
        # expect(assigns(:charge)["shipping"]["address"]["line1"]).to eq card.street_address
        # expect(assigns(:charge)["shipping"]["address"]["city"]).to eq card.city
        # expect(assigns(:charge)["shipping"]["address"]["postal_code"]).to eq card.zip_code
        # expect(assigns(:charge)["shipping"]["address"]["state"]).to eq card.state
        # expect(assigns(:charge)["shipping"]["name"]).to eq card.recipient_name
      end
    end
  end
end
