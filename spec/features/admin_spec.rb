require 'rails_helper'

RSpec.describe 'Admin page', admin: true do
  it 'exists' do
    visit '/admin'
    expect(page).to have_content "Admin"
  end

end
