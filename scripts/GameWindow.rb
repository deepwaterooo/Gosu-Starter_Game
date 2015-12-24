# Main Game Window

class GameWindow < Gosu::Window

  def initialize
    super(640,480,false)
    self.caption = "Homebrew Gosu"
    $window = self
    $scene = SceneMap.new
  end

  def update
    $scene.update
  end

  def draw
    $scene.draw
    #self.draw_line(0, 0, Color.new(255, 255, 255), 640, 480, Color.new(255, 255, 255), 0)
  end

  def button_down(id)
    $scene.button_down(id)
  end

  def button_up(id)
    $scene.button_up(id)
  end
end
