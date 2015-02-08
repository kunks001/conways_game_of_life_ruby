class Cell
  attr_accessor :x, :y, :game, :state

  def initialize(x,y,state='alive')
    @x=x
    @y=y
    @game=self.class.game
    @state=state

    @game.cells << self unless out_of_bounds(x,y)
  end 

  def coordinates
    [x,y]
  end

  def alive?
    state == 'alive'
  end

  def die
    @state = 'dead'; true if ![2,3].include?(neighbours.count)
  end

  def live
    @state = 'alive'; true if neighbours.count == 3
  end

  def neighbours
    neighbour_coords & game.cells.collect(&:coordinates)
  end

  def neighbour_coords
    x_coords = [x-1, x, x+1]
    y_coords = [y-1, y, y+1]
    
    x_coords.product(y_coords).reject do |co| 
      co == self.coordinates || out_of_bounds(co[0], co[1])
    end
  end

  def out_of_bounds(x,y)
    return true if x > game.x_bound || x < 0
    y > game.y_bound || y < 0
  end

  def evolve
    self.die || self.live
  end

  class << self
    attr_accessor :game

    def spawn_at(x,y)
      self.new(x,y)
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

  def distribute_cells
    x_range = (0..x_bound).to_a
    y_range = (0..y_bound).to_a

    x_range.product(y_range).each do |coordinates|
      Cell.new(coordinates[0], coordinates[1], 'dead')
    end
  end

  def seed(seeds)
    distribute_cells

    cells.each do |cell|
      cell.live if seeds.include?(cell.coordinates)
    end
  end

  def evolve
    return if cells.empty?
    cells.each { |cell| cell.evolve }
  end

  class << self
    def setup(x_bound=3, y_bound=3)
      Cell.game = self.new(x_bound, y_bound)
    end
  end
end
