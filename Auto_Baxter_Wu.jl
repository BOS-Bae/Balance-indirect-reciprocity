using Random
include("MonteCarlo.jl")

nn_check = false
nn_print = false
draw_lattice = false
auto_corr = true

if (length(ARGS) < 4)
    print("usage : L MCS period T \n")
    exit(1)
end

L = parse(Int64, ARGS[1])
MCS = parse(Int64, ARGS[2])
period = parse(Int64, ARGS[3])
T = parse(Float64, ARGS[4])

#f_name = "./Baxter_Wu_dat/L$(lpad(L,3,"0"))T$(lpad(T,5,"0")).dat"
#println(f_name)
#fid = open(f_name, "w")

N = L*L
KK = 6 # number of neighbor

nn = zeros(Int64, N, KK)
L_matrix = zeros(Int64, L, L)
E_data = zeros(Float64, MCS)

spin = zeros(Int64, N)
for i in 1:N
    spin[i] = (rand(Float64) < 0.5 ? 1 : -1)
end

n_sample = 1
for s in 1:n_sample
    # Making structure of Kagome lattice
    for i in 1:N
        idx = i-1
        # 1 : down, 2 : right, 3 : up, 4 : left, 5 : left-up , 6 : right-down
        nn[i,1] = (idx÷L == 0 ? idx-L+N + 1 : idx-L + 1)
		nn[i,2] = (idx%L == L-1 ? idx+1-L + 1 : idx+1 + 1)
		nn[i,3] = (idx÷L == L-1 ? idx+L-N + 1 : idx+L + 1)
		nn[i,4] = (idx%L == 0 ? idx-1+L + 1 : idx-1 + 1)
        nn[i,5] = (idx÷L == L-1 ? nn[i,4] +L -N : nn[i,4]+ L)
        nn[i,6] = (idx÷L == 0 ? nn[i,2]-L + N : nn[i,2] - L)
    end

    if (nn_print) 
        for i in 1:N
            print(i-1," : ", nn[i,1]-1, " ", nn[i,2]-1, " ", nn[i,3]-1, " ", nn[i,4]-1, " ", nn[i,5]-1, " ", nn[i,6]-1, "\n")
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
                
    E = Baxter_wu_E(spin, nn, N)
    
    mag = sum(spin)/N
    
	t = 0
    E_avg = E2_avg = 0
	E_sam = c_sam = 0

	#n_sam = ((MCS - t_thm) ÷ t_ms)

	#E_sam = zeros(Float64, Int64(n_sam))
	#c_sam = zeros(Float64, Int64(n_sam))
	n_s = 0
	for t in 1:MCS
        E_data[t] = E
		E_avg = E2_avg = 0
        
		#print(T,"    ", E, "    ", E^2, "\n")
       	for p in 1:period
	      	Baxter_wu_metropolis(spin, nn,N,T)
		end
       	E = Baxter_wu_E(spin, nn, N)
		#println(E)
       	#mag = sum(spin)/N
		
		n_s += 1
		#print("t=",t,"\n")
		#print(T,"    ", E_avg,"    ", (E2_avg -  E_avg*E_avg)/(T^2), "\n")
	end

    if (auto_corr)
        for t in 1:50000
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
