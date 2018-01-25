require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    it "is valid with valid attributes" do
      user = User.new(name: "Eliel", email: "eliel@test.com")
      expect(user).to be_valid
    end

    it "is invalid without a name" do
      bad_user = User.new(name: nil, email: "test@mail.com")
      expect(bad_user).to_not be_valid
    end

    it "is invalid without an email" do
      bad_user = User.new(name: "Eliel", email: nil)
      expect(bad_user).to_not be_valid
    end
  end

  describe "Associations" do
    it "should have many memos" do
      assoc = User.reflect_on_association(:memos)
      expect(assoc.macro).to eq :has_many
    end
  end
end

# Memo Tests
RSpec.describe Memo, type: :model do

  # Before we can test the memos we have to have a user first 
  subject {
    User.new(name: "Eliel", email: "eliel@test.com")
  }

  # Tests if the memo we are trying to create has the correct attributes 
  describe "Validations" do
    it "is valid with valid attributes" do
      memo = Memo.new(
        title: "My Memo",
        date: DateTime.now.utc,
        text_body: "This is the text body",
        user: subject
      )
      # And since to our knowledge we passed in the correct attributes we expect it to be returned succesfull or expected to be returned valid
      expect(memo).to be_valid
    end

    # However if we try to save the memo without a title or a required property we expect it to be invalid therefore we expect it to be invalid
    it "is invalid without a title" do
      bad_memo = Memo.new(
        title: nil,
        date: DateTime.now.utc,
        text_body: "This is the text body",
        user: subject
      )
      expect(bad_memo).to_not be_valid
    end

    # The same theory applies if we are trying to save the memo with another key attribute that is missing and this test accounts for if the key attribute we are trying to save is the time
    it "is invalid without an time" do
      bad_memo = Memo.new(
        title: "My Memo",
        date: nil,
        text_body: "This is the text body",
        user: subject
      )
      expect(bad_memo).to_not be_valid
    end
    it "is invalid without an text body" do
      bad_memo = Memo.new(
        title: "My Memo",
        date: DateTime.now.utc,
        text_body: nil,
        user: subject
      )
      expect(bad_memo).to_not be_valid
    end

    # So what is essentially happening now is we are testing that if the memo does not have a user assigned to it this can be thought of as that we can not have a memo that does not have
    # a user therefore if there is not a user assigned with the memo that we expect the memo that the user is trying to save as invalid
    it "is invalid without a user" do
      bad_memo = Memo.new(
        title: "My Memo",
        date: DateTime.now.utc,
        text_body: nil,
        user: nil
      )
      expect(bad_memo).to_not be_valid
    end
  end
  describe "Associations" do
    it "should have many memos" do
      assoc = Memo.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
