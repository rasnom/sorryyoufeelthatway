require 'rails_helper'

describe 'site home' do

  it 'exists' do
    visit '/'
    expect(page).to have_content "Sorry you feel that way"
  end

end
