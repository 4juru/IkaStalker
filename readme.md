# IkaStalker
+ イカフレンド監視用
+ version:0.1.1
+ [bitbar](https://getbitbar.com)のプラグインです

![](lib/menu.jpg)

## 準備
1. bitbarを[こちら](https://github.com/matryer/bitbar/releases/latest)からダウンロードし、インストールする
2. IkaStalkerを任意のディレクトリに展開
3. session情報はブラウザでログインして、自分で取得する必要あり
	1. イカリングにログインして、Cookieに入っているwag_sessionをコピー
	2. IkaStalker/lib/login.txtを編集
	3. $wag_sessiond = '〇〇'の〇〇部分にコピーしたwag_sessionを貼り付け（$wag_sessiond_dummyを参考に）
	4. IkaStalker/lib/login.txtを上書き保存
4. bitbarを起動し、_Plugins Directory_としてIkaStalkerフォルダを指定
5. メニューバーに_ᔦꙬᔨ-時刻_の表示が出ていれば起動成功(⚠️表記があれば問題あり)


## 更新履歴
2017/05/06 0.1.1	readme.md配置変更,readme.md誤記訂正
2017/05/05 0.1.0	release