require 'rails_helper'

describe 'site home' do
  let!(:template) {CardTemplate.create(greeting: "whoops")}

  it 'exists' do
    visit '/'
    expect(page).to have_content "Let them know what you really think"
  end

  xit 'displays the card templates' do
    visit '/'
    expect(page).to have_content "whoops"
  end

end
