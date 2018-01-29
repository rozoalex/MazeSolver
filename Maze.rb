class Maze
  attr_reader :dimensionM, :dimensionN, :dirs

  def initialize n,m
    #maze String has to be a string
    @dimensionN = n
    @dimensionM = m
    @isMazeValid = false
    @dirs = [[1,0],[-1,0],[0,-1],[0,1]]
    @maze = Array.new(dimensionN){Array.new(dimensionM)}
  end

  def load mazeString #the maze string should have size of n*m otherwise print error return false
    if mazeString.length == dimensionM * dimensionN
      counter = 0
      mazeString.each_byte do |i|
        if i!=48 && i != 49
          puts "Illegal char (#{i.chr}) at (#{counter / dimensionM}, #{counter % dimensionM})"
          return false 
        end
        @maze[counter / dimensionM][counter % dimensionM] = i-48
        counter += 1
      end
      puts "Successfully initialized a #{dimensionN} by #{dimensionM} matrix."
      @isMazeValid = true;
      return true
    else
      puts "The size of the input should be #{dimensionM * dimensionN}, instead you provided #{mazeString.length}"
      return false
    end
  end

  def solve beginX, beginY, endX, endY #BFS, non-recursive(require less stack memory), time complexity O(M*N)
    puts "Is there a way from (#{beginX}, #{beginY}) to (#{endX}, #{endY})?"
    if !isValid(endX,endY) 
      puts "No, the end point (#{endX}, #{endY}) is not valid."
      return false, -1 
    end
    explore = []
    explore << [beginX, beginY] if isValid(beginX,beginY) 
    visited = Array.new(dimensionN){Array.new(dimensionM){false}}
    count = 0;
    while explore.length>0
      nextExplore = []
      while explore.length>0
        point = explore.pop
        if point[0] == endX && point[1] == endY
          puts "Yes, there is a way. The shortest path takes #{count} steps."
          return true, count#found a way out!
        end
        visited[point[1]][point[0]] = true #marked visited
        for dir in dirs #exploring
          newPoint = [dir[0]+point[0],dir[1]+point[1]]
          if (isValid(newPoint[0],newPoint[1]) && !visited[newPoint[1]][newPoint[0]])
            puts "add (#{newPoint[0]}, #{newPoint[1]}) to explore list"
            nextExplore << newPoint 
          end
        end
      end
      explore = nextExplore
      count += 1
      puts "--------------------------"
    end
    puts "Unfortunately, no, there is no way."
    return false, -1
  end

  def trace beginX, beginY, endX, endY #DFS, recursive(require large stack memory), time complexity O(4 ^ shortest steps)
    result, steps = solve beginX, beginY, endX, endY
    if result
      copyMZ = getHardcopyOfMaze
      visited = Array.new(dimensionN){Array.new(dimensionM){false}}
      traceHelper beginX, beginY, endX, endY, copyMZ, visited, steps
      displayMatrix copyMZ
    end
  end

  def traceHelper beginX, beginY, endX, endY, mz, visited, steps
    return false if !isValid(beginX, beginY) 
    mz[beginY][beginX] = "*"
    # base case when steps is zero
    # return true if the point is the end
    # return false if the point is not end
    if steps == 0
      if beginX == endX && beginY == endY
        puts "(#{beginX}, #{beginY}) step: #{steps}"
        return true
      else
        mz[beginY][beginX] = "0"
        return false
      end
    end
    # recursive steps
    # loop through all directions, if all failed, set "*" to "0"
    for dir in dirs
      if traceHelper beginX+dir[0], beginY+dir[1], endX, endY, mz, visited, steps-1
        puts "(#{beginX}, #{beginY}) step: #{steps} #{mz[beginY][beginX]}"
        mz[beginY][beginX] = "*"
        return true;
      end
    end
    mz[beginY][beginX] = "0"
    return false
  end

  def getHardcopyOfMaze
    mz = Array.new(dimensionN){Array.new(dimensionM)}
    for i in 0..dimensionN-1
      for j in 0..dimensionM-1
        mz[i][j] = @maze[i][j]
      end
    end
    return mz
  end

  def isValid x,y
    x >= 0 && y >= 0 && x < dimensionM && y < dimensionN && (@maze[y][x] == 0)
  end


  def display 
    if @isMazeValid 
      puts "Print the maze(#{dimensionN}X#{dimensionM}):"
      displayMatrix @maze
    else
      puts "Maze is not valid. Please load a valid one to print."
    end
  end

  def displayMatrix mz
    for ar in mz
      for c in ar
        print c
        print " "
      end
      puts ""
    end
  end
end

#test here
mz = Maze.new 5,5
mz.load "0000011011000100101000000"
# 00000
# 11011
# 00010
# 01010
# 00000
mz.display
#mz.solve 0,0,4,2
mz.trace 0,0,4,2

#another one
mz.load "0000011011000100111000000"
# 00000
# 11011
# 00010
# 01110
# 00000
mz.display
#mz.solve 0,0,4,2
mz.trace 0,0,4,2