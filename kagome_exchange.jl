using Random
using MPI
include("MonteCarlo.jl")

MPI.Init()
comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
size = MPI.Comm_size(comm)

MPI_use = true
nn_check = false
nn_print = false
draw_lattice = false

# Note : source (master node) = 0
if (length(ARGS) < 3)
    print("usage : L MCS period \n")
    exit(1)
end

L = parse(Int64, ARGS[1])
MCS = parse(Int64, ARGS[2])
period = parse(Int64, ARGS[3])

H = 0 # set the value of magnetic field on site as zero
K = 0 # set the value of bond-interaction as zero

N = 3*L*L
KK = 4 # number of neighbor

nn = zeros(Int64, N, KK)
L_matrix = zeros(Int64, 2*L, 2*L)
n_sample = 1

# Making structure of Kagome lattice
for i in 1:N
    idx = (i-1)÷3
    if (mod(i-1, 3) == 0)
        nn[i,3] = i+1
        nn[i,4] = i+2
        # nn[i,1] : left, nn[i,2] : down, nn[i,3] : right, nn[i,4] : up
        # ((idx % L == 0) && (idx ÷ L == 0))
        if ((idx % L != 0) && (idx ÷ L != 0))
            nn[i,1] = i-2
            nn[i,2] = i-3*L+2
        elseif ((idx % L != 0) && (idx ÷ L == 0))
            nn[i,1] = i-2
            nn[i,2] = i+N-3*L+2
        elseif ((idx % L == 0) && (idx ÷ L != 0))
            nn[i,1] = i+3*L-2
            nn[i,2] = i-3*L+2
        elseif ((idx % L == 0) && (idx ÷ L == 0))
            nn[i,1] = i+3*L-2
            nn[i,2] = i+N-3*L+2
        end
        nn[i,1] = ((idx) % L == 0 ? i+(3*L-2) : i-2)
        nn[i,2] = ((idx) ÷ L == 0 ? i+N-(3*L-2) : i-3*L+2)
    elseif (mod(i-1, 3) == 1)
        # nn[i,1] : left, nn[i,2] : up, nn[i,3] : right, nn[i,4] : down
        nn[i,1] = i-1
        nn[i,2] = i+1
        if ((idx % L != L-1) && (idx ÷ L != 0))
            nn[i,3] = i+2
            nn[i,4] = i-3*L+4
        elseif ((idx % L == L-1) && (idx ÷ L != 0))
            nn[i,3] = i-3*L+2
            nn[i,4] = i-3*L-3*L+4
        elseif ((idx % L != L-1) && (idx ÷ L == 0))
            nn[i,3] = i+2
            nn[i,4] = i-3*L+1+N
        elseif ((idx % L == L-1) && (idx ÷ L == 0))
            nn[i,3] = i-3*L+2
            nn[i,4] = i-3*L+N+1
        end
    else
        # nn[i,1] : upperleft, nn[i,2] : upperright, nn[i,3] : lowerleft, nn[i,4] : lowerright
        if ((idx % L != 0) && (idx ÷ L != L-1))
            nn[i,1] = i+3*L-4 
            nn[i,2] = i+3*L-2
        elseif ((idx % L == 0) && (idx ÷ L != L-1))
            nn[i,1] = i+3*L+3*L-4
            nn[i,2] = i+3*L-2
        elseif ((idx % L != 0) && (idx ÷ L == L-1))
            nn[i,1] = i+3*L-2-N
            nn[i,2] = i+3*L-2-N+1
        elseif ((idx % L == 0) && (idx ÷ L == L-1))
            nn[i,1] = i-N+3*(L+1)-5
            nn[i,2] = i-N+3*L-1
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
	global check; global check_true
    for i in 1:N
        idx = (i-1)÷3
        if (true)
#           if ((idx % L == 0) && (idx ÷ L == 0))
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


