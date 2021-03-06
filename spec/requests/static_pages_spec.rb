require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    let(:heading)    { 'Rails Microblog' }
    let(:page_title) { '' }
    before { visit root_path }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
      it { should have_content('2 microposts') }

      describe "with one post" do
        let(:one_post_user) { FactoryGirl.create(:user) }
        before do
          FactoryGirl.create(:micropost, user: one_post_user, content: "Lorem ipsum")
          sign_in one_post_user
          visit root_path
        end

        it { should have_content('1 micropost') }
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  describe "Help page" do
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }
    before { visit help_path }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    let(:heading)    { 'About Us' }
    let(:page_title) { 'About Us' }
    before { visit about_path }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }
    before { visit contact_path }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "microblog"
    expect(page).to have_title(full_title(''))
  end
end