CardTemplate.delete_all
Card.delete_all
AdminUser.delete_all

if Rails.env.development?
  AdminUser.create(username: "dev", password: "dev")
end

template_list = [
  {
    greeting: "Sorry you feel that way",
    image_file: "sorry_template_0.1.svg"
  },
  {
    greeting: "There's no reason for you to be this upset",
    image_file: "reason_template_0.1.svg"
  }
]

template_list.each do |template|
  CardTemplate.create({
    greeting: template[:greeting],
    image_file: template[:image_file]
  })
end
