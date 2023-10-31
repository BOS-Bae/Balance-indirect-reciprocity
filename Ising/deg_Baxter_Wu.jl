using Random
include("MonteCarlo.jl")

nn_check = false
nn_print = false
d_print = false
draw_lattice = false
auto_corr = false

if (length(ARGS) < 5)
    print("usage : L MCS period T p_delete  \n")
    exit(1)
end

L = parse(Int64, ARGS[1])
MCS = parse(Int64, ARGS[2])
period = parse(Int64, ARGS[3])
T = parse(Float64, ARGS[4])
p_del = parse(Float64, ARGS[5])
n_realization = 1

#f_name = "./Baxter_Wu_dat/L$(lpad(L,3,"0"))T$(lpad(T,5,"0")).dat"
#println(f_name)
#fid = open(f_name, "w")

N = L*L
KK = 6 # number of neighbor

nn = zeros(Int64, N, KK)
d_edge = zeros(Int64, N, KK) # for each hexagon ..

L_matrix = zeros(Int64, L, L)
E_data = zeros(Float64, MCS)

for s in 1:n_realization
	spin = zeros(Int64, N+1)
	for i in 1:N
	    spin[i] = (rand(Float64) < 0.5 ? 1 : -1)
	end
	    # Making structure of triangular lattice
    for i in 1:N
        idx = i-1
        # 1 : down, 2 : right, 3 : up, 4 : left, 5 : left-up , 6 : right-down
        nn[i,1] = (idx÷L == 0 ? idx-L+N + 1 : idx-L + 1)
		nn[i,2] = (idx%L == L-1 ? idx+1-L + 1 : idx+1 + 1)
		nn[i,3] = (idx÷L == L-1 ? idx+L-N + 1 : idx+L + 1)
		nn[i,4] = (idx%L == 0 ? idx-1+L + 1 : idx-1 + 1)
        nn[i,5] = (idx÷L == L-1 ? nn[i,4] +L -N : nn[i,4]+ L)
        nn[i,6] = (idx÷L == 0 ? nn[i,2]-L + N : nn[i,2] - L)
		if ((idx % 2 == 1) && ((idx ÷ L)) % 2 == 1)
			d_edge[i,1] = d_edge[i,2] = d_edge[i,3] = d_edge[i,4] = d_edge[i,5] = d_edge[i,6] = -1
		elseif ((idx % 2 == 1) && ((idx ÷ L)) % 2 == 0)
			d_edge[i,1] = d_edge[i,3] = -1; d_edge[i,2] = d_edge[i,4] = d_edge[i,5] = d_edge[i,6] = 1
		elseif ((idx % 2 == 0) && ((idx ÷ L)) % 2 == 0)
			d_edge[i,5] = d_edge[i,6] = -1; d_edge[i,1] = d_edge[i,2] = d_edge[i,3] = d_edge[i,4] = 1
		elseif ((idx % 2 == 0) && ((idx ÷ L)) % 2 == 1)
			d_edge[i,2] = d_edge[i,4] = -1; d_edge[i,1] = d_edge[i,3] = d_edge[i,5] = d_edge[i,6] = 1
		end
    end

	for i in 1:N
		for k in 1:KK
			if (d_edge[i,k] == -1)
				if ((rand(Float64) < p_del) && (nn[i,k]) != (N+1))
					if (k==1) nn[i,1] = nn[nn[i,1],3] = N+1
					elseif (k==2) nn[i,2] = nn[nn[i,2],4] = N+1
					elseif (k==3) nn[i,3] = nn[nn[i,3],1] = N+1
					elseif (k==4) nn[i,4] = nn[nn[i,4],2] = N+1
					elseif (k==5) nn[i,5] = nn[nn[i,5],6] = N+1
					elseif (k==6) nn[i,6] = nn[nn[i,6],5] = N+1
					end
				end
			end
		end
	end

    if (nn_print) 
        for i in 1:N
            print(i-1," : ", nn[i,1]-1, " ", nn[i,2]-1, " ", nn[i,3]-1, " ", nn[i,4]-1, " ", nn[i,5]-1, " ", nn[i,6]-1, "\n")
        end
    end
	if (d_print)
        for i in 1:N
            print(i-1," : ", d_edge[i,1], " ", d_edge[i,2], " ", d_edge[i,3], " ", d_edge[i,4], " ", d_edge[i,5], " ", d_edge[i,6], "\n")
        end
	end
    check = check_true = 0
    if (nn_check)
        for i in 1:N
            idx = i-1
            if (true)
#            if ((idx % L == 0) && (idx ÷ L == 0))
                for k in 1:KK
                    n_idx = nn[i,k]
                    check += 1
                    if ((nn[n_idx,1] == i) || (nn[n_idx,2] == i) 
                        || (nn[n_idx,3] == i) || (nn[n_idx,4] == i) || (nn[n_idx,5] == i) || (nn[n_idx,6] == i))

                        check_true += 1
                    else
                        print(i-1," ",n_idx-1,"\n")
                    end
                end
            end
        end

        print(check," ", check_true," ", check==check_true, "\n")
    end
                
    E = deg_Baxter_wu_E(spin, nn, N)
	E_g = deg_ground_E(spin, nn, N)

    mag = sum(spin)/N
    
	t = 0
    E_avg = E2_avg = 0
	E_sam = c_sam = 0

	#n_sam = ((MCS - t_thm) ÷ t_ms)

	#E_sam = zeros(Float64, Int64(n_sam))
	#c_sam = zeros(Float64, Int64(n_sam))
	n_s = 0
	t_ms = 0
	E_avg = 0
	for t in 1:MCS
		#print(T,"    ", E, "    ", E^2, "    ", -2*N, "\n")
       	for p in 1:period
	      	deg_Baxter_wu_metropolis(spin, nn,N,T)
		end
       	E = deg_Baxter_wu_E(spin, nn, N)
		#println(E)
       	#mag = sum(spin)/N

		if (t > (MCS-10000))
			t_ms += 1
			E_avg += E	
		end
		n_s += 1
		#print("t=",t,"\n")
		#print(T,"    ", E_avg,"    ", (E2_avg -  E_avg*E_avg)/(T^2), "\n")
	end
	E_avg /= t_ms

	print(p_del, "    ", (E_avg - E_g), "    ", (E_avg - E_g)^2,"\n")

    if (auto_corr)
        for t in 1:MCS
	        mul_sum = p_t_sum = p_sum = 0
	        div_f = (1/(MCS-t))
	        for t_p in 1:(MCS-t)
	            mul_sum += E_data[t_p + t]*E_data[t_p]
		        p_t_sum += E_data[t_p + t]
		        p_sum += E_data[t_p]
	        end
            C_t = ((div_f)*(mul_sum) - (div_f)*(p_t_sum)*(div_f)*(p_sum))
	        print(C_t, "\n")
	    end
    end

    if (draw_lattice)
        for i in 1:N
            row = (((i-1) ÷ L) + 1)
            col = (((i-1) % L) + 1)
            L_matrix[row,col] = spin[i]
        end

        print("[")
        for i in 1:L
            for j in 1:L
                if (j==1)
                    print("[")
                end
                if (j!=L)
                    print(L_matrix[L+1-i,j], ", ")
                elseif (j==L && i!=L)
                    print(L_matrix[L+1-i,j], "],\n")
                else
                    print(L_matrix[L+1-i,j], "]")
                end
            end
            if (i==L)
                print("]")
            end
        end
    end
end
#close(fid)
