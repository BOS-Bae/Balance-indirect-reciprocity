using LinearAlgebra

multiplication = false
eig_histo = false
ratio_check = true
L4_norm = true

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

M_L4 = zeros(Float64, n_mat, n_mat)
M_L6 = zeros(Float64, n_mat, n_mat)

matrices = generate_config_matrix(N)
#for i in 1:n_mat
#    println(matrices[i])
#end

#println(matrices[1])
#println(matrices[592])
#println(matrices[1210])
#println(matrices[1783])
#println(matrices[2515])
#println(matrices[2974])
#println(matrices[3436])
#println(matrices[3877])

for i in 1:n_mat
    for x in 1:N
        for y in 1:N
            if (x != y)
                tmp = matrices[i][x,y]
                matrices[i][x,y] *= -1
                idx = 0
                for j in 1:n_mat
                    if ((matrices[j] == matrices[i]) && (i != j))
                        M_L4[j,i] += (1/12)*ϵ
                    end
                end
                matrices[i][x,y] = tmp
                for k in 1:N
                    if (k != x && k != y)
                        tmp = matrices[i][k,x]
                        matrices[i][k,x] = L4_rule(matrices[i], k, x, y)

                        for j in 1:n_mat
                            if ((matrices[j] == matrices[i]) && (i != j))
                                M_L4[j,i] += (1-ϵ)*(factorial(N-3)/factorial(N))
                            elseif ((matrices[i][k,x] == tmp) && (i == j))
                                M_L4[i,i] += (1-ϵ)*(factorial(N-3)/factorial(N))
                            end
                        end
                        matrices[i][k,x] = tmp
                    end
                end
            end
        end
    end
end


for i in 1:n_mat
    for x in 1:N
        for y in 1:N
            if (x != y)
                tmp = matrices[i][x,y]
                matrices[i][x,y] *= -1
                idx = 0
                for j in 1:n_mat
                    if ((matrices[j] == matrices[i]) && (i != j))
                        M_L6[j,i] += (1/12)*ϵ
                    end
                end
                matrices[i][x,y] = tmp
                for k in 1:N
                    if (k != x && k != y)
                        tmp = matrices[i][k,x]
                        matrices[i][k,x] = L6_rule(matrices[i], k, x, y)

                        for j in 1:n_mat
                            if ((matrices[j] == matrices[i]) && (i != j))
                                M_L6[j,i] += (1-ϵ)*(factorial(N-3)/factorial(N))
                            elseif ((matrices[i][k,x] == tmp) && (i == j))
                                M_L6[i,i] += (1-ϵ)*(factorial(N-3)/factorial(N))
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
if (multiplication && (L4_norm==true))
    for i in 1:n
        #ran_vec = rand(Float64, n_mat)
        
        #ran_vec = rand(Float64, n_mat)
        ran_vec = zeros(Float64, n_mat)
        ran_vec[2] = 1
        ran_vec /= sum(ran_vec)

        println(ran_vec)
        println("")
        for t in 1:MCS
            ran_vec = M_L4 * ran_vec
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
elseif (multiplication && (L4_norm==false))
    for i in 1:n
        #ran_vec = rand(Float64, n_mat)
        
        #ran_vec = rand(Float64, n_mat)
        ran_vec = zeros(Float64, n_mat)
        ran_vec[2] = 1
        ran_vec /= sum(ran_vec)

        println(ran_vec)
        println("")
        for t in 1:MCS
            ran_vec = M_L6 * ran_vec
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
elseif (eig_histo && (L4_norm==true))
    #println(M_L4)
    R_arr = zeros(Float64, n_mat)
    E_arr = eigvals(M_L4)
    for r in 1:n_mat
        R_arr[r] = real(E_arr[r])
    end

    largest_eig_arr = findall(R_arr .== maximum(R_arr))
    print("largest eigen value = ",  maximum(R_arr), "\n")

    Eig_Vec = eigvecs(M_L4)

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
        for i in 1:n_mat
            print(arr[i], " ")
        end
        print("\n")
    end
    for conf in eig_conf_arr
        println(matrices[conf]) 
    end

elseif (eig_histo && (L6_norm==true))
    #println(M_L4)
    R_arr = zeros(Float64, n_mat)
    E_arr = eigvals(M_L6)
    for r in 1:n_mat
        R_arr[r] = real(E_arr[r])
    end

    largest_eig_arr = findall(R_arr .== maximum(R_arr))
    print("largest eigen value = ",  maximum(R_arr), "\n")

    Eig_Vec = eigvecs(M_L6)

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
        for i in 1:n_mat
            print(arr[i], " ")
        end
        print("\n")
    end
    for conf in eig_conf_arr
        println(matrices[conf]) 
    end
elseif (ratio_check)
    for i in 1:n_mat
        M_L4[i,i] = 0
        M_L6[i,i] = 0
    end
    M_ratio = zeros(Float64, n_mat, n_mat)
    for i in 1:n_mat
        for j in 1:n_mat
            if ((M_L4[i,j] != 0) && (M_L6[i,j] != 0))
                if (M_L4[i,j] > M_L6[i,j])
                    M_ratio[i,j] = (M_L4[i,j] / M_L6[i,j])
                else
                    M_ratio[i,j] = (M_L6[i,j] / M_L4[i,j])
                end
            end
        end
    end

    print(maximum(M_ratio) ,"    " ,(((1/12)*ϵ + ((1-ϵ)*factorial(N-3)/factorial(N))) / ((1/12)*ϵ)) ,"\n")
    path_idx = findall(M_ratio .== maximum(M_ratio))
    check_val = 0
    for p in path_idx
        mat_i = matrices[p[2]]
        mat_f = matrices[p[1]]
        mat_diff = mat_f - mat_i

        print(mat_i, "    ",mat_f,"    ")
        diff_idx = findall(mat_diff .!= 0)
        if (length(diff_idx) == 1)
            print("one is changed", "    ")
        end

        d_idx = diff_idx[1]
        o = d_idx[1]
        d = d_idx[2]
        print(o,"    ",d,"    ")

        global check_val
        for r in 1:N
            if (mat_i[o,d] == 1 && mat_i[o,r] == -1 && mat_i[d,r] == 1 && mat_f[o,d] == -1 && mat_f[o,r] == -1 && mat_i[d,r] == 1)
                print("G(CB) -> B", "    ")
                check_val += 1
            end
        end
        print("\n")
    end
    print("\n")
    
    if (check_val == length(path_idx))
        println(check_val, "    ", length(path_idx))
        println("all changed cases (with largest ratio for difference : GCB")
    end
end
