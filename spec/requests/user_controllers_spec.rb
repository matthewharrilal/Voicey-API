require 'rails_helper'

RSpec.describe "UserControllers", type: :request do

  # TEST FOR LOGGING A USER IN
  describe "GET /user_controllers" do

    # What this is essentially doing is that is saying before we log in the user that the state of the application should be unauthorized therefore the user should not be
    # granted access 
    context "unauthorized" do
      before {
        get "/users"
      }

      # And what this chunk of code does for us is that it essentially tells us that there is suppose to be a response when the user try to be authenticated without logging in
      # then the response is expected to not send back a successful response 
      it "fails when there is no authentication" do
        expect(response).to_not be_success
      end
    end

    # So this chunk of code is the authorized block is that before we are authorized that the input is the credentials that are shown below and then we save the user
    # Once we save the user what we have to do is essentially compose a token for the request and as we know what this token does for us essentially is that it is used for
    # further authentication later on as the user progresses through the application so that they dont have to keep logging in similar to how we set up in our original request
    # what was happening was that we were having to pass the credentials everywhere which is essentially logging in everywhere with token based authentication we can just pass
    # the token around 
    context "authorized" do
      before {
        user = User.new(
          name: "Eliel",
          email: "eliel@test.com",
          password: "test"
        )

        user.save

        # Compose token for request
        full_token = "Token token=#{user.token}"

        # Therefore as the headers we pass the token around as opposed to essentially logging in everywhere 
        get "/users", headers: { 'Authorization' => full_token }
      }

      # And when there is authentication then what we have to do is we get a successful response back meaning that the user has been logged in successfully
      it "succeeds when there is authentication" do
        expect(response).to be_success
      end
    end
  end

  # Test signing up a user
  describe "POST /user_controllers" do

    # So these are the tests for signing a user up
    context "valid params" do
      before {
        # So before we sign  a user in this is the input that the user is going to be the credentials that are assigned below
        valid_params = {name: "Eliel", email: "eliel@test.com", password: "testpassword"}
        post "/users", params: valid_params
      }

      # If the credentials are accepted then what we are essentially doing is that we are going to send back a succesfull response 
      it "creates and sends success of creating a user with valid params" do
        expect(response).to be_success
      end
    end

    # Now that we have moved in from the creation of the succesful users we are switching contexts to the effect that if the user is passing in invalid parameters 
    context "invalid params" do

      # This is before the user tries to sign in and if the user tries to sign in using the invalid parameters which in this example below what is happening is that the user
      # is trying to pass in the parameters email and password which are invalid then we are going to send back a unsuccesful response  which is going to say invalid parameters
      before {
        invalid_params = {email: "eliel@test.com", password: "testpassword"}
        post "/users", params: invalid_params
      }

      # And the response would be unsucessful and send back a 400
      it "should fail and send 400" do
        expect(response).to_not be_success
      end
    end
  end
end
