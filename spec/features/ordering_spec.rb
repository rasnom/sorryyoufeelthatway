require 'rails_helper'

describe 'Customizing a card' do
  let!(:template) { CardTemplate.create(greeting: "nevermind", image_file: "123.gif") }
  before(:each) { visit "/card_templates/#{template.id}/cards/new" }
  before(:each) do
    fill_in_card_form(
      custom_message: 'Not having the sorry',
      signature: 'Kindly, James',
      recipient_name: 'Bad Friend',
      street_address: '123 Main Street',
      city: 'Oakland',
      state: 'CA',
      zip_code: '94607'
    )
  end

  describe 'Viewing the customization page' do
    it 'has the greeting for the template selected' do
      expect(page.find("#template-#{template[:id]}-image")).to_not be_nil
    end
  end

  describe 'Filling out the card form' do
    it 'Can create a card with all of the relevant fields' do
      card_count = Card.all.count
      click_button('Submit')
      expect(Card.all.count).to eq(card_count + 1)
    end

    xit 'Does not accept form submission without any of the required fields' do
      # It looks like there is no great way to directly check html5 form
      # behavior with rspec and capybara. There are tests for preventing a
      # new card without required fields from being saved, so I think we can
      # set this aside to possibly revisit later.
    end
  end

  describe 'Paying for a card' do
    before(:each) { click_button('Submit') }

    it 'Shows the payment section once a valid card has been created' do
      expect(page).to have_content "payment"
    end

    xit 'Does not show the payment section until a valid card has been created' do

    end

    context 'A valid card has been created' do
      xit 'lists the total price' do
        expect(page).to have_content 'Total: $4.99'
      end
    end
  end

  def fill_in_card_form(custom_message:, signature:, recipient_name:, street_address:, city:, state:, zip_code:)
    fill_in 'Custom Message', with: custom_message
    fill_in 'Signature', with: signature
    fill_in 'Recipient Name', with: recipient_name
    fill_in 'Address', with: street_address
    fill_in 'City', with: city
    fill_in 'State', with: state
    fill_in 'Zip Code', with: zip_code
  end

end
