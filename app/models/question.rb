class Question < ApplicationRecord
  belongs_to :user
  # https://guides.rubyonrails.org/association_basics.html
  # https://apidock.com/rails/ActiveRecord/Associations/ClassMethods/has_many
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
