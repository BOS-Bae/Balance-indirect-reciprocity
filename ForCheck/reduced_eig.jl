using LinearAlgebra

multiplication = false
if (length(ARGS) < 3)
    print("usage : N ϵ MCS \n")
    exit(1)
end

N = parse(Int64, ARGS[1])
ϵ = parse(Float64, ARGS[2])
MCS = parse(Int64, ARGS[3])

function L6_rule(O_matrix, α, d, r)
    val = O_matrix[α,r] * O_matrix[d,r]
    return val
end

function Build_Basis_N(mat_arr, basis_σ, σ_tot)
    for mat in mat_arr
        sum_mat = sum(mat)
        if (sum_mat == σ_tot)
            push!(basis_σ, mat)
        end
    end
end

#function L4_rule(O_matrix, α, d, r)
#    val = 0
#    if (O_matrix[d,r] == 1)
#        if (O_matrix[α,d] == -1)
#            val = O_matrix[α,r]
#        end
#    elseif (O_matrix[d,r] == -1)
#        val = -O_matrix[α,r]
#    end
#    return val
#end

function generate_config_matrix(N::Int64)
    num_edge = ((N * (N - 1)) ÷ 2)
    num_matrices = 2^num_edge
    matrices = Array{Int}[]
    
    for index in 0:num_matrices-1
        matrix = zeros(Int64, N, N)
        temp_index = index
        
        for row in 1:N, col in row:N
            if row != col
                bit = temp_index & 1
                tmp_unit = bit == 0 ? 1 : -1
                matrix[row, col] = tmp_unit
                matrix[col, row] = tmp_unit
                temp_index >>= 1
            end
        end
        
        push!(matrices, matrix)
    end
    
    return matrices
end

n_edge = (N * (N-1) ÷ 2)
sum_σ_arr = range(-2*n_edge, 2*n_edge, step=2)
arr_leng = length(sum_σ_arr)

n_mat = 2^n_edge

M_eig = zeros(Float64, arr_leng, arr_leng)

matrices = generate_config_matrix(N)
#for i in 1:n_mat
#    println(matrices[i])
#end

for i in 1:n_mat
    for x in 1:N
        for y in 1:N
            if (x != y)
                tmp = matrices[i][x,y]
                sum_σ_i = sum(matrices[i])
                i_idx = findfirst(sum_σ_arr .== sum_σ_i)

                matrices[i][x,y] *= -1
                matrices[i][y,x] = matrices[i][x,y]
                idx = 0
                for j in 1:n_mat
                    if ((matrices[j] == matrices[i]) && (i != j))
                        sum_σ_j = sum(matrices[j])
                        j_idx = findfirst(sum_σ_arr .== sum_σ_j)
                        M_eig[j_idx, i_idx] += (1/6)*ϵ
                    end
                end
                matrices[i][x,y] = tmp
                matrices[i][y,x] = matrices[i][x,y]
                for k in 1:N
                    if (k != x && k != y)
                        tmp = matrices[i][k,x]
                        #if (i==64) println("k=",k," ,val=",matrices[i][k,x]) end
                        matrices[i][k,x] = L6_rule(matrices[i], k, x, y)
                        matrices[i][x,k] = matrices[i][k,x]

                        #if (i==64) println("k=",k," ,val=",matrices[i][k,x]) end
                        for j in 1:n_mat
                            if ((matrices[j] == matrices[i]) && (i != j))
                                sum_σ_j = sum(matrices[j])
                                j_idx = findfirst(sum_σ_arr .== sum_σ_j)
                                M_eig[j_idx, i_idx] += (1-ϵ)*(factorial(N-3)/factorial(N))
                            elseif ((matrices[i][k,x] == tmp) && (i == j))
                                M_eig[i_idx, i_idx] += (1-ϵ)*(factorial(N-3)/factorial(N))
                            end
                        end
                        matrices[i][k,x] = tmp
                        matrices[i][x,k] = matrices[i][k,x]
                    end
                end
            end
        end
    end
end

n=1
if (multiplication)
    for i in 1:n
        ran_vec = rand(Float64, arr_leng)
        #ran_vec = zeros(Float64, arr_leng)
        #ran_vec[2] = 1
        ran_vec /= sum(ran_vec)

        println(ran_vec)
        println("")
        for t in 1:MCS
            ran_vec = M_eig * ran_vec
            ran_vec /= sum(ran_vec)
        end

        println("")
        for i in 1:arr_leng
            if (ran_vec[i] > 0.0001)
                print(ran_vec[i], " ")
            else
                print("x", " ")
            end
        end
        println("")
        #println(maximum(ran_vec))

        #idx = findall(ran_vec .== maximum(ran_vec))
        #println(matrices[idx])

    end
else
    #println(M_eig)
    R_arr = zeros(Float64, arr_leng)
    E_arr = eigvals(M_eig)
    for r in 1:arr_leng
        R_arr[r] = real(E_arr[r])
    end

    largest_eig_arr = findall(R_arr .== maximum(R_arr))
    print("largest eigen value = ",  maximum(R_arr), "\n")

    Eig_Vec = eigvecs(M_eig)

    arr = zeros(Float64, arr_leng)
    eig_conf_arr = []
    for eigvec_idx in largest_eig_arr
        println("Eigenvector idx : ", eigvec_idx)
        for j in 1:arr_leng
            arr[j] = Eig_Vec[:,eigvec_idx][j]
        end
        idx = findall(abs.(arr) .== maximum(abs.(arr)))
        println("sum of σ = ", sum_σ_arr[idx])
        println("Eigenvector[σ_idx] = ", arr[idx])
        println("")
        push!(eig_conf_arr, idx)
        println(arr)
        print("\n")
    end
    for σ in sum_σ_arr
        if (σ != arr_leng-1)
            print(σ, ", ")
        else
            print(σ, "\n")
        end
    end
    #println("")
    #for conf in eig_conf_arr
    #    println(matrices[conf]) 
    #end
end
