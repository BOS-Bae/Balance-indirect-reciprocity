using LinearAlgebra

multiplication = false
if (length(ARGS) < 3)
    print("usage : N ϵ iter \n")
    exit(1)
end

N = parse(Int64, ARGS[1])
ϵ = parse(Float64, ARGS[2])
iter = parse(Int64, ARGS[3])

function L6_rule(O_matrix, α, d, r)
    val = O_matrix[α,r] * O_matrix[d,r]
    return val
end


function L4_rule(O_matrix, α, d, r)
    val = 0
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
    num_matrices = 2^(N * N)
    matrices = Array{Int}[]
    
    for index in 0:num_matrices-1
        matrix = zeros(Int64, N, N)
        temp_index = index
        
        for row in 1:N
            for col in 1:N
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

function power_method(N::Int64, iter::Int64, matrices, r_init)
    n_mat = 2^((N * (N - 1)) + N)

    r_i = zeros(Float64, n_mat)
    for i in 1:n_mat
        r_i[i] = r_init[i]
    end
    r_f = zeros(Float64, n_mat)
    for t in 1:iter
        for i in 1:n_mat
            for x in 1:N
                for y in 1:N
                    tmp = matrices[i][x,y]
                    matrices[i][x,y] *= -1
                    idx = 0
                    for j in 1:n_mat
                        if ((matrices[j] == matrices[i]) && (i != j))
                            r_f[j] += (1/6)*ϵ*r_i[i]
                            #M[j,i] += (1/6)*ϵ
                        end
                    end
                    matrices[i][x,y] = tmp
                    for k in 1:N
                        tmp = matrices[i][k,x]
                        matrices[i][k,x] = L6_rule(matrices[i], k, x, y)

                        for j in 1:n_mat
                            if ((matrices[j] == matrices[i]) && (i != j))
                                r_f[j] += (1-ϵ)*(factorial(N-3)/factorial(N))*r_i[i]
                                #M_eig[j,i] += (1-ϵ)*(factorial(N-3)/factorial(N))
                            elseif ((matrices[i][k,x] == tmp) && (i == j))
                                r_f[i] += (1-ϵ)*(factorial(N-3)/factorial(N))*r_i[i]
                                #M_eig[i,i] += (1-ϵ)*(factorial(N-3)/factorial(N))
                            end
                        end
                        matrices[i][k,x] = tmp
                    end
                end
            end
        end
        r_f /= dot(r_f,r_f)
        for i in 1:n_mat
            r_i[i] = r_f[i]
        end
    end
    return r_f
end

n_mat = 2^(N * N)
matrices = generate_config_matrix(N)
println(length(matrices))
for i in 1:n_mat
    for j in 1:n_mat
        if (matrices[i] == matrices[j] && i!=j)
            println("error")
        end
    end
end

r_vector = rand(Float64, n_mat)
#for i in 1:n_mat
#    println(ran_mat[:,i])
#end
#println("")

result_vector = power_method(N, iter, matrices, r_vector)

for i in 1:n_mat
    print(result_vector[i])
end

for i in 1:n_mat
    if (result_vector[i] > 0.005)
        println(matrices[i])
    end
end

