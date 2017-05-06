#!/usr/bin/env ruby
$:.unshift File.dirname(__FILE__)

require 'time'
require 'httparty'
require 'net/http'
require 'uri'
require 'json'

load 'lib/stage.image'
load 'lib/login.txt'




def timeconv(t)
	return Time.parse(t).hour.to_s + ":00"
end

def dayconv(t)
	return Time.parse(t).month.to_s+  "/" +Time.parse(t).day.to_s 
end

def mode2color(mode)
	if mode=="online" then
		return "gray"
	elsif mode=="playing" then
		return "black"
	elsif mode=="tag" then
		return "orange"
	elsif mode=="gachi" then
		return "red"
	elsif mode=="private" then
		return "blue"
	elsif mode=="regular" then
		return "green"
	else
		return "blue"
	end
end

def mode2char(mode)
	if mode=="online" then
		return "●　　　"
	elsif mode=="playing" then
		return "プレイ中"
	elsif mode=="tag" then
		return "タッグ　"
	elsif mode=="gachi" then
		return "ガチ　　"
	elsif mode=="private" then
		return "プラベ　"
	elsif mode=="regular" then
		return "ナワバリ"
	else
		return mode
	end
end

def rule2color(rule)
	if rule=="ガチエリア" then
		return "orange"
	elsif rule=="ガチホコ" then
		return "red"
	elsif rule=="ガチヤグラ" then
		return "blue"
	else
		return "green"
	end
end


# [URI]
uri = "https://splapi.fetus.jp/schedule"


# [GETリクエスト]
# Net::HTTP.startでHTTPセッションを開始する
# 既にセッションが開始している場合はIOErrorが発生
response = Net::HTTP.get_response(URI.parse(uri))

# [JSONパース処理]
# JSONオブジェクトをHashへパースする
# JSON::ParserErrorが発生する可能性がある
jhash = JSON.parse(response.body)

head=["","--","--"]
reg_rule=[]
gachi_rule=[]
time=Array.new(3){Hash.new()}
day=[]
gachi_map=Array.new(3){ Array.new(2) }
reg_map=Array.new(3){ Array.new(2) }

gachi_mapx=Array.new(3){ Array.new(2) }
reg_mapx=Array.new(3){ Array.new(2) }

0.upto(2) do |i|
	time[i]["start"] = timeconv(jhash["result"]["regular"][i]["start"])
	time[i]["end"] = timeconv(jhash["result"]["regular"][i]["end"])
	day[i] = dayconv(jhash["result"]["regular"][i]["start"])
	reg_rule[i]= "ナワバリ"
	gachi_rule[i]= jhash["result"]["gachi"][i]["rule"]
	reg_map[i][0]= jhash["result"]["regular"][i]["maps"][0]
	reg_map[i][1]= jhash["result"]["regular"][i]["maps"][1]
	gachi_map[i][0]= jhash["result"]["gachi"][i]["maps"][0]
	gachi_map[i][1]= jhash["result"]["gachi"][i]["maps"][1]

	reg_mapx[i][0] = jhash["result"]["regular"][i]["maps_ex"][0]["statink"]
	reg_mapx[i][1] = jhash["result"]["regular"][i]["maps_ex"][1]["statink"]
	gachi_mapx[i][0] = jhash["result"]["gachi"][i]["maps_ex"][0]["statink"]
	gachi_mapx[i][1] = jhash["result"]["gachi"][i]["maps_ex"][1]["statink"]
end


t=0

puts 'ᔦꙬᔨ' +"-"+ time[t] ["end"]
# puts 'ᔦꙬᔨ'
puts '---'

puts head[t] + reg_rule[t] + '| size=16 color=' + rule2color(reg_rule[t])
puts head[t] + reg_map[t][0] + "| size=20 color=black"
puts head[t] + '--| image="' + $stage_img[reg_mapx[t][0]] + '"'
puts head[t] + reg_map[t][1] + "| size=20 color=black"
puts head[t] + '--| image="' + $stage_img[reg_mapx[t][1]] + '"'

puts head[t] + gachi_rule[t] + '| size=16 color=' + rule2color(gachi_rule[t])
puts head[t] + gachi_map[t][0] + "| size=20 color=black"
puts head[t] + '--| image="' + $stage_img[gachi_mapx[t][0]] + '"'
puts head[t] + gachi_map[t][1] + "| size=20 color=black"
puts head[t] + '--| image="' + $stage_img[gachi_mapx[t][1]] + '"'
puts '---'

puts '次のステージ| size=16'

t=1

puts time[t] ["start"] + "-" + time[t] ["end"] + '| size=18'

puts head[t] + reg_rule[t] + '| size=16 color=' + rule2color(reg_rule[t])
puts head[t] + reg_map[t][0] + "| size=20 color=black"
puts head[t] + '--| image="' + $stage_img[reg_mapx[t][0]] + '"'
puts head[t] + reg_map[t][1] + "| size=20 color=black"
puts head[t] + '--| image="' + $stage_img[reg_mapx[t][1]] + '"'

puts head[t] + gachi_rule[t] + '| size=16 color=' + rule2color(gachi_rule[t])
puts head[t] + gachi_map[t][0] + "| size=20 color=black"
puts head[t] + '--| image="' + $stage_img[gachi_mapx[t][0]] + '"'
puts head[t] + gachi_map[t][1] + "| size=20 color=black"
puts head[t] + '--| image="' + $stage_img[gachi_mapx[t][1]] + '"'


t=2

puts time[t] ["start"] + "-" + time[t] ["end"] + '| size=18'

puts head[t] + reg_rule[t] + '| size=16 color=' + rule2color(reg_rule[t])
puts head[t] + reg_map[t][0] + "| size=20 color=black"
puts head[t] + '--| image="' + $stage_img[reg_mapx[t][0]] + '"'
puts head[t] + reg_map[t][1] + "| size=20 color=black"
puts head[t] + '--| image="' + $stage_img[reg_mapx[t][1]] + '"'

puts head[t] + gachi_rule[t] + '| size=16 color=' + rule2color(gachi_rule[t])
puts head[t] + gachi_map[t][0] + "| size=20 color=black"
puts head[t] + '--| image="' + $stage_img[gachi_mapx[t][0]] + '"'
puts head[t] + gachi_map[t][1] + "| size=20 color=black"
puts head[t] + '--| image="' + $stage_img[gachi_mapx[t][1]] + '"'


if $wag_session.size>20

	puts '---'
	puts 'Friends | size=18'


	res = HTTParty.get('https://splatoon.nintendo.net/friend_list/index.json', headers: { 'Cookie' => "_wag_session=#{$wag_session}"} )

	res.sort_by {|h| h['mode'] }.each do |h|
	  puts mode2char(h['mode']) + "   #{h['mii_name']}" + " | size=20 color=" + mode2color(h['mode'])+ " href=https://splatoon.nintendo.net/profile/#{h['hashed_id']}"
	end

end

