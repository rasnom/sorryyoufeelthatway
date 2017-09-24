require 'rails_helper'

describe 'site home' do
  let!(:template) {CardTemplate.create(greeting: "whoops", image_file: "meep.mp")}

  it 'exists' do
    visit '/'
    expect(page).to have_content "Let them know what you really think"
  end

  describe 'card templates' do

    it 'are displayed' do
      visit '/'
      image = page.find("#template-#{template[:id]}-image")
      expect(image).to have_xpath("//img[contains(@src, /assets/#{template.image_file})]")
    end

    it 'link to card creation pages' do
      visit '/'
      find("#template-#{template[:id]}-create").click
      expect(page).to have_content "Customize your message"
    end
  end
end
