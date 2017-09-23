require 'rails_helper'

describe 'Customizing and ordering a card' do
  let(:template) { CardTemplate.create(greeting: "nevermind", image_file: "123.gif") }

  describe 'Viewing the customization page' do
    it 'has the greeting for the template selected' do
      visit "/card_templates/#{template.id}"
      expect(page).to have_content template.greeting
    end
  end

  describe 'Customizing and ordering a card' do
    it 'Can create a card with all of the relevant fields' do
      visit "/card_templates/#{template.id}"

      fill_in_card_form(
        custom_message: 'Not having the sorry',
        signature: 'Kindly, James',
        recipient_name: 'Bad Friend',
        street_address: '123 Main Street',
        city: 'Oakland',
        state: 'CA',
        zip_code: '94607'
      )
      click_on 'Send Card'

      expect(page).to have_content 'It is done'
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
