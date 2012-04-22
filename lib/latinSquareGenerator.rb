#!/usr/bin/ruby

module LatinSquareGenerator

VERSION = "1.0.3"
Debug = 0


##################################################################
#
# 
#
##################################################################
def LatinSquareGenerator.Check_latin_square(l_square, inner_square_flag)

dim = l_square.count;

if Debug == 1
	puts("\ndim = " + dim.to_s);
	#puts l_square.inspect;
	#(1..dim).each {|index| puts l_square[index].inspect}
end

column_tally = Array.new(dim) { Array.new(dim){0} };
row_tally = Array.new(dim) { Array.new(dim){0} };

l_square.each_index do |row_i|
	l_square.each_index do |cell_i|
		cell_num = l_square[row_i][cell_i];
		if Debug == 1
			puts "Validating r=" + row_i.to_s + " c=" + cell_i.to_s + " it is.. " + cell_num.to_s;
			puts "Looking up row="+ row_i.to_s + " it is.. " + 	column_tally[row_i].inspect
		end
		
		if (column_tally[row_i][cell_num-1] == 0)
			column_tally[row_i][cell_num-1] = 1;
			if Debug == 1
				puts "Marking r=" + row_i.to_s + " c=" + cell_num.to_s
			end
		else
			if Debug == 1
				puts "Oops r=" + row_i.to_s + " c=" + cell_num.to_s  + " is  already marked";
			end
			return false
		end
		
		if Debug == 1
			puts "Looking up col="+ cell_i.to_s + " it is.. " + row_tally[row_i].inspect
		end
		
		if (row_tally[cell_i][cell_num-1] == 0)
			row_tally[cell_i][cell_num-1] = 1;
			if Debug == 1
				puts "Marking c=" + cell_i.to_s + " c=" + cell_num.to_s
			end
		else
			if Debug == 1
				puts "Oops r=" + cell_i.to_s + " c=" + cell_num.to_s  + " is  already marked";
			end
			return false
		end
	end
end

if column_tally.include?(0) || row_tally.include?(0)
	return false;
else
	return true;
end

#Find dim 
#Make arrays per row and column
#Mark per element in the appropriate row and column
#If already marked fail
#If any unmarked fail
#Else pass
end



##################################################################
#
#
#
##################################################################
def LatinSquareGenerator.Gen_covered_latin_square(dim,percentage, inner_square_flag)
	return Cover_latin_square(Gen_latin_square(dim),percentage)
end



##################################################################
#
#
#
##################################################################
def LatinSquareGenerator.Gen_latin_square(dim, inner_square_flag)

iteration_multiplier = 5;
retry_flag = 1;
retry_count = 0;

	if dim < 2
		dim = 2;
	end
	
	l_square = Array.new(dim) { Array.new(dim){0} };
	c_unused = Array.new(dim) { Array.new(dim){0} };
	inner_square_unused = Array.new(dim) { Array.new(dim){0} };
	
	# Debug
	if Debug == 1
		puts "Debugging"
		l_square.each_index do |row_i|
			l_square[row_i] = (1..dim).to_a;
		end
	end
	
	while retry_flag == 1;
	
		retry_flag = 0;
		c_unused.each_index do |row_i|
			c_unused[row_i] = (1..dim).to_a;
		end
	
		if (Simple_perfect_square(dim) && inner_square_flag)
			inner_square_unused.each_index do |row_i|
				inner_square_unused[row_i] = (1..dim).to_a;
			end
		end
		
		l_square.each_index do |row_i|	
			next_row = Gen_latin_row(dim,c_unused,row_i,inner_square_unused, 
									 inner_square_flag)
			total_iterations = 0;    
			until (next_row.length == dim || 
				   total_iterations > dim*iteration_multiplier)
				next_row = Gen_latin_row(dim,c_unused,row_i,inner_square_unused, 		
										 inner_square_flag) 
				total_iterations = total_iterations + 1;
			end
			if (total_iterations >= dim*iteration_multiplier)
				if Debug == 1
					puts ("Can't find a matching row even after "+ total_iterations.to_s+
					" tries... Restarting");
				end
				retry_flag = 1;
				break;
			end
			l_square[row_i] = next_row;
			if Debug == 1
			   	puts ("Row " + row_i.to_s + " contains " + l_square[row_i].to_s);
			end
		end
		retry_count = retry_count + 1;
	end
		
	if Debug == 1
		puts "Finally found one after " + retry_count.to_s + " tries";
	end
	return l_square
