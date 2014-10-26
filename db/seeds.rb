# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'faker'

10.times do |i|
  place = Place.create({
    name:         Faker::Address.city,
    description:  Faker::Address.street_address
    })
  ((i+4)/2).times do |j|
    Emergency.create({
      date:       Faker::Time.between(60.day.ago, 5.days.ago, :all),
      status:     Emergency::EMERGENCY_STATUS_OPEN,
      simulacrum: false,
      place_id:   place.id
      })
  end
end

10.times do |i| 
  co = Company.create({
    name:       Faker::Company.name,
    activity:   Company::COMPANY_TYPE_FACTORY,
    phone1:     Faker::PhoneNumber.phone_number,
    email:      Faker::Internet.email
  })
  3.times do |per| 
    Person.create({
      name:         Faker::Name.first_name,
      lastname:     Faker::Name.last_name,
      phone:        Faker::PhoneNumber.phone_number,
      email:        Faker::Internet.email,
      company_id:   co.id
      })
  end
end

10.times do |i| 
  co = Company.create({
    name:       Faker::Company.name,
    activity:   Company::COMPANY_TYPE_PUBLIC,
    phone1:     Faker::PhoneNumber.phone_number,
    email:      Faker::Internet.email
  })
  3.times do |per| 
    Person.create({
      name:         Faker::Name.first_name,
      lastname:     Faker::Name.last_name,
      phone:        Faker::PhoneNumber.phone_number,
      email:        Faker::Internet.email,
      company_id:   co.id
      })
  end
end

10.times do |i| 
  Scenario.create({
    name:         Faker::Lorem.word,
    description:  Faker::Hacker.adjective + " " + Faker::Hacker.adjective + " " + Faker::Hacker.noun
  })
end
