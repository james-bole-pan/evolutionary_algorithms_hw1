using Plots
using Statistics
using Distributed
number_of_workers = 4
addprocs(number_of_workers)

@everywhere include("TSP_genetic_algorithm_methods.jl")

# import the data from tsp_10.txt
@everywhere begin
    coordinates = []
    open("code_hw1/tsp_10.txt") do file
        for line in eachline(file)
            x, y = split(line, ',')
            push!(coordinates, (parse(Float64, x), parse(Float64, y)))
        end
    end
end

generation = 1000
rs_best_fitness_history_four_workers = []
rmch_best_fitness_history_four_workers = []
ga_best_fitness_history_four_workers = []

for p in workers()
    print("p: ", p, "\n")
    rs_best_route, rs_fitness_history = fetch(@spawnat p random_search(coordinates, generation))
    rmch_best_route, rmch_fitness_history = fetch(@spawnat p random_mutation_hill_climbing(coordinates, generation))
    ga_best_route, ga_fitness_history = fetch(@spawnat p genetic_algorithm(coordinates, generation))
    push!(rs_best_fitness_history_four_workers, rs_fitness_history)
    push!(rmch_best_fitness_history_four_workers, rmch_fitness_history)
    push!(ga_best_fitness_history_four_workers, ga_fitness_history)
end
rmprocs(workers())

rs_best_fitness_history_four_workers = (hcat(rs_best_fitness_history_four_workers...))'
average_rs_fitness_history = reshape(mean(rs_best_fitness_history_four_workers, dims=1),(generation,))
error_rs_fitness_history = reshape(std(rs_best_fitness_history_four_workers, dims=1)/sqrt(number_of_workers),(generation,))

rmch_best_fitness_history_four_workers = (hcat(rmch_best_fitness_history_four_workers...))'
average_rmch_fitness_history = reshape(mean(rmch_best_fitness_history_four_workers, dims=1),(generation,))
error_rmch_fitness_history = reshape(std(rmch_best_fitness_history_four_workers, dims=1)/sqrt(number_of_workers),(generation,))

ga_best_fitness_history_four_workers = (hcat(ga_best_fitness_history_four_workers...))'
average_ga_fitness_history = reshape(mean(ga_best_fitness_history_four_workers, dims=1),(generation,))
error_ga_fitness_history = reshape(std(ga_best_fitness_history_four_workers, dims=1)/sqrt(number_of_workers),(generation,))

x_values = collect(1:generation)

# error_indices = collect(1:10000:generation)
# sampled_error_bars = [i in error_indices ? error_rs_fitness_history[i] : 0 for i in 1:generation]

plot(x_values, average_rs_fitness_history, ribbon=error_rs_fitness_history, legend=true, xlabel="Generation", ylabel="Fitness", label = "Random Search")
plot!(x_values, average_rmch_fitness_history, ribbon= error_rmch_fitness_history, legend=true, label = "Random Mutation Hill Climbing")
plot!(x_values, average_ga_fitness_history, ribbon= error_ga_fitness_history, legend=true, label = "Genetic Algorithm")