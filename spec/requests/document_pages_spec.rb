require 'spec_helper'

describe "Document pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "document creation" do
  # document作成について
    before { visit root_path }

    describe "with invalid information" do
    # 無効のとき
      it "should not create a document" do
        expect { click_button "Post" }.not_to change(Document, :count)
      end

      describe "error messages" do
      # エラーメッセージ
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
    # 有効なとき
      before { fill_in 'document_content', with: "Lorem ipsum" }
      it "should create a document" do
        expect { click_button "Post" }.to change(Document, :count).by(1)
      end
    end
  end

  describe "document destruction" do
  # documentを削除
    before { FactoryGirl.create(:document, user: user) }

    describe "as correct user" do
    # 適切なユーザー
      before { visit root_path }

      it "should delete a document" do
        expect { click_link "delete" }.to change(Document, :count).by(-1)
      end
    end
  end
end
