import matplotlib.pyplot as plt
import numpy as np
from scipy.optimize import curve_fit

#x = np.array([3,9,18,30])
#y = np.array([1,2.2,6.6,74.4])
#
#f = lambda X,a,b : a*np.exp(X/b)
#x_arr = np.arange(3,30,0.1)
#p_opt, p_cov = curve_fit(f, x, y)
#
#plt.scatter(x,y,label="numerical data",color="blue")
#plt.plot(x_arr , f(x_arr , *p_opt), label="%.1fexp[N/%.2f]"%(p_opt[0],p_opt[1]))
#print(p_opt)
#
#plt.xlabel("N")
#plt.ylabel("t")
#plt.title("kagome Ising model (M=10^8)")
#plt.legend(fontsize=15)
#plt.show()

x = np.array([8,16,24,48])
y = np.array([26.507310330754287, 61.18338364559991, 86.75265855554196, 186.81779224958473])

f = lambda X,a,b : b*(X**a)
x_arr = np.arange(8,48,0.1)
p_opt, p_cov = curve_fit(f, x, y)

plt.scatter(x,y,label="numerical data",color="blue")
#plt.plot(x_arr , f(x_arr , *p_opt), label="{0:0.1f} L^{1:0.1f}".format(p_opt[0],p_opt[1]))
plt.plot(x_arr , f(x_arr , *p_opt), label="~ L^(α/ν), α/ν={0:0.3f}".format(p_opt[0]))
print(p_opt)

plt.xlabel("L",fontsize=15)
plt.ylabel("c", fontsize=15)
plt.title("Baxter Wu model, finite size scaling")
plt.xscale('log')
plt.yscale('log')
plt.legend(fontsize=15)
plt.show()