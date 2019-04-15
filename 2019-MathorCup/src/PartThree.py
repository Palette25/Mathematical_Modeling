'''
Introduction: Solution for Question Three
'''
from PartOne import *
from scipy import optimize
import matplotlib.pyplot as plt
import numpy as np
import xlrd
import xlwt

Iron_Names = ['HRB500B', '20MnKB', 'HRB400D', 'HRB400B', 'HRB500D', 'Q235A', 'Q235', '20MnKA', 'Q345B']

def ReadIronConstraint():
	res = []

	data3 = xlrd.open_workbook(r'../data/钢筋化学元素含量国家标准.xlsx')
	sheet = data3.sheet_by_name('Sheet1')

	for index in range(9):
		element_range = []
		temp = []
		for k in range(5):
			element_range.append(sheet.cell_value(index+2, k+2))
		for ele in element_range:
			arr = ele.split('-')
			temp.append([float(arr[0]) * 0.01, float(arr[1]) * 0.01])

		res.append(temp)

	return res

def GetOriginElementDiv():
	res = [[], [], [], [], [], [], [], [], []]

	data1 = xlrd.open_workbook(r'../data/D-1.xlsx')
	sheet = data1.sheet_by_name('Sheet5')

	for index in range(1, 1717):
		iron_name = (sheet.cell_value(index, 2)).strip()
		iid = (sheet.cell_value(index, 0)).strip()
		iid = iid[3:]

		Origin = []
		Origin.append(int(iid))

		for i in range(5):
			temp = sheet.cell_value(index, i + 4)
			if temp == '':
				return res
			Origin.append(float(temp))

		Origin.append(int(sheet.cell_value(index, 9)))
		for i in range(28, 32):
			temp = sheet.cell_value(index, i)
			Origin.append(float(temp))
		for i in range(33, 45):
			temp = sheet.cell_value(index, i)
			Origin.append(float(temp))

		target_id = -1
		if iron_name == 'HRB500B':
			target_id = 0
		elif iron_name == '20MnKB':
			target_id = 1
		elif iron_name == 'HRB400D':
			target_id = 2
		elif iron_name == 'HRB400B':
			target_id = 3
		elif iron_name == 'HRB500D':
			target_id = 4
		elif iron_name == 'Q235A':
			target_id = 5
		elif iron_name == 'Q235':
			target_id = 6
		elif iron_name == '20MnKA':
			target_id = 7
		else:
			target_id = 8

		res[target_id].append(Origin)

	return res

def GetPriceAndContent():
	data2 = xlrd.open_workbook(r'../data/D-2.xlsx')
	sheet = data2.sheet_by_name('Sheet1')

	price = []
	Contents = []
	for index in range(1, 17):
		price.append(int(sheet.cell_value(index, 10)) / 1000)

	for index in range(1, 17):
		temp = []
		for i in range(1, 6):
			content = sheet.cell_value(index, i)
			if content == '':
				temp.append(0.0)
			else:
				temp.append(float(content))
		Contents.append(temp)

	return price, Contents

def Cmp(a):
	return a[0]

if __name__ == '__main__':
	Constraint = ReadIronConstraint()
	# According to different Iron Type, Read Predict Gain_Rate and History Origin Elements Value
	Gain_Rate_Div = GetGainRateDiv()
	Origin_Element_Div = GetOriginElementDiv()

	# We need for different Iron Types, the five elements should input how much
	Need_Element_Value = [[], [], [], [], [], [], [], [], []]

	for index in range(9):
		ele = Origin_Element_Div[index]
		cons = Constraint[index]
		
		j = 0
		for el in ele:
			Need = []
			Need.append(el[0])
			for i in range(1, 6):
				need = 0.0
				origin_ele = el[i]
				if origin_ele >= cons[i-1][0]:
					need = 0.0
				else:
					need = cons[i-1][0] - origin_ele
				# Divide to the Gain Rate
				target_gain_rate = Gain_Rate_Div[i-1][index][j]

				Need.append(need / target_gain_rate * el[6])
			j += 1
				
			Need_Element_Value[index].append(Need)
			
	# print(Need_Element_Value)

	# Read in Metal Source price and elements content inside each metal
	price, Contents = GetPriceAndContent()
	# Target Minize Function
	Min_Target_Func = price
	Min_Target_Func = np.array(Min_Target_Func)

	Contents = np.array(Contents)
	Contents = Contents.T

	'''
	Define Linear Planning Eqation Set:
		1. All used metals must fit elements needed for the problem
		2. All used metals should cost the least money 
	'''
	Result_Price = []
	Result_X = []
	Old_Price = []

	for index in range(9):
		temp = Need_Element_Value[index]
		if len(temp) == 0:
			continue

		for ele in temp:
			Conditions = []
			for i in range(1, 6):
				Conditions.append(ele[i])
			Conditions = np.array(Conditions)

			# Perform Linear Optimize
			res = optimize.linprog(c=Min_Target_Func, A_eq=Contents, b_eq=Conditions, method='interior-point', bounds=((0,None),(0,None),(0,None),(0,None),(0,None),(0,None),(0,None),(0,None),(0,None),(0,None),(0,None),(0,None),(0,None),(0,None),(0,None),(0,None)))
			
			Result_X.append([ele[0], res.x])
			Result_Price.append([ele[0], res.fun])


	for index in range(9):
		ele = Origin_Element_Div[index]

		for el in ele:
			temp = el[7:]
			Old_Price.append([el[0], np.array(temp).dot(Min_Target_Func)])

	Result_Price.sort(key=Cmp, reverse=True)
	Result_X.sort(key=Cmp, reverse=True)
	Old_Price.sort(key=Cmp, reverse=True)

	Reduce_Arr = []
	Result_Arr = []

	for index in range(len(Result_Price)):
		if Result_Price[index][1] > 1:
			Result_Arr.append(Result_Price[index][1])
		res = (Old_Price[index][1] - Result_Price[index][1]) / Result_Price[index][1]
		if Result_Price[index][1] > 1:
			Reduce_Arr.append(res)

	print(np.array(Reduce_Arr).mean())
	plt.plot(range(6620, 6620+len(Reduce_Arr)), Reduce_Arr)

	plt.xlabel('Metal-Making Process Order Number')
	plt.ylabel('Cost Reduce Rate')
	plt.ylim(0.0, 200.0)
	plt.title('Minimize Produce Cost Model Result')

	plt.show()

	# Write Out the result
	'''
	data4 = xlwt.Workbook()

	sheet = data4.add_sheet('Sheet1')

	for index in range(len(Result_X)):
		x = Result_X[index]
		res = Result_Price[index]
		sheet.write(index, 0, x[0])
		i = 1
		for ele in x[1]:
			sheet.write(index, i, ele)
			i += 1

		sheet.write(index, i, res[1])

	data4.save('D-4.xlsx')
	'''