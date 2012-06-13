require 'spec_helper'

describe 'User pages:' do

  subject { page }

  shared_examples_for "all user pages" do

  	it {should have_selector('h1', text: heading)}
  	it {should have_selector('title', text: full_title(page_title))}

  end

  describe "signup page" do
    before { visit signup_path }

    let(:heading) {'Sign up'}
    let(:page_title) {'Sign up'}

    it_should_behave_like "all user pages"

    let(:submit){"Create my account"}
    
    describe "with no information - invalid" do
      it "should not create a user" do
        expect{click_button submit}.not_to change(User, :count)
      end
      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",     with: "Nisha Bhamidimarri"
        fill_in "Email",    with: "nisha.dharod@gmail.com"
        fill_in "Password", with: "foolsbar1"
        fill_in "Confirmation",  with: "foolsbar1"
      end
      it "should create a user" do
        expect{click_button submit}.to change(User, :count).by(1)
      end
      describe "after submission" do
        before { click_button submit }
                
                let(:user) {User.find_by_email("nisha.dharod@gmail.com")}
                let(:heading) {user.name}
                let(:page_title) {user.name}

                it_should_behave_like "all user pages"
                it { should_not have_content('error') }
                it { should have_selector('div.alert.alert-success', text: 'Welcome to Sample App!') }

      end
    end


  end

  describe "profile page" do
    let(:user) {FactoryGirl.create(:user)}

    before {visit user_path(user)}

    let(:heading) {user.name}
    let(:page_title) {user.name}

    it_should_behave_like "all user pages"

  end


end