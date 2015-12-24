require 'set'

class SceneMap
    def initialize
=begin
        @player = Player.new(96, 16)
        @tileset = Image.load_tiles("graphics/tiles/area02_level_tiles.png", 16, 16, {:tileable=>true})

        @level = []
        @level[0] = [14,14,22,22,22,22,22,22,22,22,22,22,22,22,22,22,23,0,0,0,0,0,0,0,0]
        @level[1] = [14,23,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        @level[2] = [10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        @level[3] = [10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        @level[4] = [14,2,2,2,2,2,2,5,0,0,0,0,0,1,2,2,2,2,2,2,2,2,2,2,2]
        @level[5] = [14,14,14,14,23,0,0,0,0,0,0,0,0,0,21,22,22,22,22,14,14,14,14,14,14]
        @level[6] = [14,23,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,21,14,14]
        @level[7] = [14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,21,14]
        @level[8] = [14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14]
        @level[9] = [14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14]
        @level[10] = [14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14]
        @level[11] = [14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14]
        @level[12] = [14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14]
        @level[13] = [14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14]
        @level[14] = [14,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,14]
=end

        file = File.open("data/Map001.map")
        @used_tileset = Marshal.load(file)
        @level = Marshal.load(file)
        @objects = Marshal.load(file)
        file.close
        @tileset = Image.load_tiles("graphics/tiles/#{@used_tileset}", 16, 16, :tileable=>true)
        @player = nil
        load_entities
        @camera_x = 0
        @camera_y = 0
    end

    def load_entities
        for i in 0...@objects.size
            case @objects[i][0]
                when :player
                @player = Player.new(@objects[i][1], @objects[i][2])
            end
        end
    end
    
    # still walk into wall, need debug
    def update 
        @player.update
#        @player.move_left if $window.button_down?(KbLeft)
#        @player.move_right if $window.button_down?(KbRight)

        @player.fall if no_ground?(@player.get_x, @player.get_y)
        if $window.button_down?(KbLeft) and !wall?(@player.get_x, @player.get_y, :left) then
            @player.move_left
        end
        if $window.button_down?(KbRight) and !wall?(@player.get_x, @player.get_y, :right) then
            @player.move_right
        end

        if @player.is_jumping? then
            if solid_overhead?(@player.get_x, @player.get_y) then
                @player.reset_jump
            end
        end

        @camera_x = [[@player.get_x - 320, 0].max, @level[0][0].size * 16 - 640].min
        @camera_y = [[@player.get_y - 240, 0].max, @level[0][0].size * 16 - 480].min
    end

    def solid_overhead?(x, y)
        tile_x = (x / 16).to_i
        tile_y = (y / 16).to_i
        return @level[0][tile_y][tile_x] != 0
    end
    
    def draw
=begin
        @player.draw
        for y in 0...@level.size
            for x in 0...@level[y].size
                @tileset[@level[y][x]].draw(x*16, y*16, 1)
            end
        end
=end        
        for l in 0...@level.size
            for y in 0...@level[l].size
                for x in 0...@level[l][y].size
                    @tileset[@level[l][y][x]].draw(x*16, y*16, 1)
                    @tileset[@level[l][y][x]].draw(x*16 - @camera_x, y*16 - @camera_y, 1)
                end
            end
        end
        @player.draw(@camera_x, @camera_y)
    end

=begin        
    def wall?(x, y, direction)
        tile_x = (x/16).to_i
        tile_y = (y/16).to_i
        if direction == :left then
            return @level[tile_y-1][tile_x-1] != 0
        elsif direction == :right then
            return @level[tile_y-1][tile_x+1] != 0
        end
    end

    def no_ground?(x, y)
        tile_x = (x/16).to_i
        tile_y = (y/16).to_i
        return @level[tile_y][tile_x] == 0
    end
=end        
    def wall?(x, y, direction)
        tile_x = (x/16).to_i
        tile_y = (y/16).to_i
        if direction == :left then
            return @level[0][tile_y-1][tile_x-1] != 0
        elsif direction == :right then
            return @level[0][tile_y-1][tile_x+1] != 0
        end
    end

    def no_ground?(x, y)
        tile_x = (x/16).to_i
        tile_y = (y/16).to_i
        return @level[0][tile_y][tile_x] == 0
    end
    
    def button_down(id)
        if id == KbUp then
            if !no_ground?(@player.get_x, @player.get_y) then
                #p "Jump!"
                @player.jump
            end
=begin
# for wall debugging
         elsif id == KbLeft then
            @player.move_left
         elsif id == KbRight then
            @player.move_right
=end
        end
        
    end

    def button_up(id)
        if id == KbUp then
            @player.reset_jump if @player.is_jumping?
        end
    end
end
