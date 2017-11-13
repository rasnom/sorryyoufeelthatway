require 'rails_helper'

RSpec.describe CardsController, type: :controller, cards_controller: true do
  let!(:template) { CardTemplate.create(greeting: "Whoa Nellie", image_file: "wn.png") }
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
    before(:each) do
      post :create,
        params: { card_template_id: template.id, card: card_params }
    end

    describe 'If all the necessary params are included and valid' do
      it 'Creates a new card' do
        expect(Card.last[:custom_message]).to eq card_params[:custom_message]
      end

      it 'Sets session_id on the card' do
        expect(Card.last[:session_id]).to eq session.id
      end
    end

    describe 'If there are problems with the params' do
      describe 'Rerenders the page with the error summary attached' do
        it 'catches missing recipient_name' do
          card_params[:recipient_name] = nil
          post :create, params: { card_template_id: template.id, card: card_params }
          expect(response).to redirect_to :new_card_template_card
          expect(flash[:error]).to be_present
        end

        it 'catches missing street_address' do
          card_params[:street_address] = nil
          post :create, params: { card_template_id: template.id, card: card_params }
          expect(response).to redirect_to :new_card_template_card
          expect(flash[:error]).to be_present
        end

        it 'catches missing city' do
          card_params[:city] = nil
          post :create, params: { card_template_id: template.id, card: card_params }
          expect(response).to redirect_to :new_card_template_card
          expect(flash[:error]).to be_present
        end

        it 'catches missing state' do
          card_params[:state] = nil
          post :create, params: { card_template_id: template.id, card: card_params }
          expect(response).to redirect_to :new_card_template_card
          expect(flash[:error]).to be_present
        end

        it 'catches missing zip_code' do
          card_params[:zip_code] = nil
          post :create, params: { card_template_id: template.id, card: card_params }
          expect(response).to redirect_to :new_card_template_card
          expect(flash[:error]).to be_present
        end
      end
    end
  end

  describe 'GET show' do
    let!(:card) { Card.create(card_params) }

    describe 'If the session_id of the card matches the current session' do
      before(:each) { Card.find(card.id).update(session_id: session.id) }
      before(:each) { get :show, params: { card_template_id: template.id, id: card.id } }

      it 'Renders the show view' do
        expect(response).to render_template 'show'
      end

      it 'Assigns @template' do
        expect(assigns(:template).greeting).to eq 'Whoa Nellie'
      end

      it 'Assigns @card' do
        expect(assigns(:card).custom_message).to eq 'errrr.....'
      end

    end

    describe 'If the session_id does not match the current session' do
      before(:each) { get :show, params: { card_template_id: template.id, id: card.id } }

      it 'Redirects to the new card form for the relevant template' do
        expect(response).to redirect_to new_card_template_card_url(card_template_id: template.id)
      end
    end
  end

  describe 'GET edit' do
    let(:card) { Card.create(card_params) }

    describe 'If the session_id of the card matches the current session' do
      before(:each) { Card.find(card.id).update(session_id: session.id) }
      before(:each) { get :edit, params: { card_template_id: template.id, id: card.id } }

      it 'Renders the edit view' do
        expect(response).to render_template "edit"
      end

      it 'Assigns @template' do
        expect(assigns(:template).greeting).to eq 'Whoa Nellie'
      end

      it 'Assigns @card' do
        expect(assigns(:card).custom_message).to eq 'errrr.....'
      end
    end

    describe 'If the session_id does not match the current session' do
      before(:each) { Card.find(card.id).update(session_id: "some nonsense") }
      before(:each) { get :edit, params: { card_template_id: template.id, id: card.id } }

      it 'Redirects to the new card form for the relevant template' do
        expect(response).to redirect_to new_card_template_card_url(card_template_id: template.id)
      end
    end
  end

  describe 'POST update' do
    let(:card) { Card.create(card_params) }
    let(:new_card_params) {{
           card_template_id: template.id,
           custom_message: 'an unexpected turn',
           signature: '-the bees',
           recipient_name: 'that darn lemur',
           street_address: 'the dark forest',
           city: 'Mopeland',
           state: 'ME',
           zip_code: '02494'
         }}

    describe 'If the session_id of the card matches the current session' do
      before(:each) { Card.find(card.id).update(session_id: session.id) }
      before(:each) { post :update, params: {
        card_template_id: template.id,
        id: card.id,
        card: new_card_params
      } }

      it 'Updates @card' do
        expect(assigns(:card).custom_message).to eq new_card_params[:custom_message]
        expect(assigns(:card).state).to eq new_card_params[:state]
        expect(assigns(:card).zip_code).to eq new_card_params[:zip_code]
      end

    end

    describe 'If the session_id does not match the current session' do
      before(:each) { Card.find(card.id).update(session_id: "some nonsense") }
      before(:each) { post :update, params: {
        card_template_id: template.id,
        id: card.id,
        card: new_card_params
      } }

      it 'Redirects to the new card form for the relevant template' do
        expect(response).to redirect_to new_card_template_card_url(card_template_id: template.id)
      end
    end
  end
end
