require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validates of user model' do
    context 'validates unique' do
      # 重複したメールアドレスなら無効な状態であること
      it 'is invalid with a duplicate email address' do
        User.create(
          name: 'Joe',
          email: 'test@test.com',
          password: 'password'
        )

        user = User.new(
          name: 'Jane',
          email: 'test@test.com',
          password: 'password'
        )
        user.valid?
        expect(user.errors[:email]).to include('has already been taken')
      end
    end

    context 'validates presence' do
      # 名前が空だと無効な状態であること
      it 'is invalid without a name' do
        user = User.new(
          name: '',
          email: 'test@test.com',
          password: 'password'
        )
        user.valid?

        expect(user.errors[:name]).to include("can't be blank")
      end
    end

    context 'validates length' do
      # 名前が20字以上だと無効な状態であること
      it 'is invalid too long name' do
        user = User.new(
          name: 'aaaaaaaaaaaaaaaaaaaaa',
          email: 'test@test.com',
          password: 'password'
        )
        user.valid?

        expect(user.errors[:name]).to include('is too long (maximum is 20 characters)')
      end

      # パスワードが6文字未満だと無効な状態であること
      it 'is invalid with a short password' do
        user = User.new(
          name: 'test',
          email: 'email@email.com',
          password: 'aaaaa'
        )
        user.valid?
        expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
      end
    end
  end
end
