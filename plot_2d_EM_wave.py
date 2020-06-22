import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d.axes3d as p3
import matplotlib.animation as animation


efield = np.loadtxt('e_field.txt')
hfield = np.loadtxt('h_field.txt')

print(efield[1])

L = 40
N = 199
M = 1000
x = np.linspace(0, L , N + 2)

'''
class matplotlib.animation.FuncAnimation(fig, func, frames=None, init_func=None, 
		fargs=None, save_count=None, *, cache_frame_data=True, **kwargs)[source]
'''

x_data = []
y_data = []


fig , ax = plt.subplots()
ax.grid()
ax.set_xlim(-3,L+5)
ax.set_ylim(-18,18)
f1, = ax.plot(x,efield[0][:N+2])

def animation_frame(i):
	x_data = x
	y_data = efield[i][:N+2]

	f1.set_xdata(x_data)
	f1.set_ydata(y_data)

	return f1,


ani = animation.FuncAnimation(fig,func=animation_frame,frames=np.array(list(range(1,M+1))),interval = 10)

plt.show()

