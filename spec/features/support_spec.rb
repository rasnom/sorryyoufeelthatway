require 'rails_helper'

RSpec.describe 'Support Processes', support: true do  

	describe 'Support Page' do
		before(:each) { visit '/support' }

		it 'exists' do
			expect(page).to have_content 'Support'
		end
	end
end