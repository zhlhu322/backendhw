require 'spec_helper'
require 'rails_helper'

RSpec.describe "Registrations", type: :system do
  before do
    driven_by(:rack_test)
  end

  subject { page }

  context "when signing up with valid details and matching passwords" do
    before do
      visit sign_up_path
      fill_in I18n.t("users.name"), with: "Test User"
      fill_in I18n.t("users.email"), with: "test@example.com"
      fill_in I18n.t("users.password"), with: "password"
      fill_in I18n.t("users.password_confirmation"), with: "password"
      click_button I18n.t("users.create.btn")
    end
    it { is_expected.to have_content I18n.t("users.create.success") }
  end

  context "when signing up without email" do
    before do
      visit sign_up_path
      fill_in I18n.t("users.name"), with: "Test User"
      fill_in I18n.t("users.email"), with: ""
      fill_in I18n.t("users.password"), with: "password"
      fill_in I18n.t("users.password_confirmation"), with: "password"
      click_button I18n.t("users.create.btn")
    end
    it { is_expected.to have_content I18n.t("errors.messages.blank") }
  end

  context "when signing up without password" do
    before do
      visit sign_up_path
      fill_in I18n.t("users.name"), with: "Test User"
      fill_in I18n.t("users.email"), with: "test@example.com"
      fill_in I18n.t("users.password"), with: ""
      click_button I18n.t("users.create.btn")
    end
    it { is_expected.to have_content I18n.t("errors.messages.blank") }
  end

  context "when signing up without password matched" do
    before do
      visit sign_up_path
      fill_in I18n.t("users.name"), with: "Test User"
      fill_in I18n.t("users.email"), with: "test@example.com"
      fill_in I18n.t("users.password"), with: "password"
      fill_in I18n.t("users.password_confirmation"), with: "different_password"
      click_button I18n.t("users.create.btn")
    end
    it { is_expected.to have_content I18n.t("errors.messages.confirmation") }
  end

  context "when signing up with a password that is too short" do
    before do
      visit sign_up_path
      fill_in I18n.t("users.name"), with: "Test User"
      fill_in I18n.t("users.email"), with: "test@example.com"
      fill_in I18n.t("users.password"), with: "pass"
      fill_in I18n.t("users.password_confirmation"), with: "pass"
      click_button I18n.t("users.create.btn")
    end
    it { is_expected.to have_content I18n.t("errors.messages.too_short") }
  end

  context "when signing up with an already registered email" do
    let!(:existing_user) { create(:user, email: "user@example.com") }
    before do
      visit sign_up_path
      fill_in I18n.t("users.name"), with: "New User"
      fill_in I18n.t("users.email"), with: "user@example.com"
      fill_in I18n.t("users.password"), with: "password"
      fill_in I18n.t("users.password_confirmation"), with: "password"
      click_button I18n.t("users.create.btn")
    end
    it { is_expected.to have_content I18n.t("errors.messages.taken") }
  end
end
