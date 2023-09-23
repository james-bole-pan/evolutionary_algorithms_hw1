using Random
using Plots

function distance(city1, city2)
    return sqrt((city1[1] - city2[1])^2 + (city1[2] - city2[2])^2)
end

# we define the fitness of a route as the inverse of its length
function fitness(route)
    route_length = sum(distance(route[i], route[i+1]) for i in 1:length(route)-1)
    route_length += distance(route[length(route)], route[1])
    return 1 / route_length
end

# we define mutation as the random swapping of two cities in a route
function mutate(route, mutation_rate=0.01)
    for i in 1:length(route)
        if rand() < mutation_rate
            j = rand(1:length(route))
            city1, city2 = route[i], route[j]
            route[i], route[j] = city2, city1
        end
    end
    return route
end

# we use ordered crossover to create a child from two parents
function crossover(parent1, parent2)
    
    idx1, idx2 = sort(rand(1:length(parent1), 2))
    subset_parent1 = parent1[idx1:idx2]

    offspring = [(-1.0,-1.0) for _ in 1:length(parent1)]
    offspring[idx1:idx2] = subset_parent1

    j = 1
    for i in 1:length(parent1)
        if i < idx1 || i > idx2
            while parent2[j] in subset_parent1
                j += 1
            end
            offspring[i] = parent2[j]
            j += 1
        end
    end
    return offspring
end

function roulette_selection(population, selection_rate=0.5, mutation_rate=0.01)
    total_fitness = sum(fitness.(population))
    selected = []
    # Select out 50% of the population using roulette wheel selection
    while length(selected) < length(population) * selection_rate
        accumulator = 0.0
        random_val = rand() * total_fitness
        for individual in population
            accumulator += fitness(individual)
            if accumulator > random_val
                push!(selected, individual)
                break
            end
        end
    end
    # Create a new generation by breeding the selected individuals
    new_population = copy(selected)
    while length(new_population) < length(population)
        parent1, parent2 = rand(selected), rand(selected)
        child = crossover(parent1, parent2)
        push!(new_population, mutate(child, mutation_rate))
    end

    return new_population
end


function genetic_algorithm(coordinates, generations, population_size = 1000, selection_rate=0.5, mutation_rate=0.01)
    population = [shuffle(coordinates) for _ in 1:length(coordinates)] # initialize the population
    fitness_history = []
    for _ in 1:generations
        population = roulette_selection(population, selection_rate, mutation_rate)
        push!(fitness_history, fitness(population[1]))
    end
    return population[1], fitness_history
end

function random_search(coordinates, generations)
    route = shuffle(copy(coordinates))
    best_fitness = fitness(route)
    best_route = copy(route)
    fitness_history = []
    for _ in 1:generations
        shuffle!(route)
        if fitness(route) > best_fitness
            best_fitness = fitness(route)
            best_route = copy(route)
        end
        push!(fitness_history, best_fitness)
    end
    return best_route, fitness_history
end

function random_mutation_hill_climbing(coordinates, generations, mutation_rate=0.01)
    route = shuffle(copy(coordinates))
    best_fitness = fitness(route)
    best_route = copy(route)
    fitness_history = []
    for _ in 1:generations
        mutated_route = mutate(copy(route), mutation_rate)
        if fitness(mutated_route) > best_fitness
            best_fitness = fitness(mutated_route)
            best_route = copy(mutated_route)
        end
        push!(fitness_history, best_fitness)
    end
    return best_route, fitness_history
end
