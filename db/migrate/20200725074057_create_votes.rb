class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :status, default: 0
      t.references :user, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps
    end
  end
end
