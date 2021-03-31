# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

(0..20).each do |_i|
  a = rand(1.00..500)
  Transaction.create!(user_id: 1,
                      offer_id: rand(1..4),
                      status: 0,
                      total: a,
                      cashback_sum: rand(1.00..a),
                      action_id: 250)
end
