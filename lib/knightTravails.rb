 class Node
  attr_accessor :child1, :child2, :child3, :child4,:child5,:child6,:child7,:child8, :parent, :xcord, :ycord

  def initialize(xcord = 0, ycord  = 0, parent = nil)
    @xcord = xcord
    @ycord = ycord
    @parent = parent
    @root = nil
    @child1  = nil
    @child2  = nil
    @child3  = nil
    @child4  = nil
    @child5  = nil
    @child6  = nil
    @child7  = nil
    @child8  = nil
  end

end

class KnightTravails
  attr_accessor :board

  def initialize
    @board
    build_board()
    #display_board
  end

  def build_board
    @board = Array.new(8, Array.new(8, ' '))
  end

  def display_board

    for i in @board
      puts "|‾‾‾|‾‾‾|‾‾‾|‾‾‾|‾‾‾|‾‾‾|‾‾‾|‾‾‾|"
      puts "| #{i[0]} | #{i[1]} | #{i[2]} | #{i[3]} | #{i[4]} | #{i[5]} | #{i[6]} | #{i[7]} |"
      puts "|___|___|___|___|___|___|___|___|"
    end
  end

  def knight_moves(startingPos, endingPos)
    @root = Node.new(startingPos[0], startingPos[1])
    foundFlag = false
    queue = []

    queue.concat(assignChildren(@root))

    puts "starting is: (#{@root.xcord}, #{@root.ycord})"
    puts "ending: (#{endingPos[0]}, #{endingPos[1]}})"
    puts

    while(queue.length != 0 or foundFlag == false)
      front = queue.shift
      if (front.xcord == endingPos[0] and front.ycord == endingPos[1])
        foundFlag == true
        break
      else
        queue.concat(assignChildren(front))
      end
    end

    movesCounter = 0
    path = []
    path.push([front.xcord, front.ycord])
    until (front.parent == nil) do
      front = front.parent
      path.push([front.xcord, front.ycord])
      movesCounter += 1
    end

    path = path.reverse
   
    puts "You made it in #{movesCounter} moves!  Heres your path:"
    for i in path
      puts "[#{i[0]}, #{i[1]}]"
    end
    return path

  end

  def assignChildren(node)
    newChildren = []
   
    if ((node.xcord + 2 >= 0 and node.xcord + 2 < 8) and (node.ycord + 1 >= 0 and node.ycord + 1 < 8))
      node.child1 = Node.new(node.xcord + 2, node.ycord + 1, node)
      newChildren.push(node.child1)
    end
    if ((node.xcord + 2 >= 0 and node.xcord + 2 < 8) and (node.ycord - 1 >= 0 and node.ycord - 1 < 8))
      node.child2 = Node.new(node.xcord + 2, node.ycord - 1, node)
      newChildren.push(node.child2)
    end
    if ((node.xcord - 2 >= 0 and node.xcord - 2 < 8) and (node.ycord + 1 >= 0 and node.ycord + 1 < 8))
      node.child3 = Node.new(node.xcord - 2, node.ycord + 1, node)
      newChildren.push(node.child3)
    end
    if ((node.xcord - 2 >= 0 and node.xcord - 2 < 8) and (node.ycord - 1 >= 0 and node.ycord - 1 < 8))
      node.child4 = Node.new(node.xcord - 2, node.ycord - 1, node)
      newChildren.push(node.child4)
    end
    if ((node.xcord + 1 >= 0 and node.xcord + 1 < 8) and (node.ycord + 2 >= 0 and node.ycord + 2 < 8))
      node.child5 = Node.new(node.xcord + 1, node.ycord + 2, node)
      newChildren.push(node.child5)
    end
    if ((node.xcord + 1 >= 0 and node.xcord + 1 < 8) and (node.ycord - 2 >= 0 and node.ycord - 2 < 8))
      node.child6 = Node.new(node.xcord + 1, node.ycord - 2, node)
      newChildren.push(node.child6)
    end
    if ((node.xcord - 1 >= 0 and node.xcord - 1 < 8) and (node.ycord + 2 >= 0 and node.ycord + 2 < 8))
      node.child7 = Node.new(node.xcord - 1, node.ycord + 2, node)
      newChildren.push(node.child7)
    end
    if ((node.xcord - 1 >= 0 and node.xcord - 1 < 8) and (node.ycord - 2 >= 0 and node.ycord - 2 < 8))
      node.child8 = Node.new(node.xcord - 1, node.ycord - 2, node)
      newChildren.push(node.child8)
    end

    return newChildren
  end

end

test = KnightTravails.new
test.knight_moves([7,3],[0,2])
