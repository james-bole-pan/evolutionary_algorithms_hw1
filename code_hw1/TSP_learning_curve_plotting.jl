
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

generation = 100
random_search_best_fitness_history_four_workers = []

for p in workers()
    print("p: ", p, "\n")
    rs_best_route, rs_fitness_history = fetch(@spawnat p random_search(coordinates, generation))
    println("typeof", typeof(rs_fitness_history))
    push!(random_search_best_fitness_history_four_workers, rs_fitness_history)
end
rmprocs(workers())

#convert the array of arrays to print
println("random_search_best_fitness_history_four_workers: ", random_search_best_fitness_history_four_workers)
println("Type of random_search_best_fitness_history_four_workers: ", typeof(random_search_best_fitness_history_four_workers))
# average_rs_fitness_history = mean(random_search_best_fitness_history_four_workers, dims=1)
# println("average_rs_fitness_history: ", average_rs_fitness_history)
# error_rs_fitness_history = std(random_search_best_fitness_history_four_workers, dims=1)
# println("error_rs_fitness_history: ", error_rs_fitness_history)
# error_indices = 1:10:generation
# x_values = 1:generations
# error_bar_positions = generations[error_indices]
# x_offsets = 0.1
# plot(x_values, average_rs_fitness_history, ribbon=error_rs_fitness_history, legend=false, xlabel="Generation", ylabel="Fitness")
# scatter!(error_bar_positions .+ x_offsets, average_rs_fitness_history[error_indices], label="Mean", legend=true)
