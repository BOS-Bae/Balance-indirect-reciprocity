import numpy as np
import matplotlib.pyplot as plt

num = 49

scaling = True
T_critical = 0.757
L_arr= [64,80]
#L_arr= [24,48,64,80]

dat = np.zeros([len(L_arr), 5, num])
for i in range(len(L_arr)):
    #print(L_arr[i],"\n")
    L = L_arr[i]
    #print(i,"\n")
    data = np.loadtxt("./dat_Baxter_Wu/L{}/L{}_BW.dat".format(L,L), usecols=range(5), delimiter="    ")
    dat[i] = np.transpose(data)

T_arr = []
Tc_arr = []
c_arr = []
for i in range(num):
    Temp = dat[0][0][i]
    T_arr.append(Temp)

T = np.array(T_arr)

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
        N=L_arr[i]*L_arr[i]
        t = (T - T_critical)/T_critical

        plt.scatter(((L_arr[i])**(1/nu))*t, (dat[i][3])*(L_arr[i]**(-alpha/nu)),label="L={}".format(L_arr[i]),color=color_arr[i],s=10)
        plt.plot(((L_arr[i])**(1/nu))*t,  (dat[i][3])*(L_arr[i]**(-alpha/nu)) ,marker=".",color=color_arr[i])
        
else:
    t = (T - T_critical)/T_critical
    for i in range(len(L_arr)):
        N=L_arr[i]*L_arr[i]
        plt.scatter(T, (dat[i][3]) ,label="L={}".format(L_arr[i]),color=color_arr[i],s=10)
        plt.errorbar(T, (dat[i][3]), yerr=(dat[i][4]), color=color_arr[i])
        plt.plot(T, (dat[i][3])  ,marker=".",color=color_arr[i])
        
print(L_arr, "\n")
print(Tc_arr, "\n")
print(c_arr)

plt.legend()

if (scaling):
    plt.xlabel("L^(1/ν)t")
    #plt.ylabel("specific heat")
    plt.ylabel("specific heat scaling function")
    #plt.yscale('log')
    plt.title("Baxter Wu : c = L^(α/ν)c'(L^(1/ν)t), α={0:.3f}, ν={1:.3f}".format(alpha, nu))
else:
    plt.xlabel("T")
    #plt.ylabel("specific heat")
    plt.ylabel("specific heat")
    #plt.yscale('log')
    plt.xlim(0.72,0.8)
    plt.title("Baxter Wu")
plt.show()