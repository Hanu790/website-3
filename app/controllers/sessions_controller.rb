class SessionsController < ApplicationController
	def new
	end

	
	def create	
		user = User.find_by_email(params[:session][:email].downcase)
			# render :json => @user.to_json
			# return
		if user && user.authenticate(params[:session][:password])
			#redirect to profile
			sign_in user
			redirect_to user
		else
			#flash error
			flash[:error]="Invalid Email or Password combination"
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end
