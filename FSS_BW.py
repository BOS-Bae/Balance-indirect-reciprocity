import numpy as np
import matplotlib.pyplot as plt

num = 30
num += 35
L_arr= [8, 16, 24, 48]
#L_arr= [16,24,32,48,64,80]

dat = np.zeros([len(L_arr), 3, num])
for i in range(len(L_arr)):
    #print(L_arr[i],"\n")
    L = L_arr[i]
    data = np.loadtxt("/home/minwoo/Indirect-reciprocity-network-simulation/dat/L{}_BW_c.dat".format(L), usecols=range(3), delimiter="    ")
    dat[i] = np.transpose(data)
    
T_arr = []
Tc_arr = []
c_arr = []
for i in range(num):
    Temp = dat[0][0][i]
    T_arr.append(Temp)
    
scaling = True
T_critical = 0.755
    
T = np.array(T_arr)
t = (T-T_critical)/T_critical

for i in range(len(L_arr)):
    c_list = ((dat[i][2] - dat[i][1]**2)/(dat[i][0]**2))
    print(L," : ", c_list)
    T_c = T[np.where(c_list == max(c_list))]
    Tc_arr.append(T_c[0])
    c_arr.append(max(c_list)/(L_arr[i]*L_arr[i]))

alpha = 2/3
#nu =(2/3)/(1.065)
nu = 2/3

if (scaling):
    for i in range(len(L_arr)):
        plt.scatter(((L_arr[i])**(1/nu))*t, ((dat[i][2] - dat[i][1]**2)/(L_arr[i]*L_arr[i]*T**2))*(L_arr[i]**(-alpha/nu)),label="L={}".format(L_arr[i]),s=10)
else:
    for i in range(len(L_arr)):
        plt.scatter(t, ((dat[i][2] - dat[i][1]**2)/(L_arr[i]*L_arr[i]*T**2)),label="L={}".format(L_arr[i]),s=10)
        
print(L_arr, "\n")
print(Tc_arr, "\n")
print(c_arr)

plt.legend()

if (scaling):
    plt.xlabel("L^(1/ν)t")
    #plt.ylabel("specific heat")
    plt.ylabel("specific heat scaling function")
    plt.xlim([-50,50])
    #plt.yscale('log')
    plt.title("Baxter Wu : c = L^(α/ν)c'(L^(1/ν)t), α={0:.3f}, ν={1:.3f}".format(alpha, nu))
else:
    plt.xlabel("t (reduced temperatrue)")
    #plt.ylabel("specific heat")
    plt.ylabel("specific heat")
    #plt.yscale('log')
    plt.title("Baxter Wu")
plt.show()