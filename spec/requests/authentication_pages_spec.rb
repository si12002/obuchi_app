require 'spec_helper'

describe "Authentication" do
	subject { page }

  describe "signin " do
  # サインイン
   	before { visit signin_path }

  	describe "with invalid information" do
  	# 無効のとき
    	before { click_button "Sign in" }
    	it { should have_title('Sign in') }
    	it { should have_selector('div.alert.alert-error', text: '無効') }

    	describe "after visiting another page" do
    	# 別のページに移動したとき
      	before { click_link "ホーム" }
      	it { should_not have_selector('div.alert.alert-error') }
    	end
  	end

  	describe "with valid information" do
  	# 有効なとき
    	let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_title(user.name) }
      it { should have_link('ユーザー一覧', href: users_path) }
      it { should have_link('マイページ', href: user_path(user)) }
      it { should have_link('編集', href: edit_user_path(user)) }
      it { should have_link('サインアウト', href: signout_path) }
      it { should_not have_link('サインイン', href: signin_path) }

      describe "followed by signout" do
        before { click_link "サインアウト" }
        it { should have_link('サインイン') }
      end
    end
	end

  describe "authorization" do
  # 許可
    describe "for non-signed-in users" do
    # サインインしていないユーザー
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
      # 保護されたページに行こうとしたとき
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
        # サインインした後
          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
        end
      end

      describe "in the Users controller" do
      # Usersコントローラーの中で
        describe "visiting the edit page" do
        # editページに飛ぶとき
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
        # updateアクションを受ける
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end
      end
    end

    describe "as wrong user" do
    # 間違ったユーザー
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
      # Users#editアクションへのGETリクエストを出す
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a PATCH request to the Users#update action" do
      # Users#updateアクションへのPATCHリクエストを出す
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
    # 管理者ユーザーじゃない人
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
      # Users#destroyアクションへDELETEリクエストを出す
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end
  end
end
