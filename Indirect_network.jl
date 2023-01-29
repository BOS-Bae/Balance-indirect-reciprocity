# Functions for siumulation
function Opinion_Initialize(O_zero, ρ, N)
    for x in 1:N
        for y in 1:N
            if (rand(Float64) <= ρ)
                O_zero[x,y] = 1
            else
                O_zero[x,y] = -1
            end
        end
    end
end

function ER_network_gen(Mat_zero, p, N, eList_init, triList_init)

    n_e_init = 0
    n_T_init = 0

    for m = 1:N
        for n = m:N
            if (n != m)
                if (rand(Float64) <= p)
                    n_e_init += 1
                    input_list = []
                    Mat_zero[m,n] = 1
                    Mat_zero[n,m] = 1

                    push!(input_list, m)
                    push!(input_list, n)
                    push!(eList_init,input_list)
                    #push!(Anylist, [a,b]) ..
                else
                    Mat_zero[m,n] = 0
                    Mat_zero[n,m] = 0
                end
            else
                Mat_zero[m,n] = 1
                Mat_zero[n,m] = 1
            end
        end
    end

    if (n_e_init != 0)
        for x = 1:n_e_init
            first_idx = eList_init[x][1]
            second_idx = eList_init[x][2]
            for third_idx = 1:N
                if (Mat_zero[first_idx,third_idx] ==1 && Mat_zero[second_idx,third_idx] == 1 && second_idx < third_idx )
                    input_list_T = []
                    n_T_init += 1
                    push!(input_list_T, first_idx,second_idx,third_idx)
                    push!(triList_init,input_list_T)    
                end
            end
        end    
    end
    return [n_e_init, n_T_init] 
end

function NeighborList(Network_mat,N,d,r)
    α_arr = []
    for k in 1:N
        if (Network_mat[k,d] == 1 && Network_mat[k,r] == 1)
            push!(α_arr, k)
        end
    end
    return α_arr
end

function L6_rule_dr_all(O_matrix, New_matrix, neigh_arr, d, r)
    for k in 1:length(neigh_arr)
        α = neigh_arr[k]
        New_matrix[α,d] = O_matrix[α,r] * O_matrix[d,r]
    end     
end
# New_matrix is additional matrix for updated opinions.

# The code below haas to be applied after all opinions are updated.
#=
for d in 1:N
    for r in 1:N
        σ_matrix[d,r] = U_matrix[d,r]
    end
end
=#

function L6_rule(O_matrix, neigh_arr, d, r)
    for k in 1:length(neigh_arr)
        α = neigh_arr[k]
        O_matrix[α,d] = O_matrix[α,r] * O_matrix[d,r]
    end     
end

function L4_rule(O_matrix, neigh_arr, d, r)
    for k in 1:length(neigh_arr)
        α = neigh_arr[k]
        if (O_matrix[d,r] == 1)
            if (O_matrix[α,d] == -1)
                O_matrix[α,d] = O_matrix[α,r]
            end
        elseif (O_matrix[d,r] == -1)
            O_matrix[α,d] = -O_matrix[α,r]
        end
    end
end

function Check_fixation(O_matrix, connection_arr, triad_arr, N, N_edge, N_triad)
    self_image = 0
    Θ_tot = 0
    Φ_tot = 0
        
    true_self = false
    true_edge = false
    true_triad = false
        
    for self_idx = 1:N
        if (O_matrix[self_idx,self_idx] == 1)
            self_image += 1
        end
    end
    if (self_image == N)
        true_self = true
    end
    if (N_edge != 0)
        for edge_idx = 1:N_edge
            one_idx = connection_arr[edge_idx][1]
            rival_idx = connection_arr[edge_idx][2]
            if (O_matrix[one_idx,rival_idx] == O_matrix[rival_idx,one_idx])
                Θ_tot += 1
            end
        end
    end

    if (Θ_tot == N_edge)
        true_edge = true
    end
    if (N_triad != 0)
        for triad_idx = 1:N_triad
            first_idx = triad_arr[triad_idx][1]
            second_idx = triad_arr[triad_idx][2]
            third_idx = triad_arr[triad_idx][3]

            ϕ = O_matrix[first_idx,second_idx] * O_matrix[first_idx,third_idx] * O_matrix[second_idx,third_idx]

            if (ϕ == 1)
                Φ_tot += 1
            end
        end
    end

    if (Φ_tot == N_triad)
        true_triad = true
    end
        
    return true_self && true_edge && true_triad
end

function Imbalance(O_matrix, triad_arr, N_triad)
    ϕ = 0
    ϕ = convert(Float64, ϕ)
    num_triad = 0.0
    for triad_idx = 1:N_triad
        first_idx = triad_arr[triad_idx][1]
        second_idx = triad_arr[triad_idx][2]
        third_idx = triad_arr[triad_idx][3]
        
        ϕ += convert(Float64, O_matrix[first_idx,second_idx] * O_matrix[first_idx,third_idx] * O_matrix[second_idx,third_idx])
        ϕ += convert(Float64, O_matrix[first_idx,third_idx] * O_matrix[first_idx,second_idx] * O_matrix[third_idx,second_idx])
        ϕ += convert(Float64, O_matrix[second_idx,first_idx] * O_matrix[second_idx,third_idx] * O_matrix[first_idx,third_idx])
        ϕ += convert(Float64, O_matrix[second_idx,third_idx] * O_matrix[second_idx,first_idx] * O_matrix[third_idx,first_idx])
        ϕ += convert(Float64, O_matrix[third_idx,first_idx] * O_matrix[third_idx,second_idx] * O_matrix[first_idx,second_idx])
        ϕ += convert(Float64, O_matrix[third_idx,second_idx] * O_matrix[third_idx,first_idx] * O_matrix[second_idx,first_idx])  
    end
    Imbalance_val = 0
    Imbalance_val = convert(Float64, Imbalance_val)
    if N_triad == 0
        Imbalance_val = 0.0
    else
        Imbalance_val = ( 1.0 - ( ϕ / ( 6.0 * convert(Float64, N_triad) ) ))
    end
    return Imbalance_val
end