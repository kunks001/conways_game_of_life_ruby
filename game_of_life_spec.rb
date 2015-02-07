class Cell
  attr_accessor :x, :y, :game, :state

  def initialize(game,x,y)
    @x=x
    @y=y
    @game=game
    @state='alive'

    @game.cells << self
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
      co == self.coords
    end
  end

  class << self
    attr_accessor :game

    def spawn_at(x,y)
      self.new(game,x,y)
    end
  end
end

class Game
  attr_accessor :cells

  def initialize
    @cells = []
  end

  def evolve
    return if cells.empty?

    cells.each do |cell|
      cell.dies if !(2..3).include?(cell.neighbours.count)
      cell.lives if cell.neighbours.count == 3
    end
  end

  class << self
    def setup
      Cell.game = self.new
    end
  end
end

def spawn_cells(coords=[])
  coords.flatten.each_slice(2).to_a.each do |co|
    Cell.spawn_at(co[0],co[1])
  end
end

describe 'game of life' do
  let(:cell){ Cell.spawn_at(1,2) }
  let(:game){ cell.game }

  before{ Game.setup }

  describe Game do
    subject{ Game.new }

    it 'contains cells' do
      expect(subject.cells.count).to eq 0
    end
  end

  describe Cell do
    it 'belongs to a game' do
      expect(Cell.game).to be_a Game
    end

    it 'can be alive or not' do
      expect(cell.alive?).to eq true
    end

    it 'has a position in the game' do
      expect(cell.x).to eq 1
      expect(cell.y).to eq 2
    end

    it 'can count its neighbours' do
      expect(cell.neighbours.count).to eq 0
    end

    context 'identifying neighbours' do
      [[0, 1], [0, 2], [0, 3], [1, 1], [1, 3], [2, 1], [2,2], [2, 3]].each do |coord|
        it "can identify its neighbour at #{coord}" do
          spawn_cells(coord)
          expect(cell.neighbours.count).to eq 1
        end
      end
    end
  end

  it 'rule 1: Any live cell with fewer than two live neighbours dies' do
    spawn_cells([2,2])
    game.evolve

    expect(cell.state).to eq 'dead'
  end

  it 'rule 2: Any live cell with two or three live neighbours lives on to the next generation' do
    spawn_cells([[2,2],[2,3]])
    game.evolve

    expect(cell.state).to eq 'alive'
  end

  it 'rule 3: Any live cell with more than three live neighbours dies, as if by overcrowding' do
    spawn_cells([[1,1], [2,1], [2,2], [2,3]])
    game.evolve

    expect(cell.state).to eq 'dead'
  end

  it 'rule 4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction' do
    cell.state = 'dead'
    spawn_cells([[1,1], [2,1], [2,2]])
    game.evolve

    expect(cell.state).to eq 'alive'
  end
end