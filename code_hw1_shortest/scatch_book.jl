# Initialize sum
global sum_val = 0

# Record the time taken to compute the sum
elapsed_time = @elapsed begin
    for i in 1:100000000
        global sum_val += i
    end
end

println("The time difference without distributed: ", elapsed_time)
println("The sum is: ", sum_val)

# generate a movie from the png files
run(`ffmpeg -framerate 10 -i movie/random_search_%d.png -c:v libx264 -r 30 -pix_fmt yuv420p movie/random_search.mp4`)
