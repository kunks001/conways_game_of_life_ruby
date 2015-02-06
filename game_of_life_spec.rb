class Cell
  attr_accessor :x, :y, :game

  def initialize(game,x,y)
    @x=x
    @y=y

    game.cells << self
  end

  def neighbours
    []
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
  subject{ Cell.spawn_at(1,2) }
  before{ Game.setup }

  describe Cell do
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

    # context 'identifying neighbours' do
    #   it 'to the east' do
    #     Cell.spawn_at(2,2)
    #     expect(subject.neighbours.count).to eq 1
    #   end
    # end
  end
end

describe 'Game' do
  subject{ Game.new }
  it 'contains cells' do
    expect(subject.cells.count).to eq 0
  end
end