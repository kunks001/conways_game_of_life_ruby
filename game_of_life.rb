class Cell
  attr_accessor :x, :y, :game, :state

  def initialize(game,x,y)
    @x=x
    @y=y
    @game=game
    @state='alive'

    @game.cells << self unless out_of_bounds(x,y)
  end 

  def coords
    [x,y]
  end

  def alive?
    state == 'alive'
  end

  def dies
    @state = 'dead'
  end

  def lives
    @state = 'alive'
  end

  def neighbours
    neighbour_coords & game.cells.collect(&:coords)
  end

  def neighbour_coords
    x_coords = [x-1, x, x+1]
    y_coords = [y-1, y, y+1]
    
    x_coords.product(y_coords).reject do |co| 
      co == self.coords || out_of_bounds(co[0], co[1])
    end
  end

  def out_of_bounds(x,y)
    (x > game.x_bound || x < 0) || (y > game.y_bound || y < 0)
  end

  class << self
    attr_accessor :game

    def spawn_at(x,y)
      self.new(game,x,y)
    end
  end
end

class Game
  attr_accessor :cells, :x_bound, :y_bound

  def initialize(x_bound=3, y_bound=3)
    @cells = []
    @x_bound = x_bound
    @y_bound = y_bound
  end

  def evolve
    return if cells.empty?

    cells.each do |cell|
      cell.dies if !(2..3).include?(cell.neighbours.count)
      cell.lives if cell.neighbours.count == 3
    end
  end

  class << self
    def setup(x_bound=3, y_bound=3)
      Cell.game = self.new(x_bound, y_bound)
    end
  end
end
