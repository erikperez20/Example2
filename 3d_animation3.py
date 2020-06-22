import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d.axes3d as p3
import matplotlib.animation as animation



x_data = []
y_data = []


fig , ax = plt.subplots()
ax.set_xlim(0,105)
ax.set_ylim(0,12)
f1, = ax.plot(0,0)

def animation_frame(i):
	x_data.append(i*10)
	y_data.append(i)

	f1.set_xdata(x_data)
	f1.set_ydata(y_data)

	return f1,

ani = animation.FuncAnimation(fig, func = animation_frame, frames=np.arange(0,10,0.01) , interval = 10)
plt.show()