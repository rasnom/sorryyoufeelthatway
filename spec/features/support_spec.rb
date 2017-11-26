require 'rails_helper'

RSpec.describe 'Support Processes', support: true do 
  	let!(:sorry_template) do
      CardTemplate.create(
        greeting: "Sorry you feel that way",
        image_file: "sorry_template_0.1.svg"
      ) 
  	end

	describe 'Support Page' do
		before(:each) { visit '/support' }

		it 'exists' do
			expect(page).to have_content('Contact Support')
		end

		it 'prefills the address for the support team' do
			expect(find_field('Recipient Name').value).to eq 'SorryYouFeelThatWay Support Team'
		end
	end

	describe 'Support Button' do
		before(:each) { visit '/' }

		it 'exists on the home page' do
			expect(page).to have_css('a.btn.support')
		end

		it 'links to the support page' do
			click_link('Support')
			expect(page).to have_content('Contact Support')
		end
	end
end