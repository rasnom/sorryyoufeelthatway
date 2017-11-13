require 'rails_helper'

RSpec.describe 'Admin page', admin: true do
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
    visit '/admin'
  end

  it 'exists' do
    expect(page).to have_content "Admin"
  end

  it 'does not show any card data initially' do
    #  add counterexamples as elements are added to the view
    expect(page).to_not have_css "ul.ordered_cards"
  end

  describe 'if an admin logs in' do
    let(:test_password) { "eieio" }
    let!(:admin_user) { AdminUser.create(username: "test_admin", password: test_password) }
    before(:each) do
      fill_in 'username', with: admin_user.username
      fill_in 'password', with: test_password
      click_button 'Submit'
    end

    it 'displays a list of ordered cards' do
      expect(page).to have_css "ul.ordered_cards"
      expect(page).to have_content "Card Number 3"
      expect(page).to have_content Card.last.id
      expect(page).to have_content template.greeting
    end
  end

end
