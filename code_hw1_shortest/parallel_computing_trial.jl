using Distributed
number_of_workers = 10
addprocs(number_of_workers)

w = workers()

@time for i in 2:nprocs()
    sleep(1)
end

@time @sync for i in 1:(number_of_workers)
    @spawnat w[i] sleep(1)
end

rmprocs(workers())