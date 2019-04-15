'''
Introduction: Solution for Question Two
'''
import xlwt
import math
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d
from matplotlib import style
from PartOne import *

# Feature Scaling
def featureNormalize(X):
	X_norm = X;
	mu = np.zeros((1,X.shape[1]))
	sigma = np.zeros((1,X.shape[1]))
	for i in range(X.shape[1]):
		mu[0,i] = np.mean(X[:,i])  # Mean
		sigma[0,i] = np.std(X[:,i])  # Std

	X_norm  = (X - mu) / sigma
	return X_norm,mu,sigma
 
# Cost Computing
def computeCost(X, y, theta):
	m = y.shape[0]

	C = X.dot(theta) - y
	J2 = (C.T.dot(C))/ (2*m)
	return J2
 
# Gradient Descent
def gradientDescent(X, y, theta, alpha, num_iters):
	m = y.shape[0]
	T = 1000
	factor = 0.01
	
	# Store History Loss
	J_history = np.zeros((num_iters, 1))
	for iter in range(num_iters):
		target = np.dot(X, theta)
		loss = target - y
		gradient = np.dot(X.T, loss) / m
		# Here use Simulated Annealing to Optimize Gradient Descent
		pre_theta = theta

		theta = theta - alpha * gradient
		J_history[iter] = computeCost(X, y, theta)

		# Judge whether the loss always moves in best directions
		if J_history[iter] > J_history[iter - 1]:
			# Accept the wrose answer in probability
			delta_E = abs(J_history[iter] - J_history[iter - 1])
			random_num = np.random.rand(1)[0]
			if math.exp(delta_E / T) <= random_num:
				theta = pre_theta

		T -= factor * T

	return J_history,theta
	 
# Result Prediction
def predict(data, theta):
	X = np.array(data)

	the = []
	for ele in theta:
		the.append(ele[0])

	return X.dot(the)

# Do Origin Data Train And Test
iterations = 100000
alpha = 0.001
length = 27

xVars = np.array(GetFactorsSeq(), np.float64)
yVars = np.array(GetResultSeq(), np.float64)

print(xVars[0])

x = xVars.reshape((-1, length))
y = yVars.reshape((-1, 1))

m = y.shape[0]

x, mu, sigma = featureNormalize(x)

for ele in x:
	for loc in range(length):
		if np.isnan(ele[loc]):
			ele[loc] = 0

X = np.hstack([x,np.ones((x.shape[0], 1))])

theta = np.zeros((length+1, 1))

J_history,theta = gradientDescent(X, y, theta, alpha, iterations)

print('Best Weights Combination Found By Gradient Descent: ')

for index in range(len(theta)):
	if index <= 2:
		print('w%d of Mn Prediction Model : %f' % (index, theta[index]))
	elif index >= 3 and index <= 18:
		print('w3_%d of Mn Prediction Model : %f'% (index-3, theta[index]))
	else:
		print('w4_%d of Mn Prediction Model : %f' % (index-19, theta[index]))


'''
plt.plot(J_history)

plt.title('Convergence Graph')
plt.ylabel('Loss')
plt.xlabel('Iter Count')

plt.show()
'''

# Prediction Accuracy Check
predicts = []
loss = []
accuracy = []

for ele in X:
	predicts.append(predict(ele, theta))


for index in range(len(predicts)):
	lossRate = abs(predicts[index] - y[index]) / max(y[index], predicts[index])
	if lossRate == 1:
		print(predicts[index], y[index])
	loss.append(lossRate)
	accuracy.append(1-lossRate)

# print(accuracy)

Mean = 0
for ele in accuracy:
	if ele[0] >= 0 and ele[0] <= 1.0:
		Mean += ele[0]

Mean /= len(accuracy)

# print(Mean)

'''
plt.plot(range(len(predicts)), accuracy)

plt.title('Predict Accuracy Graph Of Mn')
plt.ylabel('Accuracy')
plt.xlabel('Index')

plt.show()
'''

# Do Cross Validation, Dividing into ten parts
part_length = int(len(X) / 10)

Means = []

for index in range(10):
	testX = X[index * part_length : (index+1) * part_length]
	testY = y[index * part_length : (index+1) * part_length]
	trainX_front = X[0 : index * part_length]
	trainX_end = X[(index+1) * part_length : ]
	trainX = np.vstack((trainX_front, trainX_end))
	trainY = np.vstack((y[0 : index * part_length], y[(index+1) * part_length : ]))
	
	theta = np.zeros((length+1, 1))

	J_history, theta = gradientDescent(trainX, trainY, theta, alpha, iterations)

	predicts = []
	loss = []
	accuracy = []

	for ele in testX:
		predicts.append(predict(ele, theta))

	for i in range(len(predicts)):
		lossRate = abs(predicts[i] - testY[i]) / max(testY[i], predicts[i])
		
		loss.append(lossRate)
		accuracy.append(1-lossRate)

	Mean = 0
	for ele in accuracy:
		if ele[0] >= 0 and ele[0] <= 1.0:
			Mean += ele[0]

	Mean /= len(accuracy)
	print('The %dth K-Fold Prediction Accuracy Result -- Optimize With SA: %f' % (index, Mean))
	Means.append(Mean)

Ms = np.array(Means)
print("Mean Accuracy of Cross Validation  -- Mn: %f" % Ms.mean())

plt.plot(range(len(Means)), Means)

plt.title('Cross Validation Accuracy Graph Of Mn -- Optimize With SA')
plt.ylabel('Total Accuracy of each Validation')
plt.xlabel('Validation Order')
plt.ylim(0.9, 1.0)

plt.show()

# Store the predict gain rate file
predicts = []

for ele in X:
	predicts.append(predict(ele, theta))

data5 = xlwt.Workbook()

sheet = data5.add_sheet('Sheet1')

for index in range(len(predicts)):
	sheet.write(index, 0, index)
	sheet.write(index, 1, predicts[index])

data5.save('D-5-C.xlsx')

