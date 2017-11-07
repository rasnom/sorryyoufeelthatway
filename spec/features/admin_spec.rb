require 'rails_helper'

RSpec.describe 'Admin page', admin: true do
  before(:each) { visit '/admin' }

  it 'exists' do
    expect(page).to have_content "Admin"
  end

  xit 'does not show any card data initially' do
    #  add counterexamples as things are added
    expect(page).to_not have_css "ul.ordered_cards"
  end

  describe 'if an admin logs in' do
    let(:test_password) { "eieio" }
    let!(:admin_user) { Admin.create(username: "test_admin", password: "test_password") }
    before(:each) do
      fill_in 'username', with: admin_user.username
      fill_in 'password', with: test_password
      click_button 'Login'
    end

    it 'displays a list of ordered cards' do
      expect(page).to have_css "ul.ordered_cards"
    end
  end

end
