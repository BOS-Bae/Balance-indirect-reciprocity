using "Indirect_network.jl"

# Simulation code with functions which are defined above.
using Random

N = 17
n_sample = 30

initial_prob = 0.5
leng = 10

P1 =  collect(range(start=0.1, stop=1.0, length=leng)) # p_idx = 1:leng, so prob = P1[p_idx]
τ_2d_arr = zeros(n_sample, leng)
τ_avg = zeros(leng)
τ_std = zeros(leng)

for n_idx in 1:n_sample
    print("n=", n_idx, "\n")
    
    for p_idx in 1:leng
        prob = P1[p_idx]
        
        e_matrix = zeros(N, N)
        σ_matrix = zeros(N, N)
        
        Edge_list = Any[]
        Triad_list = Any[]

        Opinion_Initialize(σ_matrix, initial_prob, N)
        number_arr = ER_network_gen(e_matrix, prob, N, Edge_list, Triad_list)
        
        num_edge = number_arr[1]
        num_triad = number_arr[2]

        #if n_idx == 1
        #    println(num_edge,"   ", num_triad)
        #end
        τ = 0
        while true
            d = rand(1:N)
            r = rand(1:N)
            if (e_matrix[d,r] == 1)
                τ += 1
                NList = NeighborList(e_matrix,N,d,r)
                L6_rule(σ_matrix, NList, d, r)
            end
        
            if (Check_fixation(σ_matrix, Edge_list, Triad_list, N, num_edge, num_triad) == true)
                break
            end
        end
        τ_2d_arr[n_idx, p_idx] = τ
    end
end

# Get the average from data of n realizations
for i in 1:leng
    for j in 1:n_sample
        τ_avg[i] += τ_2d_arr[j,i]/n_sample
    end
end

for i in 1:leng
    Standard_err = 0
    for j in 1:n_sample
        Standard_err += (τ_2d_arr[j,i] - τ_avg[i])^2 / (n_sample - 1)
    end
    τ_std[i] = sqrt(Standard_err / n_sample)
end

print(τ_avg)
println("")
print(τ_std)