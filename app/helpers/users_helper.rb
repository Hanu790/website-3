module UsersHelper

#DEFINE other method
   private
    def user_params
      params.require(:user).permit(:name,:email,:avarta,
      								:password,:password_confirmation,:old_password)
    end
end
