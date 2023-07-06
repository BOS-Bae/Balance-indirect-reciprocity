# Functions for siumulation
using Random

function sum_formulae(O_matrix, e_matrix, N, d, r)
    ΔΘ = 0
    ΔΦ = 0
    ΔΨ = 0
    NList = NeighborList(e_matrix,N,d,r)
    for k in 1:length(NList)
        ΔΘ += (tri_balance(O_matrix, d, k, r) - edge_balance(O_matrix, d, k))
        ΔΦ += ((edge_balance(O_matrix, r, k) - tri_balance(O_matrix, r, d, k)) + (1 - tri_balance(O_matrix, k, d, r)) 
        + (1 - tri_balance(O_matrix, k, r, d)))

        for l in 1:N
            if (e_matrix[l,k] == 1 && e_matrix[l,d] == 1 && e_matrix[l,r] == 1 && l!=k && l!=d && l!=r)
                # calculate ΔΨ on Q
                ΔΨ += ((1 - tetrad_balance(O_matrix, k, l, d, r)) + (tri_balance(O_matrix, l, r, k) - tetrad_balance(O_matrix, r, l, d, k)) 
                + (tri_balance(O_matrix, k, r, l) - tetrad_balance(O_matrix, r, k, d, l)))
            end
        end
    end
    ΔΘ += (1 - edge_balance(O_matrix, d, r))

    arr = [ΔΘ, ΔΦ, ΔΨ]
    return arr
end

function sum_nuemrical(O_matrix, N, eList, triList, d, r)
    ΔΘ = 0
    ΔΦ = 0
    ΔΨ = 0

end

function tetrad_balance(O_matrix, k, l, d, r)
    return O_matrix[k,d]*O_matrix[k,r]*O_matrix[l,d]*O_matrix[l,r]
end

function tri_balance(O_matrix, k, d, r)
    return O_matrix[k,d]*O_matrix[k,r]*O_matrix[d,r]
end

function edge_balance(O_matrix, d, r)
    return O_matrix[d,r]*O_matrix[r,d]
end

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
            idx_1 = eList_init[x][1]
            idx_2 = eList_init[x][2]
            for idx_3 = 1:N
                if (Mat_zero[idx_1,idx_3] ==1 && Mat_zero[idx_2,idx_3] == 1 && idx_2 < idx_3 )
                    input_list_T = []
                    n_T_init += 1
                    push!(input_list_T, idx_1,idx_2,idx_3)
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

# 'L6_rule_dr_all' is a function for parallel update.
function L6_rule_dr_all(O_matrix, New_matrix, neigh_arr, d, r)
    for k in 1:length(neigh_arr)
        α = neigh_arr[k]
        New_matrix[α,d] = O_matrix[α,r] * O_matrix[d,r]
    end     
end

function L6_rule(O_matrix, neigh_arr, d, r)
    for k in 1:length(neigh_arr)
        α = neigh_arr[k]
        O_matrix[α,d] = O_matrix[α,r] * O_matrix[d,r]
    end     
end

function L5_rule(O_matrix, neigh_arr, d, r)
    for k in 1:length(neigh_arr)
        α = neigh_arr[k]
        if (O_matrix[d,r] == 1)
            if (O_matrix[α,d] == 1)
                O_matrix[α,d] = O_matrix[α,r]
            elseif (O_matrix[α,d] == -1)
                O_matrix[α,d] = 1
            end
        elseif (O_matrix[d,r] == -1)
            O_matrix[α,d] = -O_matrix[α,r]
        end
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

function L3_rule(O_matrix, neigh_arr, d, r)
    for k in 1:length(neigh_arr)
        α = neigh_arr[k]
        if (O_matrix[d,r] == 1)
            O_matrix[α,d] = 1
        elseif (O_matrix[d,r] == -1)
            O_matrix[α,d] = -O_matrix[α,r]
        end
    end
end

function L2_rule(O_matrix, neigh_arr, d, r)
    c_d = 0
    if (O_matrix[d,d]==1)
        c_d =  O_matrix[d,r]
    elseif (O_matrix[d,d]==-1)
        c_d = 1
    end

    for k in 1:length(neigh_arr)
        α = neigh_arr[k]
        if (c_d == 1)
            if (O_matrix[α,d] == 1)
                O_matrix[α,d] = O_matrix[α,r]
            elseif (O_matrix[α,d] == -1)
                O_matrix[α,d] = 1
            end
        elseif (c_d == -1)
            if (O_matrix[α,d] == 1)
                O_matrix[α,d] = -O_matrix[α,r]
            elseif (O_matrix[α,d] == -1)
                O_matrix[α,d] = -1
            end
        end
    end