if (rank != 0)

    signal = MPI.Recv(Int64, comm; source=0, tag=1)
    M = MPI.Recv(Float64, comm; source=0, tag=2)
    spin = zeros(Float64, N)
    for i in 1:N
        spin[i] = (rand(Float64) < 0.5 ? 1 : -1)
    end
    #println("rank = " ,rank, "singal = ",  signal)

    ground_E = (-H-2*K-2*M/3)*N
    for p in 1:period
        metropolis(spin, nn, N, H, K, M, KK)
        #print(mag,"    ",E,"    ", ground_E,"\n")
    end
    mag = sum(spin)/N
    E = calc_E(spin, nn, H, K, M, N, KK)
    MPI.Send(Float64(E), comm; dest=0, tag=32)
    MPI.Send(Float64(mag), comm; dest=0, tag=33)

	#println("rank = ", rank ,"M = ", M)
	bool_val = MPI.Recv(Bool, comm; source=0, tag=70)
    
	if (bool_val)
		for v in 1:N
        	MPI.Send(spin[v], comm; dest=0, tag=50+rank+v)
        end
		MPI.Send(Float64(E),comm; dest=0, tag=42)
        for v in 1:N
			spin[v] = MPI.Recv(Float64,comm; source=0, tag=60+rank+v)
		end
        E = MPI.Recv(Float64, comm; source=0, tag=44)
		println("rank=",rank, " ", "E=" , E)
        # parallel tempering. I have to check detaile balance for it, and review the algorithm.
    end
    signal = MPI.Recv(Int64, comm; source=0, tag=4)
    E = calc_E(spin, nn, H, K, M, N, KK)
    mag = sum(spin)/N

    if (draw_lattice)
        for i in 1:N
            if (mod((i-1),3) == 2)
                row = 2*((i-1) ÷ (3*L)) + 1
                col = 2*(((i-1) ÷ 3) % L) 
            elseif (mod((i-1), 3) != 2)
                if (mod((i-1), 3) == 0)
                    row = 2*((i-1) ÷ (3*L))
                    col = 2*(((i-1) ÷ 3) % L)
                elseif (mod((i-1), 3) == 1)
                    row = 2*((i-1) ÷ (3*L))
                    col = 2*(((i-1) ÷ 3) % L)+1
                end
            end
            #println(i-1,": ",row+1," ",col+1)
            L_matrix[row+1,col+1] = spin[i]
        end
    
        for i in 1:(2*L)
            for j in 1:(2*L)
                print(L_matrix[2*L-i+1,j], " ")
            end
            print("\n")
        end
    end

elseif (rank == 0)
    E_data = zeros(Float64, size-1)
    m_data = zeros(Float64, size-1)
    M_arr = 10.0 .^(range(3.0,stop=8.0,length=30))

    M_arr = sort(M_arr, rev=true)
    #= Signal ~
    0 : spin initialization
    1 : Monte Carlo simulation
    2 : Parallel tempering
    3 : stop working
    =#
    signal = Int64(0)
    # I have to draw the 'energy histogram', before doing parallel tempering.
    for s in 1:size-1
        MPI.Send(signal, comm; dest=s, tag=1)
    end

    for s in 1:size-1
        MPI.Send(Float64(M_arr[s]), comm; dest=s, tag=2)
    end

    for t in 1:MCS
        for s in 1:size-1
            E_data[s] = MPI.Recv(Float64, comm; source=s, tag=32)
            m_data[s] = MPI.Recv(Float64, comm; source=s, tag=33)

            print(M_arr[s], "    ", m_data[s], "    ", E_data[s], "\n")
            # spin flip is required (parallel tempering), after time-period.
        end    
        if (MPI_use) 
            for u in 0:Int64((size ÷ 2) -1 )
                true_val = parallel_tempering(N, E_data, M_arr, 2*u+1, 2*u+2)
				MPI.Send(true_val, comm; dest= u, tag=70)
				MPI.Send(true_val, comm; dest= u+1, tag=70)
            end
        end
    end

end

MPI.finalize()
