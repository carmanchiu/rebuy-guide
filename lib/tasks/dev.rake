desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  p "Creating sample data"

  if Rails.env.development?
    FollowRequest.destroy_all
    Media.destroy_all
    Review.destroy_all
    Product.destroy_all
    User.destroy_all
  end

  usernames = Array.new { Faker::Name.first_name }

  usernames << "alice"
  usernames << "bob"

  usernames.each do |username|
    User.create(
      email: "#{username}@example.com",
      password: "password",
      username: username.downcase,
      first_name: username,
      last_name: "Maowy"
    )
  end

  # Create users
  10.times do
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    u = User.create(
      email: "#{first_name}@example.com",
      password: "password",
      username: "#{first_name}",
      first_name: first_name,
      last_name: last_name,
    )

    p u.first_name
  end

  p "There are now #{User.count} users."

  # Create follow requests
  users = User.all

  users.each do |first_user|
    users.each do |second_user|
      if rand < 0.75
        first_user.sent_follow_requests.create(
          recipient: second_user,
          status: FollowRequest.statuses.values.sample
        )
      end

      if rand < 0.75
        second_user.sent_follow_requests.create(
          recipient: first_user,
          status: FollowRequest.statuses.values.sample
        )
      end
    end
  end
  p "There are now #{FollowRequest.count} follow requests."

  # Create products?
  7.times do
    product = Product.create(
      name: Faker::Commerce.product_name
    )
    p product.name
  end
  p "There are now #{Product.count} products."

  # Create reviews
  users.each do |user|
    rand(10).times do
      # Would be nice to have images in sample reviews
      review = user.own_reviews.create(
        body: Faker::Lorem.paragraph,
        published: [true, false].sample,
        rating: rand(1..10),
        visibility: Review.visibilities.values.sample,
        would_repurchase: Review.would_repurchases.values.sample,
        owner_id: user.id,
        product_id: Product.all.sample.id
      )

      # p review
    end
  end
  p "There are now #{Review.count} reviews."

  # Create media
  reviews = Review.all

  reviews.each do |review|
    rand(5).times do
      media = Media.create(
        file: "https://robohash.org/#{rand(9999)}",
        owner_id: review.owner_id,
        review_id: review.id
      )
      # p media
    end
  end
  p "There are now #{Media.count} medias."
end