end


function L6_rule_ab(O_matrix,α, d, r)
    val = O_matrix[α,r] * O_matrix[d,r]
    return val
end

function L5_rule_ab(O_matrix,α, d, r)
    val = 0
    if (O_matrix[d,r] == 1)
        if (O_matrix[α,d] == 1)
            val = O_matrix[α,r]
        elseif (O_matrix[α,d] == -1)
            val = 1
        end
    elseif (O_matrix[d,r] == -1)
        val = -O_matrix[α,r]
    end
    return val
end

function L4_rule_ab(O_matrix,α, d, r)
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

function L3_rule_ab(O_matrix,α, d, r)
    val = 0
    if (O_matrix[d,r] == 1)
        val = 1
    elseif (O_matrix[d,r] == -1)
        val = -O_matrix[α,r]
    end
    return val
end

function L2_rule_ab(O_matrix,α, d, r)
    val = 0
    c_d = 0
    if (O_matrix[d,d]==1)
        c_d =  O_matrix[d,r]
    elseif (O_matrix[d,d]==-1)
        c_d = 1
    end

    if (c_d == 1)
        if (O_matrix[α,d] == 1)
            val = O_matrix[α,r]
        elseif (O_matrix[α,d] == -1)
            val = 1
        end
    elseif (c_d == -1)
        if (O_matrix[α,d] == 1)
            val = -O_matrix[α,r]
        elseif (O_matrix[α,d] == -1)
            val = -1
        end
    end
    return val
end

function Opinions_average(O_matrix, e_matrix, N)
    connect_count = 0
    o_averaged = 0

    for m in 1:N
        for n in 1:N
            if (e_matrix[m,n] == 1)
                connect_count += 1
                o_averaged += O_matrix[m,n]
            end
        end
    end
    o_averaged = o_averaged/connect_count
    return o_averaged
end

function count_structure(e_matrix, N)
    
    T = 0
    Q = 0
    R = 0
    
    while true
        d = rand(1:N)
        r = rand(1:N)
        if (e_matrix[d,r] == 1 && d!=r)
            for m in 1:N
                if (e_matrix[m,d] == 1 && e_matrix[m,r] == 1 && m!=d && m!=r)
                    T += 1
                end

                for n in 1:N
                    if (e_matrix[m,d] == 1 && e_matrix[m,r] == 1 && e_matrix[n,d] == 1 && e_matrix[n,r] == 1 && e_matrix[m,n] == 1 && m!=n && m!=d && m!=r && n!=d && n!=r) 
                        Q += 1
                    elseif (e_matrix[m,d] == 1 && e_matrix[m,r] == 1 && e_matrix[n,d] == 1 && e_matrix[n,r] == 0 && e_matrix[m,n] == 1 && n>m && m!=d && m!=r && n!=d && n!=r) 
                        R += 1
                    end
                end
            end
        end
        if (e_matrix[d,r] == 1 && d!=r)
            break
        end
    end
    
    return [T, Q, R]
end

function original_update(rule, O_matrix, e_matrix, N, τ_tmp)
    
    d = rand(1:N)
    r = rand(1:N)
    
    if (e_matrix[d,r] == 1)
        τ_tmp += 1
        NList = NeighborList(e_matrix,N,d,r)
        rule(O_matrix, NList, d, r)
    end
    return τ_tmp
end

function d_r_pair_update(rule, O_matrix, e_matrix, N, τ_tmp, d, r)
    
    if (e_matrix[d,r] == 1)
        τ_tmp += 1
        NList = NeighborList(e_matrix,N,d,r)
        rule(O_matrix, NList, d, r)
    end
    return τ_tmp
end

