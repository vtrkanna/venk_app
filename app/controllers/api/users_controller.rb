class Api::UsersController < ApplicationController
  def new
    @user = User.new
  end
  def create
    byebug
    @user= User.new(user_params)
      respond_to do |format|
        if @user.save
          format.html do
             contact =  Contact.find_by_email @user.email
             if contact
               @user.contacts.create!({:email=> (User.find contact.user_id).email})
             end
             render json: {:success => "Successfully registered"}
          end
          format.json do
           SendEmail.welcome_email(@user, "Verify your email").deliver!
           render json: @user, status: :created
           end
        else
          byebug
          format.json { render json: @user.errors.messages, status: :not_created}
          format.html { render json: {:success => "Some thing went wrong"} }
        end
      end
  end
  def login
    @user = User.authenticate(params[:user][:email], params[:user][:password])
    respond_to do |format|
      if @user
        session[:user_token] = get_token[:token]
        format.json { render json: get_token, status: :logged_in}
      else
        format.json { render json: @user.errors, status: :not_logg_in}
      end
    end
  end
  def varify_email
    @user = User.find_by_email params[:email]
    respond_to do |format|
    if @user
        @user.update_attributes(:email_varify => true)
        format.html { render json: {:success => "Successfully registered"} }
        format.json { render json: {:success => "Successfully registered"}, status: :success}
      else
        format.json { render json: @user.errors, status: :failure!}
    end
    end
  end

  private

  def get_token
    token = User.genereate_token(@user.email)
    user_params.merge!(:token => token, :name => @user.name)
    user_params.permit(:name, :token)
  end

  def user_params
    params.require(:user).permit!
  end
end
