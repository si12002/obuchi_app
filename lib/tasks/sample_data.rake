namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    wAry = %w[晴れ 曇り 雨 雪]

    User.create!(name: "Example User", email: "example@railstutorial.jp", password: "foobar", password_confirmation: "foobar", admin: true)
    
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.jp"
      password  = "password"
      User.create!(name: name, email: email, password: password, password_confirmation: password)
    end
    
    users = User.all(limit: 6)
    
    50.times do
      content = Faker::Lorem.sentence(5)
       lat = Random.rand(-180.0..180.0)
       lng = Random.rand(-180.0..180.0)
       date = Faker::Date.forward(30)
       weather = wAry[Random.rand(wAry.count)]
      users.each { |user| user.documents.create!(content: content, lat: lat, lng: lng, date: date, weather: weather) }
    end
  end
end
