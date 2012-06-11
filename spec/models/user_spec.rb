# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe User do

	before {@user = User.new(name:"Nisha Dharod", email: "nisha.dharod@gmail.com", password: "foolsbar", password_confirmation: "foolsbar")}

	subject{@user}

	it {should respond_to(:name)}
	it {should respond_to(:email)}
	it {should respond_to(:password_digest)}
	it {should respond_to(:password)}
	it {should respond_to(:password_confirmation)}
	it {should respond_to(:authenticate)}

	it {should be_valid}

	#presence test
	describe "When user is not present" do
		before{@user.name = " "}
		it {should_not be_valid}

	end
	describe "When password is not present" do
		before{@user.password = @user.password_confirmation = " "}
		it {should_not be_valid}
	end
	

	describe "When user email is not present" do
		before{@user.email = " "}
		it {should_not be_valid}

	end

	describe "When Password confirmation is nil" do
		before{@user.password_confirmation = nil}
		it {should_not be_valid}
	end


#length validation
	describe "When user name is too long" do
		before{@user.name = "a" * 51}
		it {should_not be_valid}
	end

# validate password is minimum 8 characters long
 describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 7 }
    it { should be_invalid }
  end

# validating password and confirmation match
	describe "When password and confirmation do not match" do
		before {@user.password_confirmation = "mismatch"}
		it {should_not be_valid}
	end


#format validation
	describe "when email format is invalid" do
	    it "should be invalid" do
	      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
	                     foo@bar_baz.com foo@bar+baz.com @gm.com]
	      addresses.each do |invalid_address|
	        @user.email = invalid_address
	        @user.should_not be_valid
	      end      
	    end
	  end

  	describe "when email format is valid" do
	    it "should be valid" do
	      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
	      addresses.each do |valid_address|
	        @user.email = valid_address
	        @user.should be_valid
	      end      
	    end
	  end

#password format: it should have atleast one capital and one number

#uniqueness validation for email..
	describe "when email is already present" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end
		it{should_not be_valid}

	end	
# validate whether the email is actually getting stored in small case
	describe "email address in mixed case" do
		let(:mixed_case_email) {"Nisha@DHAROD.com"}

		it "should be saved as small case" do
			@user.email = mixed_case_email
			@user.save
			@user.reload.email.should == mixed_case_email.downcase

		end

	end


#password authentication -  
	describe "return value of authenticate method" do
	  before { @user.save }
	  let(:found_user) { User.find_by_email(@user.email) }

	  describe "with valid password" do
	    it { should == found_user.authenticate(@user.password) }
	  end

	  describe "with invalid password" do
	    let(:user_for_invalid_password) { found_user.authenticate("invalid") }

	    it { should_not == user_for_invalid_password }
	    specify { user_for_invalid_password.should be_false }
	  end
	end

end
