require 'rails_helper'

RSpec.describe AdminController, type: :controller, admin: true do
  describe 'GET index' do
    it 'renders the admin index template' do
      get :index
      expect(response).to render_template 'index'
    end
  end
end
