using Plots
include("TSP_genetic_algorithm_methods.jl")

# Test case with 100 points in a circle
num_points = 100
radius = 1000
angle_increment = 2π / num_points
points_on_circle = [(radius * cos(i * angle_increment), radius * sin(i * angle_increment)) for i in 1:num_points]

#write to a txt the points
open("circle_100.txt", "w") do io
    for (x, y) in points_on_circle
        println(io, "$x, $y")
    end
end

scatter([x for (x, y) in points_on_circle], [y for (x, y) in points_on_circle], markersize = 1, aspect_ratio=:equal, legend=false)