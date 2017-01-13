# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# create organization
organization = Organization.create!(name: "Srijan", website: "http://srijan.net")
# create Project
project = Project.create!(organization: organization, name: "HCAH")
# create sprint
sprint = Sprint.create!(project: project, name: "Sprint 1")
# create story
stories = [
  Story.create!(sprint: sprint, story_no: "HCAH-001", title: "Bootstrap ember", description: "We have to bootstrap the emberjs application"),
  Story.create!(sprint: sprint, story_no: "HCAH-002", title: "Design planning poker board for UI", description: "Create a UI for planning poker board")
]
# create channel
channel = Channel.create!(name: Time.now.to_f.to_s, sprint: sprint)
# create users
[["Admin", "admin"], ["Naveen", "organizer"], ["Ashok", "participant"], ["Biswajeet", "participant"]].each do |name_role|
  User.create!(name: name_role[0], email: "#{name_role[0]}@srijan.net", role: name_role[1], organization: organization)
end

