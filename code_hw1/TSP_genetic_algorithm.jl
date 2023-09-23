using Random

function distance(city1, city2)
    return sqrt((city1[1] - city2[1])^2 + (city1[2] - city2[2])^2)
end

function fitness(route)
    route_length = sum(distance(route[i], route[i+1]) for i in 1:length(route)-1)
    route_length += distance(route[length(route)], route[1])
    return 1 / route_length
end

# create a list of 10 random cities
cities = [(rand(1:10), rand(1:10)) for i in 1:3]
route = cities[shuffle(1:length(cities))]
println("Route: ", route)
println("Fitness of route: ", fitness(route))