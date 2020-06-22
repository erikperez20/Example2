import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation


L = 40
N = 199
M = 1000


fig, ax = plt.subplots()
xdata, ydata = [], []
ln, = plt.plot([], [], 'r', animated=True)
f = np.linspace(-3, 3, N+1)


def init():
	ax.set_xlim(-3, 3)
	ax.set_ylim(-0.25, 2)
	ln.set_data(xdata,ydata)
	return ln,

def update(frame):
	xdata.append(frame)
	ydata.append(np.exp(-frame**2))
	ln.set_data(xdata, ydata)
	return ln,

ani = FuncAnimation(fig, update, frames=f, init_func=init, blit=True, interval = 6,repeat=False)
plt.show()



