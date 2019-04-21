shared_examples 'no access to admin panel' do
  context 'when user is not admin' do
    login_user

    it 'redirect to main page' do
      expect(http_request).to redirect_to(root_path)
    end
  end

  context 'when user is not authorized' do
    it 'redirect to main page' do
      expect(http_request).to redirect_to(new_user_session_path)
    end
  end
end
