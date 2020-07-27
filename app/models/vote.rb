class Vote < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :votable, polymorphic: true

  scope :positive, -> { where('status > 0') }
  scope :negative, -> { where('status < 0') }
end
