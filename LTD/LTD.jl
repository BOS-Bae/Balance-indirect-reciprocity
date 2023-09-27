using Random

if (length(ARGS) < 4)
    println("Enter input variables : N p MCS n_sample")
    exit(1)
end

N = parse(Int64, ARGS[1])
p = parse(Float64, ARGS[2])
MCS = parse(Int64, ARGS[3])
n_s = parse(Int64, ARGS[4])

Edge = []
Triad = []
for i in 1:N
    for j in i:N
        if (i != j)
            push!(Edge, (i,j))
        end
        for k in j:N
            if (i!=j && i!=k && j!=k)
                push!(Triad, (i,j,k))
            end
        end
    end
end

n_Triad = length(Triad)
n_Edge = length(Edge)

function LTD_update(x, p, Triad)
    for (i,j,k) in Triad
        signs = [x[i,j], x[j,k], x[i,k]]
        if (sum(signs) == 1)
            if (rand(Float64) < p)
                x[i,j] = x[j,k] = x[i,k] = 1
            else
                if (x[i,j] == 1 && x[j,k] == 1 && x[i,k] == -1)
                    x[i,j] = -1
                elseif (x[i,j] == 1 && x[j,k] == -1 && x[i,k] == 1)
                    x[i,k] = -1
                elseif (x[i,j] == -1 && x[j,k] == 1 && x[i,k] == 1)
                    x[j,k] = -1
                end
            end
        elseif (sum(signs) == -3)
            x[i,j] *= -1
        end 
        x[j,i] = x[i,j]; x[k,i] = x[i,k]; x[k,j] = x[j,k]
    end
end

function balance(x, Triad)
    bal = 0
    for (i,j,k) in Triad
        signs = [x[i,j], x[j,k], x[i,k]]
        if (prod(signs) == 1)
            bal += 1
        end
    end
    return bal
end

function ρ_cal(x, n_Edge, Edge)
    ρ_count = 0
    for (i,j) in Edge
        if (x[i,j] == 1)
            ρ_count += 1 
        end
    end

    return ρ_count/n_Edge
end

function n_k(x, n_Triad, Triad)
    n0 = n1 = n2 = n3  =0
    for (i,j,k) in Triad
        signs = [x[i,j], x[j,k], x[i,k]]
        if (sum(signs) == 3)
            n0 += 1
        elseif (sum(signs) == 1)
            n1 += 1
        elseif (sum(signs) == -1)
            n2 += 1
        elseif (sum(signs) == -3)
            n3 += 1
        else
            println("error")
        end
    end
    n0 /= n_Triad; n1 /= n_Triad; n2 /= n_Triad; n3 /= n_Triad
    n_arr = [n0, n1, n2, n3]
    return n_arr
end

function x_init(N)
    x_i = zeros(Int64, N, N)
    for i in 1:N
        for j in i:N
            if (i != j)
                x_i[i,j] = (rand(Float64) < 0.5 ? 1 : -1)
                x_i[j,i] = x_i[i,j]
            end
        end
    end
    return x_i
end

t_ms = 1000

saved_mat = zeros(Float64, n_s,5)

for s in 1:n_s
    x_t = x_init(N)
    t_m = 0
    for t in 1:MCS
        if (t > (MCS-t_ms))
            t_m += 1
            ρ = ρ_cal(x_t, n_Edge, Edge)
            n = n_k(x_t, n_Triad, Triad)
            saved_mat[s,1] += ρ; saved_mat[s,2] += n[1]; saved_mat[s,3] += n[2]
            saved_mat[s,4] += n[3]; saved_mat[s,5] += n[4]
        end
        LTD_update(x_t,p,Triad)
    end
    saved_mat[s,:] /= t_m
end
ρ_avg = sum(saved_mat[:,1])/n_s; n0 = sum(saved_mat[:,2])/n_s; n1 = sum(saved_mat[:,3])/n_s
n2 = sum(saved_mat[:,4])/n_s; n3 = sum(saved_mat[:,5])/n_s

ρ_std = 0
for s in 1:n_s
    global ρ_std
    ρ_std += (saved_mat[s,1] - ρ_avg)^2
end
ρ_std = sqrt(ρ_std)/sqrt(n_s - 1)
ρ_std /= sqrt(n_s)

println(p,"  ",ρ_avg ,"  ", n0, "  ", n1,"  ", n2, "  ", n3, "  ", ρ_std)
