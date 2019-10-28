require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "validates of post model" do

    before do
      @user = User.create(
        name: "test",
        email: "test@test.com",
        password: "password",
      )
    end

    context "valid post" do
      # 曲のタイトル、アーティスト名、アートワーク、住所、緯度、経度、本文があり、本文が140文字以下は有効な状態であること
      it "is valid with a songs_title, artist, artwork, address, latitude, longitude and proper length body" do
        post = @user.posts.build(
          songs_title: "Bottles",
          artist: "Al Green",
          artwork: "https://i.scdn.co/image/ab67616d0000b273e744b18a63b89eb569675987",
          address: "日本、〒150-0041 東京都渋谷区神南１丁目１９−１２",
          latitude: 35.6628264,
          longitude: 139.69939779999999,
          body: "testtesttest",
        )
        post.invalid?

        expect(post).to be_valid
      end
    end

    context "validates presence" do
      # 曲のタイトルが空だと無効な状態であること
      it "is invalid without a songs_title" do
        post = @user.posts.build(
          songs_title: "",
          artist: "Al Green",
          artwork: "https://i.scdn.co/image/ab67616d0000b273e744b18a63b89eb569675987",
          address: "日本、〒150-0041 東京都渋谷区神南１丁目１９−１２",
          latitude: 35.6628264,
          longitude: 139.69939779999999,
          body: "testtesttest",
        )
        post.invalid?

        expect(post).to be_invalid
      end

      # アーティスト名が空だと無効な状態であること
       it "is invalid without an artist" do
        post = @user.posts.build(
          songs_title: "Bottles",
          artist: "",
          artwork: "https://i.scdn.co/image/ab67616d0000b273e744b18a63b89eb569675987",
          address: "日本、〒150-0041 東京都渋谷区神南１丁目１９−１２",
          latitude: 35.6628264,
          longitude: 139.69939779999999,
          body: "testtesttest",
        )
        post.invalid?

        expect(post).to be_invalid
      end

      # アートワークが空だと無効な状態であること
      it "is invalid without an artwork" do
        post = @user.posts.build(
          songs_title: "Bottles",
          artist: "Al Green",
          artwork: "",
          address: "日本、〒150-0041 東京都渋谷区神南１丁目１９−１２",
          latitude: 35.6628264,
          longitude: 139.69939779999999,
          body: "testtesttest",
        )
        post.invalid?

        expect(post).to be_invalid
      end

      # 住所が空だと無効な状態であること
      it "is invalid without a address" do
        post = @user.posts.build(
          songs_title: "Bottles",
          artist: "Al Green",
          artwork: "https://i.scdn.co/image/ab67616d0000b273e744b18a63b89eb569675987",
          address: "",
          latitude: 35.6628264,
          longitude: 139.69939779999999,
          body: "testtesttest",
        )
        post.invalid?

        expect(post).to be_invalid
      end

      # 緯度が空だと無効な状態であること
      it "is invalid without a latitude" do
        post = @user.posts.build(
          songs_title: "Bottles",
          artist: "Al Green",
          artwork: "https://i.scdn.co/image/ab67616d0000b273e744b18a63b89eb569675987",
          address: "日本、〒150-0041 東京都渋谷区神南１丁目１９−１２",
          latitude: nil,
          longitude: 139.69939779999999,
          body: "testtesttest",
        )
        post.invalid?

        expect(post).to be_invalid
      end

      # 経度が空だと無効な状態であること
      it "is invalid without a longitude" do
        post = @user.posts.build(
          songs_title: "Bottles",
          artist: "Al Green",
          artwork: "https://i.scdn.co/image/ab67616d0000b273e744b18a63b89eb569675987",
          address: "日本、〒150-0041 東京都渋谷区神南１丁目１９−１２",
          latitude: 35.6628264,
          longitude: nil,
          body: "testtesttest",
        )
        post.invalid?

        expect(post).to be_invalid
      end

      # 本文が空だと無効な状態であること
      it "is invalid without a body" do
        post = @user.posts.build(
          songs_title: "Bottles",
          artist: "Al Green",
          artwork: "https://i.scdn.co/image/ab67616d0000b273e744b18a63b89eb569675987",
          address: "日本、〒150-0041 東京都渋谷区神南１丁目１９−１２",
          latitude: 35.6628264,
          longitude: 139.69939779999999,
          body: "",
        )
        post.invalid?

        expect(post).to be_invalid
      end
    end

    context "validates length" do
      # 本文が140字以上だと無効な状態であること
      it "is invalid too long body" do
        post = @user.posts.build(
          songs_title: "Bottles",
          artist: "Al Green",
          artwork: "https://i.scdn.co/image/ab67616d0000b273e744b18a63b89eb569675987",
          address: "日本、〒150-0041 東京都渋谷区神南１丁目１９−１２",
          latitude: 35.6628264,
          longitude: 139.69939779999999,
          body: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        )
        post.invalid?

        expect(post).to be_invalid
      end
    end
  end
end