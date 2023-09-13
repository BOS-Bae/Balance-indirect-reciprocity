using LinearAlgebra

multiplication = false
eig = false

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


function L4_rule(O_matrix, α, d, r)
    val = O_matrix[α,d]
    if (O_matrix[d,r] == 1)
        if (O_matrix[α,d] == -1)
            val = O_matrix[α,r]
        end
    elseif (O_matrix[d,r] == -1)
        val = -O_matrix[α,r]
    end
    return val
end

function generate_config_matrix(N::Int64)
    num_matrices = 2^(N * (N - 1))
    matrices = Array{Int}[]
    
    for index in 0:num_matrices-1
        matrix = zeros(Int64, N, N)
        temp_index = index
        
        for row in 1:N, col in 1:N
            if row != col
                bit = temp_index & 1
                tmp_unit = bit == 0 ? 1 : -1
                matrix[row, col] = tmp_unit
                temp_index >>= 1
            end
        end
        
        push!(matrices, matrix)
    end
    
    return matrices
end

n_mat = 2^(N * (N - 1))

M_eig = zeros(Float64, n_mat, n_mat)

matrices = generate_config_matrix(N)
#for i in 1:n_mat
#    println(matrices[i])
#end

for i in 1:n_mat
    for x in 1:N
        for y in 1:N
            if (x != y)
                tmp = matrices[i][x,y]
                matrices[i][x,y] *= -1
                idx = 0
                for j in 1:n_mat
                    if ((matrices[j] == matrices[i]) && (i != j))
                        M_eig[j,i] += (1/12)*ϵ
                    end
                end
                matrices[i][x,y] = tmp
                for k in 1:N
                    if (k != x && k != y)
                        tmp = matrices[i][k,x]
                        matrices[i][k,x] = L4_rule(matrices[i], k, x, y)

                        for j in 1:n_mat
                            if ((matrices[j] == matrices[i]) && (i != j))
                                M_eig[j,i] += (1-ϵ)*(factorial(N-3)/factorial(N))
                            elseif ((matrices[i][k,x] == tmp) && (i == j))
                                M_eig[i,i] += (1-ϵ)*(factorial(N-3)/factorial(N))
                            end
                        end
                        matrices[i][k,x] = tmp
                    end
                end
            end
        end
    end
end


#for i in 1:n_mat
#    println(ran_mat[:,i])
#end
#println("")


n=1
if (multiplication)
    for i in 1:n
        #ran_vec = rand(Float64, n_mat)
        
        #ran_vec = rand(Float64, n_mat)
        ran_vec = zeros(Float64, n_mat)
        ran_vec[2] = 1
        ran_vec /= sum(ran_vec)

        println(ran_vec)
        println("")
        for t in 1:MCS
            ran_vec = M_eig * ran_vec
            ran_vec /= sum(ran_vec)
        end

        println("")
        for i in 1:n_mat
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
elseif (eig)
    #println(M_eig)
    R_arr = zeros(Float64, n_mat)
    E_arr = eigvals(M_eig)
    for r in 1:n_mat
        R_arr[r] = real(E_arr[r])
    end

    largest_eig_arr = findall(R_arr .== maximum(R_arr))
    print("largest eigen value = ",  maximum(R_arr), "\n")

    Eig_Vec = eigvecs(M_eig)

    arr = zeros(Float64, n_mat)
    eig_conf_arr = []
    for eigvec_idx in largest_eig_arr
        println("Eigenvector idx : ", eigvec_idx)
        for j in 1:n_mat
            arr[j] = Eig_Vec[:,eigvec_idx][j]
        end
        idx = findall(arr .== maximum(arr))
        println("configuration idx = ", idx)
        push!(eig_conf_arr, idx)
        println(arr)

        if (ϵ != 0)
            for i in 1:n_mat
                if (abs(arr[i]) > 0.05)
                    println(i," ",matrices[i])
                end
            end
        end
        print("\n")
        print("\n")
    end
    for conf in eig_conf_arr
        println(matrices[conf]) 
    end
else
    for i in 1:n_mat
        M_eig[i,i] = 0
    end
    path_idx = findall(M_eig .== maximum(M_eig))
    println(path_idx)
end
