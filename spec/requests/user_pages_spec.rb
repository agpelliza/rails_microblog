require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1', text: 'Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do
    let(:submit) { "Create my account" }
    before { visit signup_path }

    describe "with invalid information" do

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end

      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before { valid_signup_information }

      describe "after saving the user" do
        let(:user) { User.find_by(email: 'user@example.com') }
        before { click_button submit }

        it { should have_title(user.name) }
        it { should have_success_message('Welcome') }
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end