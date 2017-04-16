# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

create(:video)
create(:video)

neo = create(:user, admin: true)
morpheus = create(:user)
create(:relationship, leader: neo, follower: morpheus)
