class Cell
  attr_accessor :x, :y, :game

  def initialize(game,x,y)
    @x=x
    @y=y
    @game=game

    @game.cells << self
  end

  def coords
    [x,y]
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

  class << self
    def setup
      Cell.game = self.new
    end
  end
end

describe 'game of life' do
  before{ Game.setup }

  describe 'Game' do
    subject{ Game.new }
    it 'contains cells' do
      expect(subject.cells.count).to eq 0
    end
  end

  describe Cell do
    subject{ Cell.spawn_at(1,2) }

    it 'belongs to a game' do
      expect(Cell.game).to be_a Game
    end

    it 'has a position in the game' do
      expect(subject.x).to eq 1
      expect(subject.y).to eq 2
    end

    it 'can count its neighbours' do
      expect(subject.neighbours.count).to eq 0
    end

    context 'identifying neighbours' do
      [[0, 1], [0, 2], [0, 3], [1, 1], [1, 3], [2, 1], [2,2], [2, 3]].each do |coord|
        it "can identify its neighbour at #{coord}" do
          Cell.spawn_at(coord[0], coord[1])
          expect(subject.neighbours.count).to eq 1
        end
      end
    end
  end

  it 'rule 1: Any live cell with fewer than two live neighbours dies' do
  end
end