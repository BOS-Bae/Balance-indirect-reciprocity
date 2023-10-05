using LinearAlgebra

multiplication = false
if (length(ARGS) < 4)
    print("usage : N ϵ MCS σ_total \n")
    exit(1)
end

N = parse(Int64, ARGS[1])
ϵ = parse(Float64, ARGS[2])
MCS = parse(Int64, ARGS[3])
σ_total = parse(Int64, ARGS[4])

function L6_rule(O_matrix, α, d, r)
    val = O_matrix[α,r] * O_matrix[d,r]
    return val
end

function Build_Basis_σ(mat_arr, basis_σ, σ_tot)
    for mat in mat_arr
        sum_mat = sum(mat)
        if (sum_mat == σ_tot)
            push!(basis_σ, mat)
        end
    end
end

function Build_M_σ(matrices, n_matrix, M_eig, M_σ, basis_σ)
    leng = length(basis_σ)
    row = col = 0
    for m in 1:leng
        for mat_idx in 1:n_matrix
            if (matrices[mat_idx] == basis_σ[m])
                row = mat_idx
            end
        end
        for n in 1:leng
            for mat_idx in 1:n_matrix
                if (matrices[mat_idx] == basis_σ[n])
                    col = mat_idx
                end
            end
            M_σ[m,n] = M_eig[row,col]
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
leng_Basis = length(sum_σ_arr)

n_mat = 2^n_edge

M_eig = zeros(Float64, n_mat, n_mat)

matrices = generate_config_matrix(N)
basis_σ = Array{Int}[]
Build_Basis_σ(matrices, basis_σ, σ_total)
leng_Basis = length(basis_σ)

#for i in 1:n_mat
#    println(matrices[i])
#end
for i in 1:n_mat
    for x in 1:N
        for y in 1:N
            if (x != y)
                tmp = matrices[i][x,y]
                matrices[i][x,y] *= -1
                matrices[i][y,x] = matrices[i][x,y]
                idx = 0
                for j in 1:n_mat
                    if ((matrices[j] == matrices[i]) && (i != j))
                        M_eig[j,i] += (1/6)*ϵ
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
                                M_eig[j,i] += (1-ϵ)*(factorial(N-3)/factorial(N))
                            elseif ((matrices[i][k,x] == tmp) && (i == j))
                                M_eig[i,i] += (1-ϵ)*(factorial(N-3)/factorial(N))
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
M_σ = zeros(Float64, leng_Basis, leng_Basis)
Build_M_σ(matrices, n_mat, M_eig, M_σ, basis_σ)
n=1
if (multiplication)
    for i in 1:n
        ran_vec = rand(Float64, leng_Basis)
        ran_vec = rand(Float64, leng_Basis)

        ran_vec /= sum(ran_vec)

        println(ran_vec)
        println("")
        for t in 1:MCS
            ran_vec = M_σ * ran_vec
            ran_vec /= sum(ran_vec)
        end

        println("")
        for i in 1:leng_Basis
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
    R_arr = zeros(Float64, leng_Basis)
    E_arr = eigvals(M_σ)
    for r in 1:leng_Basis
        R_arr[r] = real(E_arr[r])
    end

    largest_eig_arr = findall(R_arr .== maximum(R_arr))
    print("largest eigen value = ",  maximum(R_arr), "\n")

    Eig_Vec = eigvecs(M_σ)

    arr = zeros(Float64, leng_Basis)
    eig_conf_arr = []
    for eigvec_idx in largest_eig_arr
        println("Eigenvector idx : ", eigvec_idx)
        for j in 1:leng_Basis
            arr[j] = Eig_Vec[:,eigvec_idx][j]
        end
        idx = findall(arr .== maximum(arr))
        println("configuration idx = ", idx)
        push!(eig_conf_arr, idx)
        println(arr)
        print("\n")
        print("\n")
    end
    for conf in eig_conf_arr
        println(basis_σ[conf])
    end
end