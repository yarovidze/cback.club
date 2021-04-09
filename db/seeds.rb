# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
users_ids = User.all.ids
(0..User.count * 20).each do |_i|
  a = rand(1.00..500)
  Transaction.create!(user_id: users_ids.sample,
                      offer_id: rand(1..4),
                      status: rand(1..4),
                      total: a,
                      cashback_sum: rand(1.00..a),
                      action_id: 250)
end
