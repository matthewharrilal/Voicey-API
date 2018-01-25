class User < ApplicationRecord

    # So what this is saying is that a user will have a relationship with the memos and that a user can have
    # many memos and that it must have a name and an email but the name does not have to be unique but the email
    # does meaning if that a user signs up with the same name they will be accepted but not if they have the same
    # email
    has_many :memos
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
end
