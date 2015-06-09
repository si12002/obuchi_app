require 'spec_helper'

describe User do
  before do
  	@user = User.new(name: "Example User", email: "user@example.com") 
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }

  it { should be_valid }

  # name属性の存在性を調べる
  describe "when name is not present" do
  	# nameが空欄だったら
    before { @user.name = " " }
    it { should_not be_valid }
  end

  # email属性の存在性を調べる
  describe "when email is not present" do
  	# emailが空欄だったら
    before { @user.email = " " }
    it { should_not be_valid }
  end

  # nameの長さを調べる
  describe "when name is too long" do
  	# 名前が長過ぎたら
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  # メールアドレスのフォーマットを調べる
  describe "when email format is invalid" do
    # メールアドレスが無効だったとき
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  describe "when email format is valid" do
  	# メールアドレスが有効だったとき
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  # 重複するメールアドレスの拒否のテスト
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase # 大文字小文字を区別しない
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

end
