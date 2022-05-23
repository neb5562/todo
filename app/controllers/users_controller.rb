class UsersController < ApplicationController

  get '/profile' do
    erb :'users/index'
  end

  get '/profile/deactivate' do
    erb :'users/deactivate'
  end

  put '/profile/change_password' do
    result = ChangeUserValidateService.new(params, current_user).call

    unless result.empty? 
      flash[:error_messages] = result
    else
      flash[:success_message] = 'Password Changed Successfully'
      password_change = ChangeUserService.new(params, current_user).call
    end

    redirect('/profile')
  end

  delete '/profile/deactivate' do
    result = DeactivateUserValidateService.new(params, current_user).call
    unless result.empty? 
      flash[:error_messages] = result
    else
      flash[:success_message] = 'Your Account Deactivated'
      deactivate = DeactivateUserService.new(params, current_user).call
      session.clear
      session['user_id'] = nil
    end
    redirect('/profile/deactivate')

  end

end
