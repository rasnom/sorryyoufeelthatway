require 'rails_helper'

RSpec.describe AdminController, type: :controller, admin: true do
  let!(:template) { CardTemplate.create(greeting: "Something Snarky", image_file: "wn.png") }
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
  } }
  before(:each) do
    for count in (1..5) do
      card_params[:custom_message] = "Card Number #{count}"
      Card.create(card_params)
    end
  end

  describe 'Logged Out' do
    it 'renders the admin login unless already logged in' do
      get :index
      expect(response).to render_template 'login'
    end
  end

  describe 'Logged In' do
    let!(:admin_user) { AdminUser.create(username: "Leroy", password: "8i8i8iq") }
    before(:each) { session[:user_id] = admin_user.id }

    describe 'GET index' do
      before(:each) { get :index }

      it 'renders the admin index template' do
        expect(response).to render_template 'index'
      end

      it 'assigns @cards' do
        expect(assigns(:cards).count).to eq 5
      end
    end
  end
end
