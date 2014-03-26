####島を決めるためのクラス####
class IslandSelect

##始点となる島を決めるメソッド##
#隣接島が多い島を始点となる島に選ぶ#
    def start_island(total_island, map_data)
        first_island = 0
        start_number = 0
        total_island.times do |i|
            if first_island < map_data[i].size
                first_island = map_data[i].size
                start_number = i
            end
        end
        return start_number
    end

##次の島を選ぶメソッド##
#隣接島が少ない島を次の島に選ぶ#
    def next_island(total_island, map_data, now_island)
        second_island = total_island
        next_number = 0
        map_data[now_island].size.times do |i|
            data_number = map_data[now_island][i]
            if second_island > map_data[data_number].size
                second_island = map_data[data_number].size
                next_number = map_data[now_island][i]
            end
        end
        return next_number
    end

end


####移動制限関係のクラス####
class Keep_Off_Island

##芝刈りをするためのメソッド##
    def lawn_mowing(total_island,map_data)
        total_island.times do |i|
            if map_data[i].size < 2	#隣接島が１または０の島を探す
                dead_judge = i
                total_island.times do |j|
                    map_data[j].delete(i)
                end
                while true	#隣接島１の島の先を見て、隣接数が１ならくり返し消す
                    dead_judge = map_data[dead_judge][0]
                    if map_data[dead_judge].size == 1
                        total_island.times do |k|
                            map_data[k].delete(i)
                        end
                    else	#隣接島０ならbreak
                        break
                    end
                end
            end
        end
        return map_data
    end

##差集合を取る為のメソッド##
    def relative_complement(total_island,map_data,now_island,stamp)
        map_data[now_island] = map_data[now_island] - stamp
    end

##島を消していくメソッド##
    def delete_island(total_island,map_data,now_island)
        total_island.times do |i|
            map_data[i].delete(now_island)
        end
    end

end


####ファイルへのアクセスをするクラス####
class File_Access

##ファイルオープン##
    def file_open(file_name)
        open(file_name)
    end

##ファイルクローズ##
    def file_close(file_name)
        file_name.close
    end

##スタンプシートに書き込むメソッド##
    def write_stamp(stamp)
        stamp.size.times do |i|
            f_sheet << "#{stamp[i]} \n"
        end
    end

end


####初期設定をするためのクラス####
class Default

##島の総数を得るためのメソッド##
    def total(total_island)
        total_island.gets.to_i
    end

##島のデータを読み込むためのメソッド##
    def read_island(file)
        file.readlines
    end

##島のデータを整数型に変換するメソッド##
    def integer_type(total_island,map_data)
        total_island.times do |i|
            map_data[i] = map_data[i].split(" ")	#半角スペースごとに文字を区切る
	        map_data[i].size.times do |j|
	           map_data[i][j] = map_data[i][j].to_i
            end
        end
        return map_data
    end

end

start_time = Time.now           #開始時刻の取得

##オブジェクト生成##
island_select  = IslandSelect.new
map_access = File_Access.new
sheet_access = File_Access.new
keep_off_island = Keep_Off_Island.new
default = Default.new


stamp = []	#スタンプを記憶する配列
file_map = map_access.file_open('map.txt')
#file_map = open("map.txt")
total_island = default.total(file_map)
map_data = default.read_island(file_map)
map_data = default.integer_type(total_island,map_data)
keep_off_island.lawn_mowing(total_island,map_data)


#file_sheet = sheet_access.file_open('stampsheet.txt','w')
file_sheet = open("stampsheet.txt","w")
now_island = island_select.start_island(total_island, map_data)

##メインループ##
while true
    stamp << now_island			#通った島の記憶
    #keep_off_island.relative_complement(total_island,map_data,now_island,stamp)
    keep_off_island.delete_island(total_island,map_data,now_island)
    if map_data[now_island].size == 0	#行ける島がなくなったらループを抜ける（終了条件）
        break
    end
    now_island = island_select.next_island(total_island, map_data, now_island)
end

#sheet_access.write_stamp(stamp)
stamp.size.times do |i|
    file_sheet << "#{stamp[i]} \n"  
end

end_time = Time.now
do_time = end_time - start_time


##得点の計算・表示##
point = stamp.size**3 / (total_island * do_time)
p "time is #{do_time}"
p "point is #{point}"
p "stamp is #{stamp.size}"

#map_access.file_close('file_map')
#sheet_access.file_close(file_sheet)

file_map.close
file_sheet.close