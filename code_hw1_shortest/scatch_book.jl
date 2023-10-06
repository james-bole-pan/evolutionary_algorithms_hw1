using Distributed

# Function to calculate sum of first n integers
function calculate_sum(n)
    return sum(1:n)
end

# Add worker processes for parallel computing
addprocs(4)

@everywhere begin
    # The function needs to be defined on all processes
    function calculate_sum(n)
        return sum(1:n)
    end
end

# Without parallel computing
function serial_sum(n_values)
    return [calculate_sum(n) for n in n_values]
end

# With parallel computing
function parallel_sum(n_values)
    return pmap(calculate_sum, n_values)
end

# List of n values
n_values = [10^6, 10^7, 10^8, 10^9,10^6, 10^7, 10^8, 10^9,10^6, 10^7, 10^8, 10^9,10^6, 10^7, 10^8, 10^9]

# Time serial execution
println("Serial execution:")
@time serial_results = serial_sum(n_values)

# Time parallel execution
println("\nParallel execution:")
@time parallel_results = parallel_sum(n_values)

# Check if results are the same
println("\nAre the serial and parallel results the same? ", all(serial_results .== parallel_results))