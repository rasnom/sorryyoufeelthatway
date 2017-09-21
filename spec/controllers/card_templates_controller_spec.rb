require 'rails_helper'

RSpec.describe CardTemplatesController, type: :controller do

  describe 'GET index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'assigns @templates' do
      some_template = CardTemplate.create(greeting: "hey there", image_file: "this.pic")
      get :index
      expect(assigns(:templates)).to eq [some_template]
    end
  end

end
