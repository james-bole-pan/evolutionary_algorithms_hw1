using Test
include("TSP_genetic_algorithm_methods.jl")

@testset "Test distance" begin
    city1 = (0, 3)
    city2 = (4, 0)  # Change square brackets to parentheses
    @test distance(city1, city2) ≈ 5.0

    #write more tests here
    city3 = (1.1, 2.2)  # Change square brackets to parentheses
    city4 = (4.1, 6.2)  # Change square brackets to parentheses
    @test distance(city3, city4) ≈ 5.0
end

@testset "Test fitness" begin
    route = [(0, 0), (0, 1), (1, 1), (1, 0)]  # Change square brackets to parentheses
    @test fitness(route) ≈ 1/4

    #write more tests here
    route2 = [(0, 0), (0, 1), (1, 1), (1, 0), (0, 0)]  # Change square brackets to parentheses
    @test fitness(route2) ≈ 1/4
end

@testset "Test mutate" begin
    route = [(5, 6), (7, 8), (1, 2), (3, 4)]
    initial_route = copy(route)
    mutated_route = mutate(route, 0.0)
    @test mutated_route == initial_route

    #write more tests here
    mutated_route2 = mutate(route, 1.0)
    @test mutated_route2 != initial_route
end

@testset "Test crossover" begin
    parent1 = [(0, 0), (0, 1), (1, 1), (1, 0)]  # Change square brackets to parentheses
    parent2 = [(1, 0), (1, 1), (0, 0), (0, 1)]  # Change square brackets to parentheses
    child = crossover(parent1, parent2)
    @test length(child) == length(parent1)
    @test sort(child) == sort(parent1)

    parent1 = [(1, 2), (3, 4), (5, 6), (7, 8)]  # Change square brackets to parentheses
    parent2 = [(5, 6), (7, 8), (1, 2), (3, 4)]  # Change square brackets to parentheses
    child = crossover(parent1, parent2)
    @test length(child) == length(parent1)
    @test sort(child) == sort(parent1)

    parent1 = [(8, 7), (6, 5), (4, 3), (2, 1)]  # Change square brackets to parentheses
    parent2 = [(2, 1), (4, 3), (6, 5), (8, 7)]  # Change square brackets to parentheses
    child = crossover(parent1, parent2)
    @test length(child) == length(parent1)
    @test sort(child) == sort(parent1)
end

@testset "Test roulette selection" begin
    population = [[(0,1),(0,-1),(1,0),(-1,0)],[(0,1),(0,-1),(1,0),(-1,0)]]
    new_population = roulette_selection(population, 0.5, 1)
    @test length(new_population) == length(population)

end

@testset "Test determine maximum_fitness" begin
    population = [[(0,1),(0,-1),(1,0),(-1,0)],[(0,1),(0,-1),(1,0),(-1,0)]]
    best_worker, overall_best_route, maximum_fitness = determine_maximum_fitness(population)
    @test best_worker == 1
    @test overall_best_route == [(0,1),(0,-1),(1,0),(-1,0)]
    @test maximum_fitness == 1/4
end