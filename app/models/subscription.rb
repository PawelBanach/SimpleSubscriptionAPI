class Subscription < ApplicationRecord
  validates :id, uniqueness: true
end
