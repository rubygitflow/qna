class Vote < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :votable, polymorphic: true

  scope :positive, -> { where(status: true) }
  scope :negative, -> { where(status: false) }
end
