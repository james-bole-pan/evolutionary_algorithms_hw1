using Plots
begin
    coordinates = []
    open("code_hw1/tsp_10.txt") do file
        for line in eachline(file)
            x, y = split(line, ',')
            push!(coordinates, (parse(Float64, x), parse(Float64, y)))
        end
    end
end

println(coordinates)
