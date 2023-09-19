import matplotlib.pyplot as plt
import numpy as np
from scipy.optimize import curve_fit
import sys

L = int(sys.argv[1])
sl = int(sys.argv[2])

dat = np.loadtxt("L{}_T2.269_auto.dat".format(L))[sl_0:sl]

dat /= dat[0]
f = lambda x,a,b,c : (a*np.exp(-(x-b)/c))
p_opt, p_cov = curve_fit(f, np.array(range(sl_0,sl)), dat)
t = np.arange(sl_0,sl, 0.01)

plt.plot(t, f(t , *p_opt), label="{0:0.1f}exp(-(t - {1:0.1f})/{2:0.1f})".format(p_opt[0], p_opt[1], p_opt[2]))
plt.plot(range(sl_0, sl), dat, label = "numerical data")

#plt.plot(t , np.exp(-(t-5000)/30000))

print(p_opt, "\n")
print(range(sl_0,sl)[0])
plt.xlabel("t",fontsize=15)
plt.ylabel("autocorrelation function", fontsize=15)
plt.title("Baxter Wu model, L={}".format(L))
plt.yscale('log')
plt.legend(fontsize=15)
plt.show()
