class Cell
  attr_accessor :x, :y, :game

  def initialize(game,x,y)
    @x=x
    @y=y
    @game=game

    @game.cells << self
  end

  def neighbours
    [north, north_east,east, south_east, south, south_west, west, north_west].select do |neighbour|
      neighbour == true
    end
  end

  def north
    game.cells.select do |cell|
      cell.x == self.x && cell.y == self.y+1
    end.any?
  end

  def north_east
    game.cells.select do |cell|
      cell.x == self.x+1 && cell.y == self.y+1
    end.any?
  end

  def east
    game.cells.select do |cell|
      cell.x == self.x+1 && cell.y == self.y
    end.any?
  end

  def south_east
    game.cells.select do |cell|
      cell.x == self.x+1 && cell.y == self.y-1
    end.any?
  end

  def south
    game.cells.select do |cell|
      cell.x == self.x && cell.y == self.y-1
    end.any?
  end

  def south_west
    game.cells.select do |cell|
      cell.x == self.x-1 && cell.y == self.y-1
    end.any?
  end

  def west
    game.cells.select do |cell|
      cell.x == self.x-1 && cell.y == self.y
    end.any?
  end

  def north_west
    game.cells.select do |cell|
      cell.x == self.x-1 && cell.y == self.y+1
    end.any?
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
      it 'to the north' do
        Cell.spawn_at(1,3)
        expect(subject.neighbours.count).to eq 1
      end

      it 'to the north-east' do
        Cell.spawn_at(2,3)
        expect(subject.neighbours.count).to eq 1
      end

      it 'to the east' do
        Cell.spawn_at(2,2)
        expect(subject.neighbours.count).to eq 1
      end

      it 'to the south-east' do
        Cell.spawn_at(2,1)
        expect(subject.neighbours.count).to eq 1
      end

      it 'to the south' do
        Cell.spawn_at(1,1)
        expect(subject.neighbours.count).to eq 1
      end

      it 'to the south_west' do
        Cell.spawn_at(0,1)
        expect(subject.neighbours.count).to eq 1
      end

      it 'to the west' do
        Cell.spawn_at(0,2)
        expect(subject.neighbours.count).to eq 1
      end

      it 'to the north_west' do
        Cell.spawn_at(0,3)
        expect(subject.neighbours.count).to eq 1
      end
    end
  end

  it 'rule 1: Any live cell with fewer than two live neighbours dies' do
  end
end