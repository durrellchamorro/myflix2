# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Video.create(title: 'Family Guy', description: 'This is a movie about a family and some guy',
             small_cover_url: '/tmp/family_guy.jpg', large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category_id: 1)
Video.create(title: 'Futurama', description: 'A movie about the future.',
             small_cover_url: '/tmp/futurama.jpg', large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category_id: 2)
Video.create(title: 'Monk', description: 'This is a serious movie about a monk and his liquor.',
             small_cover_url: '/tmp/monk.jpg', large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category_id: 3)
Video.create(title: 'The Lion King', description: 'This is an epic Disney cartoon about the king of the Jungle.',
             small_cover_url: '/tmp/lion_king.jpg', large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category_id: 4)
Video.create(title: 'Edward Scissorhands', description: 'This is an epic drama about a man who has scissors for hands.',
             small_cover_url: '/tmp/edward_scissorhands.jpg', large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category_id: 5)
Video.create(title: 'Lost', description: 'This is a tv series about people who survive a plane crash and are lost on an island.',
             small_cover_url: '/tmp/lost.jpg', large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category_id: 2)
Video.create(title: '24', description: 'Jack Bauer, Director of Field Ops for the Counter-Terrorist Unit of Los Angeles, races against the clock to subvert terrorist plots and save his nation from ultimate disaster.',
             small_cover_url: '/tmp/24_show.jpg', large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category_id: 2)
Video.create(title: 'Lost', description: 'This is a tv series about people who survive a plane crash and are lost on an island.',
             small_cover_url: '/tmp/lost.jpg', large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category_id: 2)
Video.create(title: '24', description: 'Jack Bauer, Director of Field Ops for the Counter-Terrorist Unit of Los Angeles, races against the clock to subvert terrorist plots and save his nation from ultimate disaster.',
             small_cover_url: '/tmp/24_show.jpg', large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category_id: 2)
Video.create(title: 'Lost', description: 'This is a tv series about people who survive a plane crash and are lost on an island.',
             small_cover_url: '/tmp/lost.jpg', large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category_id: 2)
Video.create(title: '24', description: 'Jack Bauer, Director of Field Ops for the Counter-Terrorist Unit of Los Angeles, races against the clock to subvert terrorist plots and save his nation from ultimate disaster.',
             small_cover_url: '/tmp/24_show.jpg', large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category_id: 2)
Video.create(title: 'Lost', description: 'This is a tv series about people who survive a plane crash and are lost on an island.',
             small_cover_url: '/tmp/lost.jpg', large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category_id: 2)
Video.create(title: '24', description: 'Jack Bauer, Director of Field Ops for the Counter-Terrorist Unit of Los Angeles, races against the clock to subvert terrorist plots and save his nation from ultimate disaster.',
             small_cover_url: '/tmp/24_show.jpg', large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category_id: 2)
Category.create([{ name: 'TV Comedies' }, { name: 'TV Dramas' },
                 { name: 'Reality TV' }, { name: 'Cartoon' }, { name: 'Drama' }])

neo = create(:user)
morpheus = create(:user)
relationship = create(:relationship, leader: morpheus, follower: neo)
