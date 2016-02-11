class Api::ContactsController < ApplicationController

def create
  @user = User.find params[:user_id]
  respond_to do |format|
    if  @user.email_varify
      @contact = @user.contacts.create!(contact_params)
        if @contact
          SendEmail.sign_up_email(@user.contacts.first, "You have been invited by the #{@user.name}").deliver!
          format.json { render json: @user.contacts.first, status: :added}
        else
          format.json { render json: @user.contacts.first.errors, status: :not_added}
        end
        else
          format.json { render json: {:status=> "Please login first"}, status: :not_added}
        end
    end
end

private
def contact_params
  params.require(:contact).permit(:email)
end
end

