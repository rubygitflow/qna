class Question < ApplicationRecord
  belongs_to :user
  # https://guides.rubyonrails.org/association_basics.html
  # https://apidock.com/rails/ActiveRecord/Associations/ClassMethods/has_many
  has_many :answers, -> { order('best DESC, created_at') }, dependent: :destroy

  has_many_attached :files

  validates :title, :body, presence: true
end
