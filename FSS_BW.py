import numpy as np
import matplotlib.pyplot as plt

num = 30
num += 35

scaling = True
T_critical = 0.757
L_arr= [48,64,80]
#L_arr= [24,48,64,80]

dat2 = np.zeros([len(L_arr), 5, num])
dat = np.zeros([len(L_arr), 5, num]) # for sorting
for i in range(len(L_arr)):
    #print(L_arr[i],"\n")
    L = L_arr[i]
    data = np.loadtxt("/home/minwoo/Indirect-reciprocity-network-simulation/dat/dat_BW/L{}.dat".format(L), usecols=range(5), delimiter="    ")
    dat2[i] = np.transpose(data)

T_arr = []
Tc_arr = []
c_arr = []
for i in range(num):
    Temp = dat2[0][0][i]
    T_arr.append(Temp)

T_arr = np.array(T_arr)
T = sorted(T_arr)
#print(T_arr, "\n")
#print(T)
for i in range(len(L_arr)):
    for l in range(5):
        for j in range(num):
            for k in range(num):
                if (T[j] == T_arr[k]):
                    dat[i][l][j] = dat2[i][l][k]
            
T = np.array(T)
#t = (T-T_critical)/T_critical
#print(dat)
for i in range(len(L_arr)):
    c_list = dat[i][3]
    #print(L," : ", c_list)
    T_c = T[np.where(c_list == max(c_list))]
    Tc_arr.append(T_c[0])
    c_arr.append(max(c_list))

alpha = 2/3
#nu =(2/3)/(1.065)
nu = 2/3
color_arr = ["lightseagreen","blue", "green", "orange" ,"red"]
if (scaling):
    for i in range(len(L_arr)):
        t = (T - T_critical)/T_critical

        plt.scatter(((L_arr[i])**(1/nu))*t, (dat[i][3])*(L_arr[i]**(-alpha/nu)),label="L={}".format(L_arr[i]),color=color_arr[i],s=10)
        plt.plot(((L_arr[i])**(1/nu))*t,  (dat[i][3])*(L_arr[i]**(-alpha/nu)) ,marker=".",color=color_arr[i])
        
else:
    t = (T - T_critical)/T_critical
    for i in range(len(L_arr)):
        plt.scatter(T, (dat[i][3]) ,label="L={}".format(L_arr[i]),color=color_arr[i],s=10)
        plt.plot(T, (dat[i][3])  ,marker=".",color=color_arr[i])
        
print(L_arr, "\n")
print(Tc_arr, "\n")
print(c_arr)

plt.legend()

if (scaling):
    plt.xlabel("L^(1/ν)t")
    #plt.ylabel("specific heat")
    plt.ylabel("specific heat scaling function")
    plt.xlim([-15,15])
    #plt.yscale('log')
    plt.title("Baxter Wu : c = L^(α/ν)c'(L^(1/ν)t), α={0:.3f}, ν={1:.3f}".format(alpha, nu))
else:
    plt.xlabel("T")
    #plt.ylabel("specific heat")
    plt.xlim(0.7,0.8)
    plt.ylabel("specific heat")
    #plt.yscale('log')
    plt.title("Baxter Wu")
plt.show()