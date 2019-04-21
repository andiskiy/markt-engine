shared_examples 'admin or higher user(with access)' do
  %w[admin super_user].each do |role|
    context "when user is #{role.upcase}" do
      let(:user) { create role }

      it { is_expected.to permit(user, record) }
    end
  end
end

shared_examples 'admin or higher user(without access)' do
  %w[admin super_user].each do |role|
    context "when user is #{role.upcase}" do
      let(:user) { create role }

      it { is_expected.not_to permit(user, record) }
    end
  end
end

shared_examples 'standard user' do
  context 'when user is STANDARD' do
    let(:user) { create :standard }

    it { is_expected.not_to permit(user, record) }
  end
end
