# == Schema Information
#
# Table name: reviews
#
#  id               :bigint           not null, primary key
#  body             :string
#  image            :string
#  published        :boolean
#  rating           :integer
#  visibility       :string
#  would_repurchase :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  owner_id         :bigint           not null
#  product_id       :bigint
#
# Indexes
#
#  index_reviews_on_owner_id    (owner_id)
#  index_reviews_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (product_id => products.id)
#
class Review < ApplicationRecord
  mount_uploader :image, ImageUploader
  attr_accessor :product_name

  belongs_to :owner, class_name: "User"
  belongs_to :product
  has_many :media, class_name: "Media", dependent: :destroy

  # Validations
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :owner_id, uniqueness: { scope: :product_id, message: "has already reviewed this product" }
  validates :would_repurchase, presence: true

  # Enumerating list of values to be stored in columns
  enum visibility: { only_me: "Only me", followers_only: "Followers", everyone: "Everyone" }
  enum would_repurchase: { yes: "Yes", maybe: "Maybe", no: "No" }

  include Ransackable
end
