require 'rails_helper'

describe 'Customizing a card' do
  let!(:template) { CardTemplate.create(greeting: "nevermind", image_file: "sorry_template_0.1.svg") }
  let!(:card_data) {{
    custom_message: 'Not having the sorry',
    signature: 'Kindly, James',
    recipient_name: 'Bad Friend',
    street_address: '123 Main Street',
    city: 'Oakland',
    state: 'CA',
    zip_code: '94607'
  }}
  before(:each) do
    visit "/card_templates/#{template.id}/cards/new"
    fill_in_card_form(card_data)
  end

  describe 'Viewing the customization page' do
    it 'has the greeting for the selected template' do
      expect(page.find("#template-#{template[:id]}-image")).to_not be_nil
    end
  end

  describe 'Filling out the card form' do
    it 'Can create a card with all of the relevant fields' do
      card_count = Card.all.count
      click_button('Submit')
      expect(Card.all.count).to eq(card_count + 1)
    end
  end

  describe 'Paying for a card' do
    before(:each) { click_button('Submit') }

    describe 'Viewing the payment page' do
      describe 'After a valid card has been created' do
        it 'Shows the payment label' do
          expect(page).to have_content "Review Order"
        end

        it 'Still shows the greeting for the template selected' do
          expect(page.find("#template-#{template[:id]}-image")).to_not be_nil
        end

        it 'Still shows the custom details of the customized card' do
          expect(page).to have_content Card.last.signature
        end

        it 'Lists total price' do
          expect(page).to have_content 'Total: $4.99'
        end

        it 'Includes the Stripe checkout button', js: true do
          expect(page).to have_css '.stripe-button-el'
            expect(page.find_button('Pay with Card')).to_not be_nil
        end
      end

      describe 'If the card does not match the current session' do
        let(:sessionless_card){ Card.create({
          card_template_id: template.id,
          custom_message: 'Nonsense session_id',
          signature: 'Cause I made it manually',
          recipient_name: 'Bad Friend',
          street_address: '123 Main Street',
          city: 'Oakland',
          state: 'CA',
          zip_code: '94607',
          session_id: 'humbaba'
        }) }

        it 'Does not show the card details and payment section' do
          visit card_template_card_path(card_template_id: sessionless_card.card_template_id, id: sessionless_card.id)
          expect(page).to_not have_content "Review Order"
        end

        it 'Redirects to the new card page for the relevant template' do
          visit card_template_card_path(card_template_id: sessionless_card.card_template_id, id: sessionless_card.id)
          expect(page).to have_content "Customize Your Message"
          expect(page.find("#template-#{template[:id]}-image")).to_not be_nil
        end
      end

      describe 'If the user clicks the "Edit" button' do
        before(:each) { click_link('Edit') }

        it 'Takes the user to the edit page for the card' do
          expect(page).to have_content "Edit Your Message"
          expect(page.find("#template-#{template[:id]}-image")).to_not be_nil
        end

        it 'Pre-fills the form fields' do
          expect(find_field('Recipient Name').value).to eq card_data[:recipient_name]
          expect(find_field('City').value).to eq card_data[:city]
          expect(find_field('Custom Message').value).to eq card_data[:custom_message]
        end
      end

      describe 'Stripe checkout modal', js: true do
        before(:each) { click_button('Pay with Card') }
        it 'displays the product summary' do    # add test for showing the flash error if there is a problem with payment

          within_frame('stripe_checkout_app') do
            expect(page).to have_content "Handwritten card delivered by post"
          end
        end

        it 'accepts a test payment' do
          within_frame('stripe_checkout_app') do
            p page.body
            fill_in 'Email', with: 'anything@what.ever'
            fill_in 'Card number', with: '4242424242424242'
            fill_in 'Expiry', with: '04 / 33'
            fill_in 'CVC', with: '123'
            click_button 'Pay $4.99'
          end
          # expect what?
        end
      end
    end

    # add tests for showing the flash error if there is a problem with payment

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
