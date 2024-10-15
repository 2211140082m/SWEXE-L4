class TopController < ApplicationController
    def main
        if session[:login_uid]
            render 'main'
        else
            render 'login'
        end
    end
    
    def login
        @uid = params[:uid]
        @pass = params[:pass]
        user = User.find_by(uid: @uid)
        if user
            if BCrypt::Password.new(user.pass) == @pass
                session[:login_uid] = @uid
                redirect_to '/'
            else
                render 'error', status: 422
            end
        else
            render 'error', status: 422
        end
    end
    
    def new
      @user = User.new  #formヘルパーのデータの入れ物になる
    end
    def create
        pass = BCrypt::Password.create(params[:user][:pass])
        @user = User.new(uid: params[:user][:uid], pass: pass)
        @user.save
        redirect_to '/'
    end
    def logout
        session.delete(:login_uid)
        redirect_to '/'
    end
end