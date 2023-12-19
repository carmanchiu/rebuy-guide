# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord
  # TODO: need to add `dependent: :destroy` so we don't orphan reviews when deleting a product
  has_many :reviews
  has_many :reviewers, through: :reviews, source: :owner
  has_many :media, through: :reviews, source: :media

  include Ransackable
end
