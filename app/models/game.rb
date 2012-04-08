class Game < ActiveRecord::Base
  attr_accessible :level, :size
  require "latinSquareGenerator"
  
  def generateSquare
    @temp = LatinSquareGenerator.Gen_covered_latin_square(self.size, mapLevelPercentage(self.level))
    puts @temp.inspect
    return @temp 
  end
  
  def mapLevelPercentage(level)
    return level*10
  end
  
  def checkSquare(inputSquare)
    return LatinSquareGenerator.Check_latin_square(inputSquare)
  end
       
end
