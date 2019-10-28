require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validates of user model" do
    context "validates unique" do
      # 重複したメールアドレスなら無効な状態であること
      it "is invalid with a duplicate email address" do
        user = User.create(
          name: "test1",
          email: "test@test.com",
          password: "password",
        )

        user2 = User.new(
          name: "test2",
          email: "test@test.com",
          password: "password",
        )
        user2.invalid?
        expect(user2).to be_invalid
      end
    end

    context "validates presence" do
      # 名前が空だと無効な状態であること
      it "is invalid without a name" do
        user = User.new(
          name: "",
          email: "test@test.com",
          password: "password",
        )
        user.invalid?
        expect(user).to be_invalid
      end

      # 名前が20字以上だと無効な状態であること
      it "is invalid too long name" do
        user = User.new(
          name: "aaaaaaaaaaaaaaaaaaaaa",
          email: "test@test.com",
          password: "password",
        )
        user.invalid?
        expect(user).to be_invalid
      end

      # パスワードが6文字未満だと無効な状態であること
      it "is invalid with a short password" do
        user = User.new(
          name: "test",
          email: "email@email.com",
          password: "aaaaa",)
        user.invalid?
        expect(user).to be_invalid
      end
    end
  end
end