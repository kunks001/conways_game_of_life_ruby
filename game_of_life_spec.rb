require './game_of_life'

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

    it 'cannot spawn out of the game boundaries' do
      expect{Cell.spawn_at(-1,0)}.to_not change{game.cells.count}
    end

    it 'cannot have a neighbour in a negative coordinate' do
      cell = Cell.spawn_at(0,0)
      expect(cell.neighbour_coords).to eq [[0,1],[1,0],[1,1]]
    end

    it 'cannot have a neighbour that is out of the game boundaries' do
      Game.setup(3,3)

      cell = Cell.spawn_at(3,3)
      expect(cell.neighbour_coords).to eq [[2,2],[2,3],[3,2]]
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

  it 'rule 3: Any live cell with more than three live neighbours dies' do
    spawn_cells([[1,1], [2,1], [2,2], [2,3]])
    game.evolve

    expect(cell.state).to eq 'dead'
  end

  it 'rule 4: Any dead cell with exactly three live neighbours becomes a live cell' do
    cell.state = 'dead'
    spawn_cells([[1,1], [2,1], [2,2]])
    game.evolve

    expect(cell.state).to eq 'alive'
  end
end