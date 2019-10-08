require 'uri'
require 'net/http'
require 'openssl'
require 'digest/md5'
require 'date'
require 'fileutils'
require 'aws-sdk'


class ProustsController < ApplicationController
  skip_before_action:verify_authenticity_token

  def show
    # params = URI.encode_www_form({songs_url: 'https://audd.tech/example1.mp3'})
    # p params
    # 以下一文消しても大丈夫かも
    # parse_url = URI.parse("https://audd.p.rapidapi.com/")

    # url.query = URI.encode_www_form({songs_url: 'https://audd.tech/example1.mp3'})
    # url = URI.parse("https://audd.p.rapidapi.com/?return=timecode%2Capple_music%2Cspotify%2Cdeezer%2Clyrics&itunes_country=us&url=#{params}")


    # getの場合
    # params = URI.encode_www_form({url: 'https://audd.tech/example1.mp3'})
    # p "-----------------"
    # p parse_url
    # url = URI("#{parse_url}?return=timecode%2Capple_music%2Cspotify%2Cdeezer%2Clyrics&itunes_country=us&#{params}")
    # p url

#     binary_file = File.open("binary_file_path.bin", "rb")
# image_file = File.open("image_file_path.png", "rb")
# begin
#   data = [
#     # 通常のパラメータ
#     # <input type="text" name="name1" value="value1"> のような値
#     [ "name1", "value1" ],

#     # ファイルを指定する場合
#     # <input type="file" name="binary_file"> のような場合に相当する
#     [ "binary_file", binary_file, { filename: "binary_file_path.bin" } ],

#     # content_type も指定できる。
#     [ "image_file", image_file, { filename: "image_file_path.png", content_type: "image/png" } ]
#   ]


    url = URI("https://audd.p.rapidapi.com/?return=timecode%2Capple_music%2Cspotify%2Cdeezer%2Clyrics&itunes_country=us")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # binary_file = File.open("tmp/songs/yestaday.mp3", "w+")
    # p binary_file.read
    # binary_file.close
    # p binary_file
    # p "-----------------"
    # postの場合
    # request = Net::HTTP::Post.new(url)
    # request["x-rapidapi-host"] = 'audd.p.rapidapi.com'
    # request["x-rapidapi-key"] = ''
    # request["content-type"] = 'multipart/form-data; boundary=---011000010111000001101001'
    # request.set_form(binary_file, "multipart/form-data")

    # getの場合
    # request = Net::HTTP::Get.new(url)
    # request["x-rapidapi-host"] = 'audd.p.rapidapi.com'
    # request["x-rapidapi-key"] = ''

    # response = http.request(request)
    # puts response.read_body
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
       f.write(file_test.tempfile.read)
    end

    system("ffmpeg -i \"" + wav_file_path + "\" -vn -ac 2 -ar 44100 -ab 256k -acodec libmp3lame -f mp3 \"" + mp3_file_path + "\"")


    # AWS upload
    region = "ap-northeast-1"
    Aws.config.update({
    credentials: Aws::Credentials.new('#{TODO}', '#{TODO}')
    })

    s3 = Aws::S3::Resource.new(region: region)

    file = "/vagrant/proust/public/songs/#{mp3_file_name}"
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
    url = URI("https://audd.p.rapidapi.com/?return=timecode%2Capple_music%2Cspotify%2Cdeezer%2Clyrics&itunes_country=us&url=#{object_path}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'audd.p.rapidapi.com'
    request["x-rapidapi-key"] = '#{TODO}'

    response = http.request(request)
    p "-----------------"
    puts response.read_body
    p "-----------------"

    @result = JSON.parse(response.body)
        # 表示用の変数に結果を格納
  

    render json: @result
    # json = get_analtyices_song(mp3_file_name)

  end


private
def get_analtyices_song(mp3_file_name)
  # 以下一文あっているかわからず
  if current_env == production
    return_param = "timecode%2Capple_music%2Cspotify%2Cdeezer%2Clyrics"
    itunes_country_param = "us"
    url_param = "https%3A%2F%2Faudd.tech%2Fsongs%2F" + mp3_file_name


    url = URI("https://audd.p.rapidapi.com/?return=" + return_param + "&itunes_country=" + itunes_country_param + "&url=" + url_param)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'audd.p.rapidapi.com'
    request["x-rapidapi-key"] = '#{TODO}'

    response = http.request(request)
    puts response.read_body
  else
  
  end
end


end
