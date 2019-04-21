module Admin
  class UsersController < AdminController
    before_action :set_user, only: %i[show update destroy]

    def index
      @users = User.with_role(params[:role])
                   .search(params[:value])
                   .paginate(page: params[:page], per_page: User::PER_PAGE)
      authorize([:admin, @users])
      respond_to do |format|
        format.html {}
        format.js { render partial: 'admin/users/users_list', layout: false, locals: { users: @users } }
      end
    end

    def show; end

    def update
      respond_to do |format|
        if @user.update(role: params[:role])
          format.html do
            redirect_to admin_users_path, flash: { success: t('admin.user.flash_messages.update.success') }
          end
          format.json { render json: { status: :updated, user: @user } }
        else
          format.html do
            redirect_to admin_users_path, flash: { danger: t('admin.user.flash_messages.update.danger') }
          end
          format.json { render json: { errors: @user.errors, status: :unprocessable_entity } }
        end
      end
    end

    def destroy
      respond_to do |format|
        if @user.destroy
          format.html do
            redirect_to admin_users_path, flash: { success: t('admin.user.flash_messages.delete.success') }
          end
          format.json { render json: { status: :deleted, user: @user } }
        else
          format.html do
            redirect_to admin_users_path, flash: { danger: t('admin.user.flash_messages.delete.danger') }
          end
          format.json { render json: { errors: @user.errors, status: :unprocessable_entity } }
        end
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
      authorize([:admin, @user])
    end
  end
end
