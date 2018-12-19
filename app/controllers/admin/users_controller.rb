module Admin
  class UsersController < AdminController
    def index
      @users = User.all
    end

    def destroy
      User.delete(params[:id])
      redirect_to(admin_users_path)
    end
  end
end
