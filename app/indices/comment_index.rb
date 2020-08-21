ThinkingSphinx::Index.define :comment, with: :active_record do
  # fields
  indexes body
  indexes user.email, sortable: true


  # attributes
  has commentable_id, commentable_type, user_id, created_at, updated_at
end
