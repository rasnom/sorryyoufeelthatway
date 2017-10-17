require 'rails_helper'

RSpec.describe ChargesController, type: :controller do

  describe 'POST create' do
    it 'sets @amount to 499 cents' do
      post :create
      expect(assigns(:amount)).to eq 499
    end
  end

end
