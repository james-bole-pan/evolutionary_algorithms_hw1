using Random
using Statistics
using Plots

coordinates = []
open("cities.txt") do file
    for line in eachline(file)
        x, y = split(line, ',')
        push!(coordinates, (parse(Float64, x), parse(Float64, y)))
    end
end

function distance(city1, city2)
    return sqrt((city1[1] - city2[1])^2 + (city1[2] - city2[2])^2)
end

# we define the fitness of a route its total length
function fitness(route)
    route_length = sum(distance(route[i], route[i+1]) for i in 1:length(route)-1)
    route_length += distance(route[length(route)], route[1])
    return route_length
end

generations = 100000

function random_search(coordinates, generations)
    route = shuffle(copy(coordinates))
    best_fitness = fitness(route)
    best_route = copy(route)
    fitness_history = Float64[]
    for index in 1:generations
        shuffle!(route)
        if fitness(route) < best_fitness
            best_fitness = fitness(route)
            best_route = copy(route)
            plot([best_route[i][1] for i in 1:length(best_route)], [best_route[i][2] for i in 1:length(best_route)], label="best route_$(index); length = $(best_fitness)", title="Random Search")
            scatter!([best_route[i][1] for i in 1:length(best_route)], [best_route[i][2] for i in 1:length(best_route)],label="")
            savefig("movie/random_search_$(index).png")
        end
        #plot the best route
        push!(fitness_history, best_fitness)
    end
    return best_route, fitness_history
end

best_route, fitness_history = random_search(coordinates, generations)
plot(fitness_history, legend=false, xlabel="Generation", ylabel="Fitness", dpi=300, size=(600, 400), title="Random Search")