function random_sequential_update(rule, O_matrix, e_matrix, N, τ_tmp)
    
    Random_i_list = 1:N
    d_arr = shuffle(Random_i_list)
    r_arr = shuffle(Random_i_list)
    
    for d in d_arr
        for r in r_arr
            if (e_matrix[d,r] == 1)
                NList = NeighborList(e_matrix,N,d,r)
                rule(O_matrix, NList, d, r)
            end
        end
    end
    τ_tmp += 1
    return τ_tmp
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
            idx_1 = triad_arr[triad_idx][1]
            idx_2 = triad_arr[triad_idx][2]
            idx_3 = triad_arr[triad_idx][3]

            ϕ = O_matrix[idx_1,idx_2] * O_matrix[idx_1,idx_3] * O_matrix[idx_2,idx_3]

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

function Check_absorbing(O_matrix, e_matrix, N, rule)
    val = 0
    check_val = 0
    true_val = false
    for i in 1:N
        for j in 1:N
            for k in 1:N
                if (e_matrix[i,j] == 1 &&  e_matrix[i,k] == 1 &&  e_matrix[j,k] == 1)
                    val += 1
                    if (O_matrix[i,j] == rule(O_matrix,i, j, k))
                        check_val += 1
                    end
                end
            end
        end
    end
    if (val == check_val)
        true_val = true
    end
    return true_val
end

function Balance(O_matrix, e_matrix, N, edge_arr, triad_arr, N_edge, N_triad)
    θ = 0
    ϕ = 0
    ψ = 0
    N_tetrad = 0

    for edge_idx in 1:N_edge
        idx_1 = edge_arr[edge_idx][1]
        idx_2 = edge_arr[edge_idx][2]

        θ += edge_balance(O_matrix, idx_1, idx_2)
    end

    for triad_idx in 1:N_triad
        idx_1 = triad_arr[triad_idx][1]
        idx_2 = triad_arr[triad_idx][2]
        idx_3 = triad_arr[triad_idx][3]
        
        ϕ += tri_balance(O_matrix, idx_1, idx_2, idx_3)
        ϕ += tri_balance(O_matrix, idx_1, idx_3, idx_2)
        ϕ += tri_balance(O_matrix, idx_2, idx_1, idx_3)
        ϕ += tri_balance(O_matrix, idx_2, idx_3, idx_1)
        ϕ += tri_balance(O_matrix, idx_3, idx_1, idx_2)
        ϕ += tri_balance(O_matrix, idx_3, idx_2, idx_1)

        for idx_4 in 1:N
            if (e_matrix[idx_4,idx_1] == 1 && e_matrix[idx_4,idx_2] == 1 && e_matrix[idx_4,idx_3] == 1 && idx_4!=idx_1 && idx_4!=idx_2 && idx_4!=idx_3)
                N_tetrad += 1
                ψ += tetrad_balance(O_matrix, idx_1, idx_2, idx_3, idx_4)
                ψ += tetrad_balance(O_matrix, idx_1, idx_3, idx_2, idx_4)
                ψ += tetrad_balance(O_matrix, idx_1, idx_4, idx_2, idx_3)
                ψ += tetrad_balance(O_matrix, idx_2, idx_3, idx_1, idx_4)
                ψ += tetrad_balance(O_matrix, idx_3, idx_4, idx_1, idx_2)
                ψ += tetrad_balance(O_matrix, idx_4, idx_2, idx_3, idx_1)
            
            end
        end

    end

    return [θ, ϕ, ψ]
end


function Imbalance(O_matrix, triad_arr, N_triad)
    ϕ = 0
    
    for triad_idx in 1:N_triad
        idx_1 = triad_arr[triad_idx][1]
        idx_2 = triad_arr[triad_idx][2]
        idx_3 = triad_arr[triad_idx][3]

        ϕ += tri_balance(O_matrix, idx_1, idx_2, idx_3)
        ϕ += tri_balance(O_matrix, idx_1, idx_3, idx_2)
        ϕ += tri_balance(O_matrix, idx_2, idx_1, idx_3)
        ϕ += tri_balance(O_matrix, idx_2, idx_3, idx_1)
        ϕ += tri_balance(O_matrix, idx_3, idx_1, idx_2)
        ϕ += tri_balance(O_matrix, idx_3, idx_2, idx_1)
    end

    Imbalance_val = 0
    
    if N_triad == 0
        Imbalance_val = 0
    else
        Imbalance_val = ( 1 - ( ϕ / (6*N_triad) ) )
    end
    return Imbalance_val
end
