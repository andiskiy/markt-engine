module Admin
  class UsersController < AdminController
    before_action :set_user, only: %i[show update destroy]

    def index
      @users = User.with_role(params[:role]).paginate(page: params[:page], per_page: User::PER_PAGE)
    end

    def show; end

    def update
      @user.update(role: params[:role])
      # ...
    end

    def destroy
      respond_to do |format|
        if @user.destroy
          format.html do
            redirect_to admin_users_path, flash: { success: t('admin.user.flash_messages.delete.success') }
          end
          format.json { render json: { status: :destroyed, users: User.all } }
        else
          format.html do
            redirect_to admin_users_path, flash: { danger: t('admin.user.flash_messages.delete.danger') }
          end
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end
  end
end
