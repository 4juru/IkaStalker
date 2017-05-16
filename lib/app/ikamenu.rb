#!/usr/bin/env ruby
$:.unshift File.dirname(__FILE__)

require 'time'
require 'net/http'
require 'uri'
require 'json'

load 'stage.image'
load 'login.txt'


private
class String
	# テキスト変換
	def mode_to_text
		case self.to_s
			when "online"  ; "●　　　"
			when "playing" ; "プレイ中"
			when "tag"     ; "タッグ　"
			when "gachi"   ; "ガチ　　"
			when "private" ; "プラベ　"
			when "regular" ; "ナワバリ"
		end + "  "
	end
	def mode_to_color
		case self.to_s
			when "online"  ; "gray"
			when "playing" ; "black"
			when "tag"     ; "orange"
			when "gachi"   ; "red"
			when "private" ; "blue"
			when "regular" ; "green"
		end
	end
	def rule_to_color
		case self.to_s
			when "ガチエリア"	; "orange"
			when "ガチホコ"	; "red"
			when "ガチヤグラ"	; "blue"
			else 			; "green"
		end
	end
	def hour
		Time.parse(self.to_s).hour.to_s + ":00"
	end

	# テキスト修飾メソッド
	def _size(s)
		self.to_s + " size=" + s.to_s
	end
	def _color(c)
		self.to_s + " color=" + c
	end
	def _uri(u)
		self.to_s + " href=" + u
	end
	def _img(i)
		self.to_s + " image=" + i
	end
	def opt
		self.to_s + " |"
	end

	# 情報表示用メソッド
	def rule_view(size)
		self.to_s.opt._size(size)._color(self.to_s.rule_to_color)
	end
	def map_view(size)
		self.to_s.opt._size(size)._color("black")
	end
	def img_view(img)
		self.to_s.opt._img($stage_img[ img ])
	end
end


# [URI]
splapi_uri = "https://splapi.fetus.jp/schedule"
friends_uri = 'https://splatoon.nintendo.net/friend_list/index.json'
prof_uri = "https://splatoon.nintendo.net/profile/"
howto_s_uri = "https://github.com/4juru/IkaStalker/blob/master/doc/getcookie.md"
howto_h_uri = "https://github.com/4juru/IkaStalker/blob/master/doc/sethttparty.md"


# splapiから情報取得
response = Net::HTTP.get_response(URI.parse(splapi_uri))
res_h = (JSON.parse(response.body))["result"]


# メニューのアイコン表示
puts 'ᔦꙬᔨ-' + res_h["regular"][0]["end"].hour
puts '---'


# 現在のステージ情報表示
for mode in ["regular","gachi"] do
	puts res_h[mode][0]["rule"].rule_view(18)
	for itr in [0,1] do
		puts res_h[mode][0]["maps"][itr].map_view(20)
		puts '--' + res_h[mode][0]["maps"][itr].map_view(20)
		puts '--'.img_view(res_h[mode][0]["maps_ex"][itr]["statink"])
	end
end


# 次のステージ情報表示
puts '---'
puts '次のステージ'.opt._size(18)

for t in [1,2] do
	puts res_h["regular"][t]["start"].hour + "-" + res_h["regular"][t]["end"].hour.opt._size(18)
	for mode in ["regular","gachi"] do
		puts '--' + res_h[mode][t]["rule"].rule_view(24)
		for itr in [0,1] do
			puts '--' + res_h[mode][t]["maps"][itr].map_view(20)
			puts '--'.img_view(res_h[mode][t]["maps_ex"][itr]["statink"])
		end
		puts '-----'
	end
end


# フレンドの状態表示
begin
	require 'httparty'

	if $wag_session!="skip"
		puts '---'
		puts 'Friends'.opt._size(18)

		res = HTTParty.get(friends_uri, headers: { 'Cookie' => "_wag_session=#{$wag_session}"} )

		if res.success?
			res.sort_by {|h| h['mode'] }.each do |h|
				puts h['mode'].mode_to_text + "#{h['mii_name']}".opt._size(20)._color( h['mode'].mode_to_color )._uri( prof_uri+"#{h['hashed_id']}" )
			end
		else
			case res.code
			  when 401
			    puts "wag_sessionが正しくない可能性があります".opt._color("red")
			    puts "設定方法".opt._color("blue")._uri(howto_s_uri)
			  when 404
			    puts "O noes not found!"
			  when 500...600
			    puts "ZOMG ERROR #{res.code}"
			end
		end
	end

rescue LoadError
	puts "---"
	puts "httpartyがインストールされていません".opt._color("red")
	puts "インストール方法".opt._color("blue")._uri(howto_h_uri)
end

