class IslandManager
    def initialize(total_island,map_data)
        @total_island = total_island
        @map_data = map_data
    end
    def start_select        #隣接島が多い島を始点となる島に選ぶ#
        first_island = 0
        start_number = 0
        @total_island.times do |i|
            if first_island < @map_data[i].size
                first_island = @map_data[i].size
                start_number = i
            end
        end
        return start_number
    end
    def next_select(now_island)     #隣接島が少ない島を次の島に選ぶ#
        stamp = []  #スタンプを記憶する配列
        loop{
            stamp << now_island         #通った島の記憶
            @map_data[now_island] = @map_data[now_island] - stamp
            if @map_data[now_island].size == 0   #行ける島がなくなったらループを抜ける（終了条件）
                break
            end

            second_island = @total_island
            next_number = 0
            @map_data[now_island].size.times do |i|
                data_number = @map_data[now_island][i]
                @map_data[data_number] = @map_data[data_number] - stamp
                if second_island > @map_data[data_number].size
                    second_island = @map_data[data_number].size
                    next_number = @map_data[now_island][i]
                end
            end
            now_island = next_number
        }
        return stamp
    end
    def pruning     #枝切りをするためのメソッド#
        @total_island.times do |i|
            if @map_data[i].size < 2    #隣接島が１または０の島を探す
                dead_judge = i
                @total_island.times do |j|
                    @map_data[j].delete(i)
                end
                loop{  #隣接島１の島の先を見て、隣接数が１ならくり返し消す
                    dead_judge = @map_data[dead_judge][0]
                    if @map_data[dead_judge].size == 1
                        @total_island.times do |k|
                            @map_data[k].delete(i)
                        end
                    else    #隣接島０ならbreak
                        break
                    end
                }
            end
        end
        return @map_data
    end
end

class FileManager
    def read_island
        file_map = open("map.txt")
        total_island = file_map.gets.to_i
        map_data = file_map.readlines
        total_island.times do |i|
            map_data[i] = map_data[i].split(" ")    #半角スペースごとに文字を区切る
            map_data[i].size.times do |j|
               map_data[i][j] = map_data[i][j].to_i
            end
        end
        file_map.close
        return total_island,map_data
    end
    def write_stamp(stamp)
        file_sheet = open("stampsheet.txt","w")
        stamp.size.times do |i|
            file_sheet << "#{stamp[i]} \n"
        end
        file_sheet.close
    end
end

def score(total_island,do_time,stamp)
    point = stamp.size**3 / (total_island * do_time)
    p "time is #{do_time}"
    p "point is #{point}"
    p "stamp is #{stamp.size}"
end

start_time = Time.now

file_manager = FileManager.new
total_island,map_data = file_manager.read_island
island_manager  = IslandManager.new(total_island,map_data)
island_manager.pruning
now_island = island_manager.start_select
stamp = island_manager.next_select(now_island)
file_manager.write_stamp(stamp)

end_time = Time.now
do_time = end_time - start_time
score(total_island,do_time,stamp)