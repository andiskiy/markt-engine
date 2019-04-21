module ControllerMacros
  def login_super_user
    before do
      @request.env['devise.mapping'] = Devise.mappings[:super_user]
      sign_in FactoryBot.create(:super_user)
    end
  end

  def login_admin
    before do
      @request.env['devise.mapping'] = Devise.mappings[:admin]
      sign_in FactoryBot.create(:admin)
    end
  end

  def login_user
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in FactoryBot.create(:user)
    end
  end
end
