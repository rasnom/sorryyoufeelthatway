template_list = [
  "sorry you feel that way",
  "there's no reason for you to be this upset"
]

template_list.each do |greeting|
  CardTemplate.create(greeting: greeting)
end
