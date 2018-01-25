class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  # Tells rails not to run the require login function when creating a user because the user has not been created yet therefore they can not be logged in yet
  skip_before_action :require_login, only: [:create], raise: false

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit(:name, :email, :password)
    end
end


require 'rails_helper'

RSpec.describe "UserControllers", type: :request do
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
      it "succeeds when there is authentication" do
        expect(response).to be_success
      end
    end
  end

  # Test signing up a user
  describe "POST /user_controllers" do
    context "valid params" do
      before {
        valid_params = {name: "Eliel", email: "eliel@test.com", password: "testpassword"}
        post "/users", params: valid_params
      }

      it "creates and sends success of creating a user with valid params" do
        expect(response).to be_success
      end
    end
    context "invalid params" do
      before {
        invalid_params = {email: "eliel@test.com", password: "testpassword"}
        post "/users", params: invalid_params
      }

      it "should fail and send 400" do
        expect(response).to_not be_success
      end
    end
  end
end
