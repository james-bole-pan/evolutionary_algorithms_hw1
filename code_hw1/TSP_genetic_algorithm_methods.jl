using Random

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

function roulette_selection(population, selection_rate=0.1)
    total_fitness = sum(fitness.(population))
    selected = []

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
    return selected
end

function breed(selected, population_size, mutation_rate = 0.01)
    # Create a new generation by breeding the selected individuals
    new_population = copy(selected)
    while length(new_population) < population_size
        parent1, parent2 = rand(selected), rand(selected)
        child = crossover(parent1, parent2)
        push!(new_population, mutate(child, mutation_rate))
    end
    return new_population
end

# a helper method for the genetic algorithm
function determine_maximum_fitness(population)
    maximum_fitness = 0.0
    best_route = population[1]
    best_individual_index = 1
    i=1
    for individual in population
        fitness_value = fitness(individual)
        if fitness_value > maximum_fitness
            maximum_fitness = fitness_value
            best_route = individual
            best_individual_index = i
        end
        i += 1
    end
    return best_individual_index, best_route, maximum_fitness
end

function genetic_algorithm(coordinates, generations, population_size = 10, selection_rate=0.5, mutation_rate=0.01)
    population = [shuffle(coordinates) for _ in 1:population_size] # initialize the population
    best_route = population[1]
    best_fitness = fitness(best_route)
    best_index = 1
    fitness_history = []
    for index in 1:generations
        selected = roulette_selection(population, selection_rate)
        population = breed(selected, population_size, mutation_rate)
        _, population_best_route, population_best_fitness = determine_maximum_fitness(population)
        if population_best_fitness > best_fitness
            best_route = population_best_route
            best_fitness = population_best_fitness
            best_index = index
        end
        push!(fitness_history, best_fitness)
    end
    return best_index, best_route, fitness_history
end

function random_search(coordinates, generations)
    route = shuffle(copy(coordinates))
    best_fitness = fitness(route)
    best_route = copy(route)
    fitness_history = Float64[]
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
