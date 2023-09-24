using Statistics

# Convert nested arrays to a 2D array (matrix)
a = [1 2 3; 4 5 6; 7 8 9]
println("a: ", a)
println("typeof(a): ", typeof(a))

# Calculate the std of each column
std_vals = std(a, dims=1)
mean_vals = mean(a, dims=1)
println("std: ", std_vals)
println("mean: ", mean_vals)
