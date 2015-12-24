class SceneEditor
    def initialize
        #initialize
        @bg = Gosu::Image.new("editor/editor.png", :tileable=>false)

        width = 60
        height = 45
        @level = []
        for layer in 0...2
            @level[layer] = []
            for y in 0...height
                @level[layer][y] = []
                for x in 0...width
                    @level[layer][y][x] = 0
                end
            end
        end

        @used_tileset = "area02_level_tiles.png"
        #@tileset = Image.load_tiles("graphics/tiles/area02_level_tiles.png", 16, 16, :tileable=>true)
        @tileset = Image.load_tiles("graphics/tiles/#{@used_tileset}", 16, 16, :tileable=>true)
        @sel_16 = Image.new("editor/sel16.png", :tileable=>false)
        @sel_16_x = 16
        @sel_16_y = 112
        @sel_32 = Image.new("editor/sel32.png", :tileable=>false)
        @sel_32_x = 672
        @sel_32_y = 112
        @selected_tile = 0
        @current_layer = 0
        @grid = Image.new("editor/grid.png", :tileable=>false)

        @offset_x = 0
        @offset_y = 0
        @ctrl_held = false

        @objects = []
        @player_graphic = Image.load_tiles("graphics/sprites/player_1_run_left.png", 32, 32, :tileable=>false)
        @active_mode = :map
        @object_held = nil
    end

    def select_object(object)
        @object_held = object
        @active_mode = :objects
        @sel_32_x = 768
    end
    
    def update
        if $window.button_down?(MsLeft) and $window.mouse_x.between?(368, 1008) and $window.mouse_y.between?(160, 640) then
            place_tile($window.mouse_x, $window.mouse_y)
        end
    end

    def draw
        @bg.draw(0, 0, 0)
        @grid.draw(368, 160, 5)

        # draw player
        frame = milliseconds / 150 % @player_graphic.size
        @player_graphic[frame].draw(32, 352, 1)
        
        for l in 0...@level.size
            for y in 0...@level[l].size
                for x in 0...@level[l][y].size
                    tx = 368 + (x * 16)
                    ty = 160 + (y * 16)
                    i = @level[l][y + @offset_y][x + @offset_x]   
                    #@tileset[i].draw(tx, ty, 1+l) if i != 0 and i != nil
                    if l == @current_layer then
                        @tileset[i].draw(tx, ty, 1+l) if i != 0 and i != nil
                    else
                        @tileset[i].draw(tx, ty, 1+l, 1.0, 1.0, Color.new(160, 255, 255, 255)) if i != 0 and i != nil
                    end
                end
            end
        end

        for i in 0...@tileset.size
            tx = 16 + (i % 20) * 16
            ty = 112 + ((i / 20) * 16)
            @tileset[i].draw(tx, ty, 1)
        end
        @sel_16.draw(@sel_16_x, @sel_16_y, 5)
        @sel_32.draw(@sel_32_x, @sel_32_y, 5)

=begin            
        case @object_held
        when nil
            for i in 0...@objects.size
                case @objects[i][0]
                when :player
                    frame = milliseconds / 150 % @player_graphic.size
                    rx = @object[i][1] - (@offset_x * 16) + 368
                    ry = @object[i][2] - (@offset_y * 16) + 160
                    @player_graphic[frame].draw(rx, ry, 6)
                end
            end
        when :player
=end
        if @object_held == :player
            @player_graphic[0].draw($window.mouse_x, $window.mouse_y, 10)
        end

    end

    def button_down(id)
        if id == MsLeft then
            click
        end

        if id == MsWheelDown then
            increase_offset
        end
        if id == MsWheelUp then
            decrease_offset
        end
        if id == KbLeftControl then
            @ctrl_held = true
        end

        if id == KbUp then
            decrease_offset
        end
        if id == KbDown then
            increase_offset
        end
        if id == KbLeft then
            decrease_offset(true)
        end
        if id == KbRight then
            increase_offset(true)
        end
    end

    def button_up(id)
        if id == KbLeftControl then
            @ctrl_held = false
        end
    end

    def increase_offset(forced = false)
        if @ctrl_held or forced then
            @offset_x += 1 if (@offset_x < @level[0][0].size - 40)
        elsif @offset_y < 0 then
            @offset_y += 1
        elsif @offset_y > 0 then
            @offset_y -= 1
        end
    end

    def decrease_offset(forced = false)
        if @ctrl_held then
            @offset_x -= 1
        else
            @offset_y -= 1
        end
    end
    
    def click
        if $window.mouse_x.between?(16, 336) and $window.mouse_y.between?(112, 304) then
            select_tile($window.mouse_x, $window.mouse_y)
        elsif $window.mouse_x.between?(368, 1008) and $window.mouse_y.between?(160, 640) then
            p "map"
        elsif $window.mouse_x.between?(32, 64) and $window.mouse_y.between?(352, 384) then
            select_object(:player)
        elsif $window.mouse_x.between?(560, 600) and $window.mouse_y.between?(112, 144) then
            save
        elsif $window.mouse_x.between?(672, 704) and $window.mouse_y.between?(112, 144) then
            @current_layer = 0
            @sel_32_x = 672
        elsif $window.mouse_x.between?(720, 752) and $window.mouse_y.between?(112, 144) then
            @current_layer = 1
            @sel_32_x = 720
        end

        if @active_mode == :map then
            place_tile($window.mouse_x, $window.mouse_y)
        elsif @active_mode == :objects then
            place_object($window.mouse_x, $window.mouse_y)
        end
    end

    def place_object(x, y)
        rx = x + (@offset_x * 16) - 368
        ry = y + (@offset_y * 16) - 160
        @objects << [@object_held, rx, ry]
        if @object_held == :player then
            @object_held = nil
=begin            
            for i in 0...@objects.size
                case @objects[i][0]
                when :player
                    frame = milliseconds / 150 % @player_graphic.size
                    rx = @objects[i][1] - (@offset_x * 16) + 368
                    ry = @objects[i][2] - (@offset_y * 16) + 160
                    @player_graphic[frame].draw(rx, ry, 6)
                end
            end
=end
        end
        if @object_held == :player then
            for i in 0...@objects.size
                if @objects[i][0] == :player
                    @objects.delete_at(i)
                end
            end
        end
    end

    def select_tile(x, y)
        tx = ((x - 16) / 16).floor
        ty = ((y - 112) / 16).floor
        i = tx + (ty * 20)
        @sel_16_x = (tx * 16) + 16
        @sel_16_y = (ty * 16) + 112
        @select_tile = i
        @active_mode = :map
    end

    def place_tile(x, y)  
        tx = ((x - 368) / 16).floor + @offset_x
        ty = ((y - 160) / 16).floor + @offset_y
        @level[@current_layer][ty][tx] = @select_tile
    end

    def save
        f = File.new("Map000.map", "w+")
        Marshal.dump(@used_tileset, f)
        Marshal.dump(@level, f)
        Marshal.dump(@objects, f)
        f.close
    end
    
end