end





##################################################################
#
# Private functions
#
##################################################################
def LatinSquareGenerator.Gen_latin_row(dim, cols_unused, row_i, inner_sq_unused, inner_square_flag)

check_inner_dim_flag = false;
new_latin_row = Array.new(dim){0};
row_unused = Array.new(dim){0};
row_unused = (1..dim).to_a;

	if (Simple_perfect_square(dim) && inner_square_flag)
		inner_dim = Math.sqrt(dim).to_i;
		check_inner_dim_flag = true;
	end

new_latin_row.each_index do |col_i|

  if (check_inner_dim_flag == true)
  	inner_sq_index = GetInnerSquareIndex(row_i,col_i,dim);
  	#puts inner_sq_index;
  	allowed_range = (row_unused&cols_unused[col_i])&inner_sq_unused[inner_sq_index];
  else
  	allowed_range = row_unused&cols_unused[col_i]
  end
  if Debug == 1
     if (check_inner_dim_flag == true)
     	puts ("For row #"+ row_i.to_s + ", allowed range is intersection of " +
     	row_unused.to_s + " and  " + cols_unused[col_i].to_s + " and " +
     	inner_sq_unused[inner_sq_index].to_s + " which is "  + allowed_range.to_s);
     else
     	puts ("For row #"+ row_i.to_s + ", allowed range is intersection of " +
     	row_unused.to_s + " and  " + cols_unused[col_i].to_s + " which is "  +
     	allowed_range.to_s);
     end
  end
  if (allowed_range.length == 0)
  	if Debug == 1
  		puts "Clearing Row"
  	end
    new_latin_row.clear;
    return new_latin_row;
  end
  range_idx = rand(allowed_range.length);
  new_latin_row[col_i] = allowed_range[range_idx];
  row_unused.delete(allowed_range[range_idx]);
end
new_latin_row.each_with_index {|item,index| cols_unused[index].delete(item) };
if (check_inner_dim_flag == true)
	new_latin_row.each_with_index {|item,index| 
  		inner_sq_index = GetInnerSquareIndex(row_i,index,dim);
  		inner_sq_unused[inner_sq_index].delete(item) };
end
return new_latin_row;
end


##################################################################
#
#
#
##################################################################
def LatinSquareGenerator.Cover_latin_square(l_square,percentage)

	if (Debug == 1)
		puts "Covering...";
	end
	
 	if (percentage > 100)
 		percentage =100;
 	elsif percentage < 0
 		percentage = 0;
 	end

	c_square = l_square;

	dim = l_square.length;
	num_cells = dim*dim;
	num_cells_to_cover = (num_cells*percentage/100).round
	
	num_cells_to_cover.times do
		randx = rand(dim);
		randy = rand(dim);
		if Debug == 1
			#puts c_square[randx][randy].to_i;
		end
		while c_square[randx][randy].to_i <= 0
			randx = rand(dim);
 			randy = rand(dim);
 		end
 		c_square[randx][randy]=0;
	end
	
	return c_square;
end



##################################################################
# Helper functions
##################################################################
def LatinSquareGenerator.Print_latin_square(l_square)
	l_square.each_index do |row_i|
		puts l_square[row_i].inspect;
	end
end

def LatinSquareGenerator.Simple_perfect_square(n)
  sqrt = Math.sqrt(n);
  return (sqrt - sqrt.to_i == 0)
end

def LatinSquareGenerator.GetInnerSquareIndex(row_i, col_i, dim)
	inner_dim = Math.sqrt(dim);
	
	row_mult = (row_i/inner_dim).to_i;
	col_index =(col_i/inner_dim).to_i;
	
	return ((row_mult*inner_dim)+col_index).to_i;
	
end

end