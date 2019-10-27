require 'uri'
require 'net/http'
require 'openssl'
require 'digest/md5'
require 'date'
require 'fileutils'
require 'aws-sdk'


class ProustsController < ApplicationController
  skip_before_action:verify_authenticity_token
  before_action :authenticate_user!, except: [:about]

  def about
  end

  def new

    @params_post_info = Post.new

    @params_post_address = address_params["address"]
    @params_post_latitude = address_params["latitude"]
    @params_post_longitude = address_params["longitude"]
    @params_post_artist = address_params["artist"]
    @params_post_album = address_params["album"]
    @params_post_songs_title = address_params["songs_title"]
    @params_post_release_date = address_params["release_date"]
    @params_post_youtube_link = address_params["youtube_link"]

    if address_params["artwork"].empty?
      @params_post_artwork = "/assets/168410.jpg"
    else
      @params_post_artwork = address_params["artwork"]
    end
  end

  def create
    @params_post_info = Post.new(post_params)
    @params_post_info.user_id = current_user.id
    @params_post_address = post_params["address"]
    @params_post_latitude = post_params["latitude"]
    @params_post_longitude = post_params["longitude"]
    @params_post_artist = post_params["artist"]
    @params_post_album = post_params["album"]
    @params_post_songs_title = post_params["songs_title"]
    @params_post_release_date = post_params["release_date"]
    @params_post_youtube_link = post_params["youtube_link"]

    if post_params["artwork"].empty?
      @params_post_artwork = "/assets/168410.jpg"
    else
      @params_post_artwork = post_params["artwork"]
    end

    if @params_post_info.save
      redirect_to map_path
    else
      render ("prousts/new")
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to map_path
  end

  def map
    @posts = Post.where(user_id: current_user.id).order(created_at: :desc)
    gon.posts = Post.where(user_id: current_user.id)
    gon.post = Post.where(user_id: current_user.id).last

    @scroll_posts = Post.where(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(10)
  end


  def show
    @post = Post.find(params[:id])
    v_param = @post.youtube_link.match(/v=.*$/).to_s
    @video_id = v_param.slice!(2..-1)
    songs_title = Post.find(params[:id]).songs_title
    @common_posts = Post.where.not(user_id: current_user.id).where(songs_title: songs_title)
  end

  def common_posts_index
    songs_title = Post.find(params[:id]).songs_title
    gon.common_posts = Post.where.not(user_id: current_user.id).where(songs_title: songs_title)
    @common_posts = Post.where.not(user_id: current_user.id).where(songs_title: songs_title)
    @scroll_common_posts = Post.where.not(user_id: current_user.id).where(songs_title: songs_title).page(params[:page]).per(9)
    @common_post= Post.find(params[:id])
  end

  def common_posts_show
    @post = Post.find(params[:id])
  end

  def rec
  end

  def convert
    file_test = params[:file]
    file_name = Digest::MD5.hexdigest(Time.now.to_s)
    wav_file_name = file_name + ".wav"
    mp3_file_name = file_name + ".mp3"
    wav_file_path = Rails.root.to_s + "/public/songs/" + wav_file_name
    mp3_file_path = Rails.root.to_s + "/public/songs/" + mp3_file_name


    # 以下文tmpfileにした方がいい
    File.open(wav_file_path, 'wb') do |f|
       f.write(file_test.tempfile.read.force_encoding("UTF-8"))
    end

    system("ffmpeg -i \"" + wav_file_path + "\" -vn -ac 2 -ar 44100 -ab 256k -acodec libmp3lame -f mp3 \"" + mp3_file_path + "\"")


    # AWS upload
    region = "ap-northeast-1"
    Aws.config.update({
    credentials: Aws::Credentials.new(Rails.application.credentials.aws[:access_key_id],  Rails.application.credentials.aws[:secret_access_key])
    })

    s3 = Aws::S3::Resource.new(region: region)

    file = "#{Rails.root.to_s}/public/songs/#{mp3_file_name}"
    bucket = 'proust-songs-database'

    # Get just the file name
    name = File.basename(file)


    # Create the object to upload
    obj = s3.bucket(bucket).object(name)

    # Upload it
    obj.upload_file(file)

    # Create a S3 client
    client = Aws::S3::Client.new(region: region)

    # オブジェクトの既定 ACL の設定
    object_key = name
    object_path = "http://#{bucket}.s3-ap-northeast-1.amazonaws.com/#{object_key}"


    client.put_object_acl({
    acl: "public-read",
    bucket: bucket,
    key: object_key,
    })


    # audDからjsonを取得
    url = URI("https://audd.p.rapidapi.com/?return=timecode%2Capple_music%2Cspotify%2Cdeezer%2Clyrics&spotify_country=ja&url=#{object_path}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = Rails.application.credentials.audd[:x_rapidapi_host]
    request["x-rapidapi-key"] = Rails.application.credentials.audd[:x_rapidapi_key]

    response = http.request(request)
    p "-----------------"
    puts response.read_body.force_encoding("UTF-8")
    p "-----------------"

    # 詳細見る必要あり
    @result = JSON.parse(response.read_body)

    render :json => @result

    # json = get_analtyices_song(mp3_file_name)

  end

  private

  def address_params
    params.permit(
        :address,
        :latitude,
        :longitude,
        :artist,
        :songs_title,
        :album,
        :release_date,
        :artwork,
        :youtube_link,
        :body,
        :post_image
      )
  end

  def post_params
    params.require(:post).permit(
      :user_id,
      :address,
      :latitude,
      :longitude,
      :artist,
      :songs_title,
      :album,
      :release_date,
      :artwork,
      :youtube_link,
      :body,
      :post_image
    )
  end

end
