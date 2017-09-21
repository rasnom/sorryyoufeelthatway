require 'rails_helper'

describe 'site home' do
  let!(:template) {CardTemplate.create(greeting: "whoops", image_file: "meep.mp")}

  it 'exists' do
    visit '/'
    expect(page).to have_content "Let them know what you really think"
  end

  it 'displays the card templates' do
    visit '/'
    image = page.find("#" + template[:greeting] + "-template")
    expect(image).to have_xpath("//img[contains(@src, #{template.image_file})]")
  end

end
