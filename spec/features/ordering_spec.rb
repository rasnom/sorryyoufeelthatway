require 'rails_helper'

describe 'Customizing and ordering a card' do
  let(:template) { CardTemplate.create(greeting: "nevermind", image_file: "123.gif") }

  describe 'Viewing the customization page' do
    it 'has the greeting for the template selected' do
      visit "/card_templates/#{template.id}"
      expect(page).to have_content template.greeting
    end
  end

end
