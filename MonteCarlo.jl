using Random

function calc_E(spin, nn, H, K, M, N)
    # H K M
    E = 0.0
    for i in 1:N
        E -= (H*spin[i] + (K/2)*spin[i]*(spin[nn[i,1]] + spin[nn[i,2]] + spin[nn[i,3]] + spin[nn[i,4]])
                + (1/3)*spin[i]*(spin[nn[i,1]]*spin[nn[i,2]] + spin[nn[i,3]]*spin[nn[i,4]]))
    end
    return E
end

function Baxter_wu_E(spin, nn, N)
    E = 0.0
    for i in 1:N
        E -= spin[i]*(1/3)*(spin[nn[i,4]]*spin[nn[i,5]] + spin[nn[i,3]]*spin[nn[i,5]] 
        + spin[nn[i,3]]*spin[nn[i,2]] + spin[nn[i,2]]*spin[nn[i,6]] 
        + spin[nn[i,1]]*spin[nn[i,6]] + spin[nn[i,4]]*spin[nn[i,1]])
    end
    return E
end

function Baxter_wu_metropolis(spin, nn, N, T)
    # 1 : down, 2 : right, 3 : up, 4 : left, 5 : left-up , 6 : right-down	
    for i in 1:N
        dE = spin[i]*(2/3)*(spin[nn[i,4]]*spin[nn[i,5]] + spin[nn[i,3]]*spin[nn[i,5]] 
        + spin[nn[i,3]]*spin[nn[i,2]] + spin[nn[i,2]]*spin[nn[i,6]] 
        + spin[nn[i,1]]*spin[nn[i,6]] + spin[nn[i,4]]*spin[nn[i,1]])
        if (dE < 0)
            spin[i] *= -1
        elseif (rand(Float64) < exp(-dE/T))
            spin[i] *= -1
        end
    end
end

function metropolis(spin, nn, N, H, K, M)
    dE = 0
    for i in 1:N
        dE = 2*(H*spin[i] + (K/2)*spin[i]*(spin[nn[i,1]] + spin[nn[i,2]] + spin[nn[i,3]] + spin[nn[i,4]])
                + (M/3)*spin[i]*(spin[nn[i,1]]*spin[nn[i,2]] + spin[nn[i,3]]*spin[nn[i,4]]))
        if (dE < 0)
            spin[i] *= -1
        elseif (rand(Float64) < exp(-dE))
            spin[i] *= -1
        end
    end
end

function metropolis2(spin, nn, E_i, N, M, KK)
    E_f = E_i
    dE = 0.0
    for i in 1:N
        dE += 2*M*spin[i]*spin[nn[i,1]]*spin[nn[i,2]]/3
        dE += 2*M*spin[i]*spin[nn[i,3]]*spin[nn[i,4]]/3
        
        if (dE < 0)
            spin[i] *= -1
            E_f += dE
        elseif (rand(Float64) < exp(-dE))
            spin[i] *= -1
            E_f += dE
        end
    end
    return E_f
end

function metropolis3(spin, nn, E_i, N, M, KK, t)
    E_f = E_i
    dE = 0
    for i in 1:N
        dE = 2*( M*spin[i]*(spin[nn[i,1]]*spin[nn[i,2]] + spin[nn[i,3]]*spin[nn[i,4]]))
        if (dE < 0)
            E_f += dE
            spin[i] *= -1
        elseif (rand(Float64) < exp(-dE))
            E_f += dE
            spin[i] *= -1
        end
    end
    return E_f
end

function parallel_tempering(N, E_data, M_arr, i, j)
    if (M_arr[i] <= M_arr[j])
        print("temperature error \n")
        exit(1)
    end

    dE_T = E_data[i] - E_data[j]
    ACCEPT = false
    
    if (dE_T < 0)
        ACCEPT = true
    else
        ACCEPT = (rand(Float64) < exp(-dE_T) ? true : false)
    end
    
    if (ACCEPT)
		spin1 = zeros(Float64, N)
		spin2 = zeros(Float64, N)
        signal = 2
        MPI.Send(signal, comm; dest=i, tag=40)
        MPI.Send(signal, comm; dest=j, tag=40)
        for v in 1:N
			spin1[v] = MPI.Recv(Float64, comm; source=i, tag=50+i+v)
        	spin2[v] = MPI.Recv(Float64, comm; source=j, tag=50+j+v)
		end
        E1 = MPI.Recv(Float64, comm; source=i, tag=42)
        E2 = MPI.Recv(Float64, comm; source=j, tag=42)
        for v in 1:N	
			MPI.Send(spin2[v], comm; dest=i, tag=60+i+v)
	        MPI.Send(spin1[v], comm; dest=j, tag=60+j+v)
		end
        MPI.Send(E2, comm; dest=i, tag=44)
        MPI.Send(E1, comm; dest=j, tag=44)
    end
	return ACCEPT
end
