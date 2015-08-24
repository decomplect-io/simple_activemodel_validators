require 'spec_helper'

describe SimpleActiveModelValidators::AssociatedBubblingValidator do
  before do
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    ActiveRecord::Schema.define(version: 1) do
      create_table :users do |t|
        t.string :name
        t.integer :comment_id
      end
      create_table :comments do |t|
        t.string :body
        t.integer :user_id
      end
    end
  end

  after do
    ActiveRecord::Base.connection.close
  end

  context 'When used with has_many' do
    module HasMany
      class User < ActiveRecord::Base
        validates :name, presence: true
        has_many :comments
        validates :comments, presence: true
        validates_with SimpleActiveModelValidators::AssociatedBubblingValidator, attributes: [:comments]
      end
      class Comment < ActiveRecord::Base
        belongs_to :user
        validates :body, presence: true
      end
    end
    it 'bubbles up associated validation errors' do
      user = HasMany::User.new(name: 'Joe', comments: [HasMany::Comment.new(body: '')])
      expect(user).not_to be_valid
      expect(user.errors.messages).to eq(comments: ["is invalid", { body: ["can't be blank"] }])
    end
  end

  context 'When used with belongs_to' do
    module BelongsTo
      class User < ActiveRecord::Base
        validates :name, presence: true
        has_many :comments
      end

      class Comment < ActiveRecord::Base
        belongs_to :user
        validates :body, presence: true
        validates_with SimpleActiveModelValidators::AssociatedBubblingValidator, attributes: [:user]
      end
    end

    it 'bubbles up associated validation errors' do
      comment = BelongsTo::Comment.new(body: 'hello there!', user: BelongsTo::User.new(name: ''))
      expect(comment).not_to be_valid
      expect(comment.errors.messages).to eq(user: [{ name: ["can't be blank"] }])
    end

    it 'does not fail for null values' do
      comment = BelongsTo::Comment.new(body: 'hello there!', user: nil)
      expect(comment).to be_valid
    end
  end

  context 'When used with has_one' do
    module HasOne
      class User < ActiveRecord::Base
        validates :name, presence: true
        has_many :comments
      end

      class Comment < ActiveRecord::Base
        has_one :user
        validates :body, presence: true
        validates_with SimpleActiveModelValidators::AssociatedBubblingValidator, attributes: [:user]
      end
    end

    it 'bubbles up associated validation errors' do
      comment = HasOne::Comment.new(body: 'hello there!', user: HasOne::User.new(name: ''))
      expect(comment).not_to be_valid
      expect(comment.errors.messages).to eq(user: [{ name: ["can't be blank"] }])
    end

    it 'does not fail for null values' do
      comment = HasOne::Comment.new(body: 'hello there!', user: nil)
      expect(comment).to be_valid
    end
  end
end
