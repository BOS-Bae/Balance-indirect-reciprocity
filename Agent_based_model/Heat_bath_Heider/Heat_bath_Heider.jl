using Random

paradise = false

if (length(ARGS) < 3)
    println("Enter input variables : N T MCS")
    exit(1)
end

N = parse(Int64, ARGS[1])
T = parse(Float64, ARGS[2])
MCS = parse(Int64, ARGS[3])

x = zeros(Int64, N, N)
if (!paradise)
    for i in 1:N
        for j in i:N
            x[i,j] = (rand(Float64) < 0.5 ? 1 : -1)
            x[j,i] = x[i,j]
        end
    end
else
    x = ones(Int64, N, N)
end

#for i in 1:N
#    println(x[i,:])
#end

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
#println(Triad)
function Heat_bath(x, T, Edge)
    for (i,j) in Edge
        H_loc = 0
        for k in 1:N
            H_loc += x[i,k]*x[k,j]
        end
        p_ij = (exp(H_loc/T)/(exp(H_loc/T) + exp(-H_loc/T)))
        x[i,j] = (rand(Float64) < p_ij ? 1 : -1)
        x[j,i] = x[i,j]
    end
end

function metropolis(x, T, N)
    H_loc = 0
    for i in 1:N
        for j in 1:N
            for k in 1:N
                H_loc += 2*x[i,j]*x[j,k]*x[k,i]
            end
            if (rand(Float64) < exp(-H_loc/T))
                x[i,j] *= -1
                x[j,i] = x[i,j]
            end
        end
    end
    
end

function H(x, T, n_Triad, Triad)
    H_tot = 0
    for (i,j,k) in Triad
        H_tot -= x[i,j]*x[j,k]*x[k,i]
    end
    H_tot /= n_Triad

    return H_tot
end

E_avg = 0
x_avg = 0
for t in 1:MCS
    global E_avg
    global x_avg
    E = H(x,T,n_Triad,Triad)
    x_sum = sum(x)/(N*N)
    if (t > (MCS-1000))
        E_avg += E/1000
        x_avg += x_sum/1000
    end
    #print(x_sum, "  ", E, "\n")
    #metropolis(x,T,N)
    Heat_bath(x,T,Edge)
end
print(T,"    ",x_avg ,"    ",E_avg,"\n")
