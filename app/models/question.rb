class Question < ApplicationRecord
  include Authorable
  include Votable
  include Commentable
  
  # https://guides.rubyonrails.org/association_basics.html
  # https://apidock.com/rails/ActiveRecord/Associations/ClassMethods/has_many
  has_many :answers, -> { order('best DESC, created_at') }, dependent: :destroy
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

end
