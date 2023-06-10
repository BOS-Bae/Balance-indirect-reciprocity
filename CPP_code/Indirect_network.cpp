#include <iostream>
#include <random>
#include <vector>

using namespace std;

void Opinion_Initialize(int **O, int N, double uni_p)
{
    int i, j;
    for (i=0;i<N;i++){
        for (j=0;j<N;j++){
            O[i][j] = (uni_p < 0.5) ? 1 : -1; 
        }
    }
}

void ER_network_gen(int **Net, double p, int N, vector<vector<int>> E_List, vector<vector<int>> T_List, int n_E, int n_T, double uni_p)
{
    vector<int> input_element, input_element_T;
    int i, j;
    n_E = n_T = 0;
    int first_idx, second_idx, third_idx;
    for (i=0; i<N; i++){
        for (j=i; j<N; j++){
            if (i!=j){
                input_element = {};
                Net[i][j] = (uni_p < p) ? 1 : 0;
                n_E += 1;
                input_element.push_back(i);
                input_element.push_back(j);
                E_List.push_back(input_element);
                Net[i][j] = Net[j][i];
            }
            else Net[i][j] =  1;
        }
    }
    if (n_E != 0){
        for (i=0; i<N; i++){
            first_idx = E_List[i][0];
            second_idx = E_List[i][1];
            for (third_idx=0; third_idx<N; third_idx++){
                if ((Net[first_idx][second_idx] == 1) && (Net[second_idx][third_idx] == 1) && (second_idx < third_idx)){
                    n_T +=1 ;
                    input_element_T = {};
                    input_element_T.push_back(first_idx);
                    input_element_T.push_back(second_idx);
                    input_element_T.push_back(third_idx);
                    T_List.push_back(input_element_T);
                }   
            }
        }
    }
}

void NeighborList(int **Net, vector<int> n_arr, int N, int d, int r, int n_neighbor)
{
    int k;
    n_neighbor = 0;
    for (k=0; k<N; k++){
        if (Net[k][d] == 1 && Net[k][r] == 1) {
            n_arr.push_back(k);
            n_neighbor += 1;
        }
    }
}

void o_update(int norm, int **O, int **Net, vector<int> n_arr, int n_neighbor, int N, int d, int r, int t_tmp)
{
    int cooperate;
    int m, k;
    cooperate = 0; // cooperate = 1 : C / cooperate = -1 : D
    if (Net[d][r] == 1) {
        t_tmp += 1;
        NeighborList(Net, n_arr, N, d, r, n_neighbor);
        
        switch (norm)
        {
        case 2:
            cooperate = (O[d][d] == 1) ? O[d][r] : 1;
            for (m=0; m<n_neighbor; m++){
                k = n_arr[m];
                if (cooperate == 1) O[k][d] = (O[k][d] == 1) ? O[k][r] : 1;
                else O[k][d] = -1;
            }
            break;
        case 3:
            for (m=0; m<n_neighbor; m++){
                k = n_arr[m];
                O[k][d] = (O[d][r] == 1) ? 1 : -O[k][r];
            }
            break;
        case 4:
            for (m=0; m<n_neighbor; m++){
                k = n_arr[m];
                if (O[d][r] == 1) O[k][d] = (O[k][d] == -1) ? O[k][r] : O[k][d];
                else O[k][d] = -O[k][r];
            }
            break;
        case 5:
            for (m=0; m<n_neighbor; m++){
                k = n_arr[m];
                if (O[d][r] == 1) O[k][d] = (O[k][d] == 1) ? O[k][r] : 1;
                else O[k][d] = -O[k][r];
            }
            break;
        case 6:
            for (m=0; m<n_neighbor; m++){
                k = n_arr[m];
                O[k][d] = O[k][r] * O[d][r];
            }
            break;
        }
    }
}

bool Check_fixation(int **O, vector<vector<int>> E_List, vector<vector<int>> T_List, int N, int n_E, int n_T)
{
    int self_img, Theta_tot, Phi_tot, Phi;
    bool true_self, true_edge, true_triad;
    int first_idx, second_idx, third_idx;

    self_img = Theta_tot= Phi_tot = Phi = 0;
    true_self = true_edge = true_triad = false;
    int self_idx, edge_idx, triad_idx;

    for (self_idx=0; self_idx<N; self_idx++){
        if (O[self_idx][self_idx] == 1) self_img +=1;
    }

    if (self_img == N) true_self = true;

    if (n_E != 0){
        for (edge_idx=0; edge_idx<n_E; edge_idx++){
            first_idx = E_List[edge_idx][0];
            second_idx = E_List[edge_idx][1];
            if (O[first_idx][second_idx] == O[second_idx][first_idx]) Theta_tot += 1;
        }
    }
    if (Theta_tot == n_E) true_edge = true;

    if (n_T != 0){
        for (triad_idx=0; triad_idx<n_T; triad_idx++){
            first_idx = T_List[triad_idx][0];
            second_idx = T_List[triad_idx][1];
            third_idx = T_List[triad_idx][2];

            Phi = O[first_idx][second_idx] * O[first_idx][third_idx] * O[second_idx][third_idx];

            if (Phi == 1) Phi_tot += 1;
        }
    }
    if (Phi_tot == n_T) true_triad = true;
    return (true_self && true_edge && true_triad);
}
//ER_network_gen(Mat_zero, p, N, eList_init, triList_init)
/*
if (Φ_tot == N_triad)
        true_triad = true
    end
*/
