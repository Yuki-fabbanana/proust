# Proust

音楽を聴いた感動をそのまま記録するデジタルアルバムです。

## 説明

街を歩いている時、カフェで休んでいる時、旅行をしている時。<br>色々なタイミングで、音楽が不意に聞こえてくることがあり、その曲によって感情が呼び起こされることがあります。<br>そのような時に、このサイトを使って、思い出を保存していきましょう。

## デモ

###### 投稿までの動作デモ

[![Video Thumbnail](http://img.youtube.com/vi/G-P5nTzm1KM/0.jpg)](http://www.youtube.com/watch?v=G-P5nTzm1KM)

## 使い方

### 投稿

1. 音楽を聴いて感動したら Proust ボタンを押してください。<br>
   <img width="142" alt="proust_button" src="https://user-images.githubusercontent.com/52590886/68454256-68a21480-023b-11ea-899b-fbcafa5e11bd.png" alt="proust_button" style="height: 20px; width: 20px; display: inline-block">
   Proust ボタン（このボタンを押すことで投稿に必要な情報の取得が行われます）
2. 投稿に必要な情報がすべて取得できたら、投稿画面が表示されます。
   音楽を聴いた時に、感じた感動と、その時に見ていた景色や、その時の心情を表す画像を入力して、投稿ボタンを押してください。

<img width="1434" alt="スクリーンショット 2019-11-07 16 15 09" src="https://user-images.githubusercontent.com/52590886/68457092-c84fee00-0242-11ea-8969-8b3ec7d57c37.png">
3. 投稿された内容が地図上と、タイムライン上に表示されます。

<img width="1435" alt="スクリーンショット 2019-10-29 12 26 50" src="https://user-images.githubusercontent.com/52590886/68454414-e1a16c00-023b-11ea-95df-a852e72fdf80.png">

<img width="1440" alt="proust_time" src="https://user-images.githubusercontent.com/52590886/68454484-1c0b0900-023c-11ea-90ee-9b80aa470ed3.png">

### Proust Friends

1. 自分が投稿した曲と同じ曲に、他のユーザーが投稿をしていた場合、詳細画面に Proust Friends!と表示されます。

<img width="1440" alt="スクリーンショット 2019-11-07 20 27 49" src="https://user-images.githubusercontent.com/52590886/68454590-76a46500-023c-11ea-80f1-fb121c4b8213.png">

2.  Proust Friends!をクリックするとその曲についての、他のユーザーの投稿を見ることができます。

<img width="1440" alt="スクリーンショット 2019-11-07 21 20 10" src="https://user-images.githubusercontent.com/52590886/68454730-e6b2eb00-023c-11ea-9951-d217e2afdabd.png">

<img width="1440" alt="スクリーンショット 2019-11-07 21 21 26" src="https://user-images.githubusercontent.com/52590886/68454801-1c57d400-023d-11ea-854a-809dcd3d6a98.png">

## 投稿が完了するまでの処理の流れ

1. Proust ボタンを押す

2. Web Audio API で録音開始

3. ５秒間で自動的に録音が停止される

4. wav 形式でファイルを保存するためにヘッダに情報を書き加える

5. コントローラに録音したデータを Ajax で渡す

6. tmp フォルダ内に wav ファイルを保存

7. ffmpeg を使い mp ３形式にファイルを変換する

8. S3 へファイルをアップロード

9. ファイルのアクセス権限をパブリックに

10. AudD を叩く

11. AudD から取得した JSON データを view へ渡す

12. Google maps API の geolocation を叩く

13. Geolocation で得た緯度経度情報で住所を取得

14. 取得できたらコントローラーに AudD から取得した JSON データと Google Maps API で得たデータを、パラメータで送信

15. コントローラでデータを受け取り、投稿データと合わせて保存する
