require 'rails_helper'

RSpec.describe AdminController, type: :controller, admin: true do
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
      it 'renders the admin index template' do
        get :index
        expect(response).to render_template 'index'
      end
    end
  end
end
