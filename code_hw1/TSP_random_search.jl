using Random
using Plots

# Define the number of cities
num_cities = 10

# Create a dictionary to store the cities
cities = Dict{String, Tuple{Float64, Float64}}()

# Generate and populate the dictionary with random points
for i in 1:num_cities
    city_name = "City$i"
    x = rand() * 100  # Adjust the range of x-coordinate as needed
    y = rand() * 100  # Adjust the range of y-coordinate as needed
    cities[city_name] = (x, y)
end

# Function to calculate the total distance of a route
function calculate_distance(route, cities)
    total_distance = 0.0
    for i in 1:length(route) - 1
        city1 = route[i]
        city2 = route[i + 1]
        total_distance += sqrt((cities[city1][1] - cities[city2][1])^2 + (cities[city1][2] - cities[city2][2])^2)
    end
    return total_distance
end

# Randomly shuffle the order of cities to create an initial random route
cities_list = collect(keys(cities))
shuffle!(cities_list)

# Initialize the best route and best distance
best_route = copy(cities_list)
best_distance = calculate_distance(cities_list, cities)

# Number of iterations for the random search
num_iterations = 1000000

# Arrays to store the best distances and corresponding iteration numbers
best_distances = Float64[]
iteration_numbers = Int[]

# Random Search algorithm
for i in 1:num_iterations
    # Generate a random neighbor by swapping two random cities
    neighbor_route = copy(best_route)
    city1, city2 = randperm(length(neighbor_route))[1:2]
    neighbor_route[city1], neighbor_route[city2] = neighbor_route[city2], neighbor_route[city1]
    
    # Calculate the distance of the neighbor route
    neighbor_distance = calculate_distance(neighbor_route, cities)
    
    # If the neighbor route is shorter, accept it as the new best route
    if neighbor_distance < best_distance
        global best_route = copy(neighbor_route)  # Use global to modify the global variable
        global best_distance = neighbor_distance
    end
    
    # Store the best distance and iteration number for plotting
    push!(best_distances, best_distance)
    push!(iteration_numbers, i)
end

# Add the starting city to complete the cycle
push!(best_route, best_route[1])

# Plot the best distance as a function of iterations
plot(iteration_numbers, best_distances, xlabel="Iterations", ylabel="Best Distance", legend=false)
title!("TSP Random Search")
savefig("/Users/jamespan/OneDrive - Columbia University/Columbia/2023 Fall/MECS4510/HW1/code_hw1/TSP_random_search.png")