# Simulation code for plotting fixation time
include("../Indirect_network.jl")
using Random

if (length(ARGS) < 3)
    print("usage : ϵ n_check t_avg \n")
    exit(1)
end
#N_f = parse(Int64, ARGS[1])
#N_arr = 4:N_f
N=4
ϵ = parse(Float64, ARGS[1])
n_check = parse(Int64, ARGS[2])
t_avg = parse(Int64, ARGS[3])
t_f = n_check*t_avg

initial_prob = 0.5

balanced_list = []
push!(balanced_list, [[1,1,1,1],[1,1,1,1],[1,1,1,1],[1,1,1,1]])
push!(balanced_list, [[1,-1,-1,-1],[-1,1,1,1],[-1,1,1,1],[-1,1,1,1]])
push!(balanced_list, [[1,-1,1,1],[-1,1,-1,-1],[1,-1,1,1],[1,-1,1,1]])
push!(balanced_list, [[1,1,-1,1],[1,1,-1,1],[-1,-1,1,-1],[1,1,-1,1]])
push!(balanced_list, [[1,1,1,-1],[1,1,1,-1],[1,1,1,-1],[-1,-1,-1,1]])
push!(balanced_list, [[1,1,-1,-1],[1,1,-1,-1],[-1,-1,1,1],[-1,-1,1,1]])
push!(balanced_list, [[1,-1,1,-1],[-1,1,-1,1],[1,-1,1,-1],[-1,1,-1,1]])
push!(balanced_list, [[1,-1,-1,1],[-1,1,1,-1],[-1,1,1,-1],[1,-1,-1,1]])
#if (N==4) σ_distri = [-2,0,6] end

σ_distri = zeros(8,t_avg)
σ_check = zeros(8,t_avg)
σ_result = zeros(8,n_check)

prob = 1.0 # for complete graph, p=1.0
e_matrix = zeros(N, N)
σ_matrix = zeros(N, N)
U_matrix = zeros(N, N) # Additional matrix for update by new method, 'New_matrix' of 'L6_rule_dr_all'.
Edge_list = Any[]
Triad_list = Any[]
Opinion_Initialize(σ_matrix, initial_prob, N)
number_arr = ER_network_gen(e_matrix, prob, N, Edge_list, Triad_list)
num_edge = number_arr[1]
num_triad = number_arr[2]
#if n_idx == 1
#    println(num_edge,"   ", num_triad)
#end
τ = τ_tmp = t = 0
n_count = 0
while(true)
    global τ, t, τ_tmp, n_count
    τ_tmp = original_update(L4_rule, σ_matrix, e_matrix, N, τ, ϵ)
    # For random sequential update, use the function below :
    #τ_tmp = random_sequential_update(L4_rule, σ_matrix, e_matrix, Edge_list, τ, ϵ)
    τ = τ_tmp
    if (Check_fixation(σ_matrix, Edge_list, Triad_list, N, num_edge, num_triad) == true)
        t += 1
        for b in 1:8
            count = 0
            check = 0
            for x in 1:N
                for y in 1:N
                    count += 1
                    if (balanced_list[b][x][y] == σ_matrix[x,y])
                        check += 1
                    end
                end
            end
            if ((count == check) && ((t % t_avg) != 0))
                σ_distri[b, t % t_avg] = 1
            end
        end
        if ((t < t_f) && (t % t_avg == 0))
            n_count += 1
            σ_check[:,:] = σ_distri[:,:]
            σ_distri .= 0
            for b in 1:8
                σ_result[b, n_count] = sum(σ_check[b,:])/t_avg
            end
        end
    end
    if (t == t_f)
        break
    end
end

for n in 1:n_check-1
    for b in 1:8
        print(σ_result[b, n], "  ")
    #println(N," ", σ_distri[b])
    end
    print("\n")
end
println("sum : ", sum(σ_result[:,n_check-1]))