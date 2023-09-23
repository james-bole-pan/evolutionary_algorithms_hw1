using Plots

# Sample data: Replace with your own data
num_points = 10
radius = 1.0
angle_increment = 2π / num_points
points_on_circle = [(radius * cos(i * angle_increment), radius * sin(i * angle_increment)) for i in 1:num_points]

# Example route as a list of coordinates (replace with your own route)
route_coordinates = [(0.5, 0.5), (0.3, 0.7), (0.1, 0.4), (0.8, 0.2)]

# Extract x and y coordinates of the route
route_x_coords = [coord[1] for coord in route_coordinates]
route_y_coords = [coord[2] for coord in route_coordinates]

# Create a scatter plot for the points
scatter([x for (x, y) in points_on_circle], [y for (x, y) in points_on_circle], seriestype=:scatter, aspect_ratio=:equal, legend=false)

# Plot the route on top of the points
plot!(route_x_coords, route_y_coords, linewidth=2, label="Route")