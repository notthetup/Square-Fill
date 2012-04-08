#!/usr/bin/ruby
# This is the 1st attempt at generating lantin squares in Ruby

require File.dirname(__FILE__) + '/latinSquareGenerator.rb'

#Debug = 1;
Debug = 0;
dim = 6;
percent_Cov = 50;

if ARGV.length != 1 && ARGV.length != 2
  puts "Error: usage latinSquares <dimension> [<percent>]";
  exit;
end

dim = ARGV[0].to_i;
if (ARGV.length == 2)
	percent_Cov = ARGV[1].to_i;
end

if (Debug==1)
	puts"\nGenerating latin squares of dimension = "+dim.to_s+" coverage = "+percent_Cov.to_s+"\n"
end

# Generate latin square of arbitary dimension
l_square = LatinSquareGenerator.Gen_latin_square(dim);
#Print the latin square
LatinSquareGenerator.Print_latin_square(l_square);
puts "\nChecking.. \n"

if (LatinSquareGenerator.Check_latin_square(l_square))
	puts "\nValid latin square"
else
	puts "\nInvalid latin square"
end

c_square = LatinSquareGenerator.Cover_latin_square(l_square,percent_Cov);
puts "\nCovered.. \n"
LatinSquareGenerator.Print_latin_square(c_square);


