class IslandManager
    def initialize(total_island,map_data)
        @total_island = total_island
        @map_data = map_data
    end
    def search_island
        now_island = first_search
        stamp = []  #スタンプを記憶する配列
        loop do
            stamp << now_island #通った島の記憶
            @map_data[now_island] = @map_data[now_island] - stamp
            break if @map_data[now_island].size == 0
            now_island = next_search(now_island,stamp)
        end
        return stamp
    end
    def pruning #枝切りをするためのメソッド#
        @map_data.each_with_index do |data,index|
            if data.size == 1
                delete_judge = index
                loop do #先を見て、隣接数が１ならくり返し消す
                    @map_data.each{|data| data.delete(delete_judge)}
                    delete_judge = @map_data[delete_judge][0]
                    break if @map_data[delete_judge].size != 1
                end
            end
        end
        return @map_data
    end
    private
    def first_search    #隣接島が多い島を始点となる島に選ぶ#
        first_island = 0
        start_number = 0
        @map_data.each_with_index do |data, i|
            if first_island < data.size
                first_island = data.size
                start_number = i
            end
        end
        return start_number
    end
    def next_search(now_island,stamp)
        second_island = @total_island
        next_number = 0
        @map_data[now_island].each do |index|
            @map_data[index] = @map_data[index] - stamp
            if second_island > @map_data[index].size
                second_island = @map_data[index].size
                next_number = index
            end
        end
        return next_number
    end
end

class FileManager
    def read_island
        file_map = open("map.txt")
        total_island = file_map.gets.to_i
        map_data = []
        file_map.readlines.each do |map|
            map_data << map.split(" ").map{|data| data.to_i}
        end
        file_map.close
        return total_island,map_data
    end
    def write(stamp)
        file_sheet = open("stampsheet.txt","w")
        stamp.each{|stamp| file_sheet << "#{stamp} \n"}
        file_sheet.close
    end
end

file_manager = FileManager.new
total_island,map_data = file_manager.read_island
island_manager = IslandManager.new(total_island,map_data)
island_manager.pruning
stamp = island_manager.search_island
file_manager.write(stamp)