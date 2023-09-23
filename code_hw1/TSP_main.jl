include("TSP_genetic_algorithm_methods.jl")

# Test case with 100 points in a circle
num_points = 10
radius = 1.0
angle_increment = 2π / num_points
points_on_circle = [(radius * cos(i * angle_increment), radius * sin(i * angle_increment)) for i in 1:num_points]

generations = 100
(best_route, fitness_history) = random_search(points_on_circle, generations)

route_x_coords = [coord[1] for coord in best_route]
route_y_coords = [coord[2] for coord in best_route]

# Add the first point to the end of the route to complete the loop
route_x_coords = vcat(route_x_coords, route_x_coords[1])
route_y_coords = vcat(route_y_coords, route_y_coords[1])

plot1 = scatter([x for (x, y) in points_on_circle], [y for (x, y) in points_on_circle], seriestype=:scatter, aspect_ratio=:equal, legend=false)
plot!(route_x_coords, route_y_coords, linewidth=2, label="Route")

plot2 = plot(1:generations, fitness_history, label="Fitness vs. Generation", xlabel="Generation", ylabel="Fitness", ylim=(0, 0.2), legend=true)
# make plot2's fitness only show from 0 to 0.2
plot(plot1, plot2, layout=(1, 2))  # 1 row and 2 columns
