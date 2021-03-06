require 'rails_helper'

RSpec.describe SessionsController, type: :controller, session: true do
  let!(:admin_user) { AdminUser.create(username: "Leroy", password: "8i8i8iq") }

  describe 'create' do
    it 'redirects to the page it was called from' do
      request.env["HTTP_REFERER"] = "previous_location"
      post :create
      expect(response).to redirect_to "previous_location"
    end

    it 'does nothing to the session if there is no users' do
      session[:user_id] = "test override"
      post :create
      expect(session[:user_id]).to eq "test override"
    end

    describe 'with a valid user login' do
      before(:each) do
        post :create, params: {
          username: admin_user.username,
          password: admin_user.password
        }
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq AdminUser.find(admin_user.id)
      end

      it 'saves the user id to the session' do
        expect(session[:user_id]).to eq admin_user.id
      end
    end

    describe 'with an invalid login' do
      it 'does not set the user id to the session' do
        post :create, params: {
          username: admin_user.username,
          password: "something random"
        }
        expect(session[:user_id]).to be_nil
      end
    end
  end

  describe 'destroy' do
    it 'sets the user id in the session to nil' do
      session[:user_id] = "something"
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to the page it was called from' do
      request.env["HTTP_REFERER"] = "previous_location"
      delete :destroy
      expect(response).to redirect_to "previous_location"
    end
  end
end
