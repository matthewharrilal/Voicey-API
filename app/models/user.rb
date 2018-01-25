class User < ApplicationRecord

    # So what this is saying is that a user will have a relationship with the memos and that a user can have
    # many memos and that it must have a name and an email but the name does not have to be unique but the email
    # does meaning if that a user signs up with the same name they will be accepted but not if they have the same
    # email
    has_many :memos
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true


    def self.authenticate(email, password)
        # What this self.authenticate function essentially does for us is that is first finds the user by email to see if the user even exists before authenticating
        user = self.find_by_email(email)

        # Then what happens next is that we essentially hash the passed that the user has passed in and compare it to the hashed version that we have stored in our database and see 
        # if the two hahsed passwords match and if they match successfully then the user has been authenticated properly but if the two do not match then user will be returned nil
        if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)

            # What is salting a password?
            # So in this case what we are doing is that this function takes in two parameters and those two parameters are password and user.password_salt and what that does is salt the 
            # password that has been given and compares it against the salted version of the users stored password and then we hash that password and compare that hashed version to the hashed
            # version that the user has in the database

            # THE FUNCTION IS USED WHEN THE USER IS LOGGING IN WHICH IS SIMILAR TO SEE IF THE USER IS VERIFIED 
          user
        else
          nil
        end
      end
      
      # Essentially what this function does for is is that we are encrypting the users password when the user signs up
      def encrypt_password do
        if password.present?
          self.password_salt = BCrypt::Engine.generate_salt
          self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
        end
      end
      
      # Generates a token for a user
      def generate_token
        token_gen = SecureRandom.hex
        self.token = token_gen
        token_gen
      end
end
