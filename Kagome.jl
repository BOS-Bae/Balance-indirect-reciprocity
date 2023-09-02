using Random

include("MonteCarlo.jl")

nn_check = false
nn_print = false
draw_lattice = false
auto_corr = false

if (length(ARGS) < 7)
    print("usage : Lx Ly MCS period H K T \n")
    exit(1)
end

Lx = parse(Int64, ARGS[1])
Ly = parse(Int64, ARGS[2])
MCS = parse(Int64, ARGS[3])
period = parse(Int64, ARGS[4])
H = parse(Float64, ARGS[5])
K = parse(Float64, ARGS[6])
T = parse(Float64, ARGS[7])

M = 1/T

N = 3*Lx*Ly
KK = 4 # number of neighbor

nn = zeros(Int64, N, KK)

n_col = 3*Lx + 3*2*Ly
n_row = 2*Ly
L_matrix = zeros(Int64, n_row, n_col)
L_list = zeros(Int64, n_row, n_col)
    
E_data = zeros(Float64, MCS)

spin = zeros(Int64, N)
for i in 1:N
    spin[i] = rand(Float64) < 0.5 ? 1 : -1
end

n_sample = 1
for s in 1:n_sample
    # Making structure of Kagome lattice
    for i in 1:N
        idx = (i-1)÷3
        if (mod(i-1, 3) == 0)
            nn[i,3] = i+1
            nn[i,4] = i+2
            # nn[i,1] : left, nn[i,2] : down, nn[i,3] : right, nn[i,4] : up

            # ((idx % L == 0) && (idx ÷ L == 0))
            if ((idx % Ly != 0) && (idx ÷ Lx != 0))
                nn[i,1] = i-2
                nn[i,2] = i-3*Lx+2
            elseif ((idx % Ly != 0) && (idx ÷ Lx == 0))
                nn[i,1] = i-2
                nn[i,2] = i+N-3*Lx+2
            elseif ((idx % Ly == 0) && (idx ÷ Lx != 0))
                nn[i,1] = i+3*Lx-2
                nn[i,2] = i-3*Lx+2
            elseif ((idx % Ly == 0) && (idx ÷ Lx == 0))
                nn[i,1] = i+3*Lx-2
                nn[i,2] = i+N-3*Lx+2
            end
            nn[i,1] = ((idx) % Lx == 0 ? i+(3*Lx-2) : i-2)
            nn[i,2] = ((idx) ÷ Lx == 0 ? i+N-(3*Lx-2) : i-3*Lx+2)
        elseif (mod(i-1, 3) == 1)

            # nn[i,1] : left, nn[i,2] : up, nn[i,3] : right, nn[i,4] : down
            nn[i,1] = i-1
            nn[i,2] = i+1
            if ((idx % Lx != Lx-1) && (idx ÷ Lx != 0))
                nn[i,3] = i+2
                nn[i,4] = i-3*Lx+4
            elseif ((idx % Lx == Lx-1) && (idx ÷ Lx != 0))
                nn[i,3] = i-3*Lx+2
                nn[i,4] = i-3*Lx-3*Lx+4
            elseif ((idx % Lx != Lx-1) && (idx ÷ Lx == 0))
                nn[i,3] = i+2
                nn[i,4] = i-3*Lx+1+N
            elseif ((idx % Lx == Lx-1) && (idx ÷ Lx == 0))
                nn[i,3] = i-3*Lx+2
                nn[i,4] = i-3*Lx+N+1
            end
        else
            # nn[i,1] : upperleft, nn[i,2] : upperright, nn[i,3] : lowerleft, nn[i,4] : lowerright
            if ((idx % Lx != 0) && (idx ÷ Lx != Ly-1))
                nn[i,1] = i+3*Lx-4 
                nn[i,2] = i+3*Lx-2
            elseif ((idx % Lx == 0) && (idx ÷ Lx != Ly-1))
                nn[i,1] = i+3*Lx+3*Lx-4
                nn[i,2] = i+3*Lx-2
            elseif ((idx % Lx != 0) && (idx ÷ Lx == Ly-1))
                nn[i,1] = i+3*Lx-2-N
                nn[i,2] = i+3*Lx-2-N+1
            elseif ((idx % Lx == 0) && (idx ÷ Lx == Ly-1))
                nn[i,1] = i-N+3*(Lx+1)-5
                nn[i,2] = i-N+3*Lx-1
            end
            nn[i,3] = i-2
            nn[i,4] = i-1
        end
    end

    if (nn_print) 
        for i in 1:N
            print(i-1," : ", nn[i,1]-1, " ", nn[i,2]-1, " ", nn[i,3]-1, " ", nn[i,4]-1, "\n")
        end
    end

    check = check_true = 0
    if (nn_check)
        for i in 1:N
            idx = (i-1)÷3
            if (true)
#            if ((idx % L == 0) && (idx ÷ L == 0))
                for k in 1:KK
                    n_idx = nn[i,k]
                    check += 1
                    if ((nn[n_idx,1] == i) || (nn[n_idx,2] == i) 
                        || (nn[n_idx,3] == i) || (nn[n_idx,4] == i))

                        check_true += 1
                    else
                        print(i-1," ",n_idx-1,"\n")
                    end
                end
            end
        end

        print(check," ", check_true," ", check==check_true, "\n")
    end
                
    E = calc_E(spin, nn, H, K, M, N)
    
    mag = sum(spin)/N
    
    ground_E = (-H-2*K-2/3)*N
	t = 0
    t_avg = 5000
    E_avg = E2_avg = 0
	for t in 1:MCS
        E_data[t] = E
        if (t == MCS-t_avg)
            E_avg = E2_avg = 0
        end
        E_avg += E/t_avg
        E2_avg += E^2/t_avg

		#print(mag,"    ", E, "    ", ground_E, "\n")
        for p in 1:period
            metropolis(spin, nn, N, H, K, M)
            #Wolff(spin, nn, N, H, K, M, KK)
        end
        E = calc_E(spin, nn, H, K, M, N)
        mag = sum(spin)/N

		#if (Int64(round(E)) == Int64(round(ground_E)))
		#	print("\n")
		#	print("t = ", t)
		#	break
		#end
    end
    print(T,"    ", E_avg,"    ", E2_avg, "\n")

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
        #L_matrix = zeros(Int64, 2*3*L + 2*L, 2*L)
        for i in 1:N
            idx = i-1
            row = col = 0
            if (idx % 3 == 0)
                row = (sqrt(3)/2)*(idx ÷ (3*Lx))
                col = 2*((idx % (3*Lx)))  + 2*(2*row/sqrt(3))
            elseif (idx % 3 == 1)
                row = (sqrt(3)/2)*(idx ÷ (3*Lx))
                col = 2*((idx % (3*Lx))) + 2*(2*row/sqrt(3))
            else 
                row = (sqrt(3)/2)*(idx ÷ (3*Lx)) + (sqrt(3)/4)
                col = 2*((idx % (3*Lx))) -3 + 2*(2*(row-(sqrt(3)/4))/sqrt(3))
            end
            #println(row," " ,col)
            #L_matrix[row+1,col+1] = spin[i]
            #L_list[row+1,col+1] = idx
            print(idx, " ", row, " ",col," ",spin[i],"\n")
        end
        
        #for i in 1:n_row
        #    for j in 1:n_col
        #        print(L_list[n_row+1 - i, j], " ")
        #    end
        #    print("\n")
        #end
        #for i in 1:n_row
        #    for j in 1:n_col
        #        print(L_matrix[n_row+1 - i, j], " ")
        #    end
        #    print("\n")
        #end
    end
end

