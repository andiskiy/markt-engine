require 'rails_helper'

RSpec.describe LocalesController, type: :controller do
  describe 'PATCH update' do
    let(:ru)              { :ru }
    let(:en)              { :en }
    let(:valid_request)   { patch :update, params: { locale: en } }
    let(:default_locale)  { I18n.default_locale }
    let(:invalid_request) { patch :update, params: { locale: 'bad' } }

    it 'changed locale' do
      I18n.locale = ru
      valid_request
      expect(I18n.locale).to eq(en)
    end

    it 'invalid locale' do
      invalid_request
      expect(I18n.locale).to eq(default_locale)
    end

    it 'sets flash success' do
      expect(valid_request.request.flash[:success]).to eq(I18n.t('shared.language.success'))
    end

    it 'sets flash danger' do
      expect(invalid_request.request.flash[:danger]).to eq(I18n.t('shared.language.danger'))
    end
  end
end
