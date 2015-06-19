require 'spec_helper'

describe "User Pages" do

	subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('ユーザー一覧') }

    describe "pagination" do
    # ページネーションのこと
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      # it { should have_selector('div.pagination') }
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do
    # リンクを消す
      it { should_not have_link('削除') }
      describe "as an admin user" do
      # 管理者だったら
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        it { should have_link('削除', href: user_path(User.first)) }
        it "should be able to delete another user" do
        # 別のユーザーを消せるようにする
          expect do
            click_link('削除', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('削除', href: user_path(admin)) }
      end
    end

    it "should list each user" do
    # ユーザーのリスト
      User.all.each do |user|
        expect(page).to have_selector('li', text: user.name)
      end
    end
  end

	describe "profile page" do
	# ユーザーのプロフィールページ
    let(:user) { FactoryGirl.create(:user) }
    let!(:d1) { FactoryGirl.create(:document, user: user, content: "Foo") }
    let!(:d2) { FactoryGirl.create(:document, user: user, content: "Bar") }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }

    describe "document" do
      it { should have_content(d1.content) }
      it { should have_content(d2.content) }
      it { should have_content(user.documents.count) }
    end
  end

	describe "signup page" do
	# ユーザー登録ページ
		before { visit signup_path }

		it { should have_content('ユーザー登録') }
		it { should have_title(full_title('Sign up')) }
	end

	describe "signup" do
	# ユーザー登録のとき 
    before { visit signup_path }
		let(:submit) { "Create my account" }

  	describe "with invalid information" do
  	# 登録が無効だったら
  		it "should not create a user" do
    		expect { click_button submit }.not_to change(User, :count)
  		end
  	end

    describe "with valid information" do
    # 登録が有効だったら
    	before do
      	fill_in "Name",         with: "Example User"
      	fill_in "Email",        with: "user@example.com"
      	fill_in "Password",     with: "foobar"
      	fill_in "Confirmation", with: "foobar"
    	end
    	it "should create a user" do
      # ユーザーを作成するときは
        expect { click_button submit }.to change(User, :count).by(1)
      end
      describe "after saving the user" do
      # ユーザーを保存した後は
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('サインアウト') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'ようこそ') }
      end
    end
	end

  describe "edit" do
  # 編集
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
    # ページについて
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
    # 無効だった場合 
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
    # 有効だったとき
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('サインアウト', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end

end
