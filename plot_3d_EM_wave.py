import numpy as np
import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d.axes3d as p3
import matplotlib.animation as animation


efield = np.loadtxt('e_field.txt')
hfield = np.loadtxt('h_field.txt')

L = 40
N = 199
M = 1000
x = np.linspace(0, L , N + 2)

# print(len(x))
# print(len(efield))
def update_lines(num, dataLines, lines):
    for line, data in zip(lines, dataLines):
        # NOTE: there is no .set_data() for 3 dim data...
        line.set_data(data[ num , 0:2 , : ])
        line.set_3d_properties(data[ num , 2 , :])
    return lines

fig = plt.figure()
ax = p3.Axes3D(fig)

###### Data preparation ########

# data = M+1 frames, 2 objects to draw , each one has 3 coordinates , and we hace N+2 length for each one

num_objects = 2  # Electromagnetic wave and Magnetic wave

data = np.zeros((num_objects, M+1 ,3,N+2))

for i in range(M+1):
	data[0][i][0] = x
	data[0][i][1] = hfield[i][:N+2]
	data[0][i][2] = 0

	data[1][i][0] = x
	data[1][i][1] = 0
	data[1][i][2] = efield[i][:N+2]
	

# Creating first frame
# NOTE: Can't pass empty arrays into 3d version of plot()

lines = [ax.plot(dat[0,0, :], dat[0,1, :] , dat[0,2,:] )[0] for dat in data]

# lines = np.array([[[ax.plot(dat[0, :], dat[1, :] , dat[2,:])[0]] for dat1 in data] for dat in dat1])


# Setting the axes properties
ax.set_xlim3d([0.0, L])
ax.set_xlabel('X')

ax.set_ylim3d([-0.15, 0.15])
ax.set_ylabel('Y')

ax.set_zlim3d([-18.0, 18.0])
ax.set_zlabel('Z')

ax.set_title('3D Test')

line_ani = animation.FuncAnimation(fig, update_lines, M+1, fargs=(data, lines), interval=20 ,blit = True)

plt.show()



