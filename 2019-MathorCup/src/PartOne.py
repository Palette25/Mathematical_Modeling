'''
Introduction: Solution for Question One
'''

def plotGainRate(arr, title):
	plt.plot(range(1, len(arr)+1), arr)

	plt.title(title)
	plt.xlabel('Record History Order')
	plt.ylabel('Gain Rate')

	plt.show()

def plotFactor(x_arr, y_arr, title):
	x = range(len(x_arr))

	plt.plot(x, y_arr)
	plt.xticks(x, x_arr, rotation=20)

	plt.title(title)
	plt.xlabel('相关因素')
	plt.ylabel('相关性系数')

	plt.show()

def GetFactorsSeq(flag=0):
	Records = []
	OtherElements = []

	if flag == 0:
		length = len(Gain_Rate_C)
		Records = Records_C
		OtherElements = OtherElements_C
	elif flag == 1:
		length = len(Gain_Rate_Mn)
		Records = Records_Mn
		OtherElements = OtherElements_Mn
	elif flag == 2:
		length = len(Gain_Rate_S)
		Records = Records_S
		OtherElements = OtherElements_S
	elif flag == 3:
		length = len(Gain_Rate_P)
		Records = Records_P
		OtherElements = OtherElements_P
	elif flag == 4:
		length = len(Gain_Rate_Si)
		Records = Records_Si
		OtherElements = OtherElements_Si

	res = []

	# Influence Used Material Content
	Materials = []

	for ele in Records:
		mat = []
		for index in range(13, 17):
			mat.append(ele[index])
		for index in range(18, 29):
			mat.append(ele[index])
		Materials.append(mat)

	Materials = np.transpose(Materials)

	index = 0
	for ele in Records:
		temp = []
		temp.append(ele[1])
		temp.append(ele[flag + 8] - ele[flag + 2])
		temp.append(ele[7])
		temp.append(ele[len(ele) - 1])

		for loc in range(len(M_Orders)):
			temp.append(Materials[loc][index])
		
		for loc in range(len(OtherElements)):
			temp.append(OtherElements[loc][index])
		
		res.append(temp)
		index += 1

	return res

def GetResultSeq(flag=0):
	if flag == 0:
		return Gain_Rate_C
	elif flag == 1:
		return Gain_Rate_Mn
	elif flag == 2:
		return Gain_Rate_S
	elif flag == 3:
		return Gain_Rate_P
	elif flag == 4:
		return Gain_Rate_Si

def GetGainRateDiv():
	return Gain_Rate_Div

def Calculate_Gain_Rate(record, index1, index2, order):
	originC = record[index1]
	resultC = record[index2]
	totalWeight = record[7]
	# Check whether number
	if originC == '' or resultC == '':
		return -1

	improveC = 0.0
	materialC = 0.0
	if resultC > originC:
		improveC = float(resultC * totalWeight * (0.98) - originC * totalWeight)
	# Calculate used materials
	for loc in range(len(Cons)+1):
		if record[loc+13] > 0:
			if loc <= 4:
				materialC += record[loc+13] * Cons[loc][order]
			else :
				materialC += record[loc+13] * Cons[loc-1][order]

	if materialC == 0:
		return 0
	else:
		return improveC / materialC


def Calculate_CorrCoef(Records, OtherElements, Gain_Rate, target_index, name, M_Orders):
	Corr = []
	# Influence Improve Content
	Temperature = []
	IronWaterWeight = []
	OutOxygen = []
	Origin = []

	for ele in Records:
		Origin.append(ele[target_index])
		Temperature.append(ele[1])
		IronWaterWeight.append(ele[7])
		OutOxygen.append(ele[29])

	Corr_T = np.corrcoef(Temperature[:len(Gain_Rate)], Gain_Rate)
	Corr_O = np.corrcoef(Origin[:len(Gain_Rate)], Gain_Rate)
	Corr_I = np.corrcoef(IronWaterWeight[:len(Gain_Rate)], Gain_Rate)
	Corr_Ox = np.corrcoef(OutOxygen[:len(Gain_Rate)], Gain_Rate)

	Corr.append(Corr_T[0][1])
	Corr.append(Corr_O[0][1])
	Corr.append(Corr_I[0][1])
	Corr.append(Corr_Ox[0][1])

	# Influence Used Material Content
	Materials = []

	for ele in Records:
		mat = []
		for index in range(13, 17):
			mat.append(ele[index])
		for index in range(18, 29):
			mat.append(ele[index])
		Materials.append(mat)

	Materials = np.transpose(Materials)

	for index in range(len(M_Orders)):
		Corr_Temp = np.corrcoef(Materials[index][:len(Gain_Rate)], Gain_Rate)

		if np.isnan(Corr_Temp[0][1]):
			Corr.append(0)
		else:
			Corr.append(Corr_Temp[0][1])

	List_Names = np.hstack((['温度', '转炉终点' + name, '钢水重量', '硅钙碳脱氧剂'], M_Orders))

	#plotFactor(List_Names, Corr, '影响' + name + '收得率的因素相关性检测 - Part 1')

	OE = np.array(OtherElements)
	OE_Res = []

	for ele in OE:
		Corr_Temp = np.corrcoef(ele[:len(Gain_Rate)], Gain_Rate)
		OE_Res.append(Corr_Temp[0][1])
		Corr.append(Corr_Temp[0][1])


	OE_Names = ['Ceq_Val', 'Cr', 'Ni_Val', 'Cu_Val', 'V_Val', 'Alt_Val', 'Als_Val', 'Mo_Val']

	
	x = range(len(OE_Names))
	'''
	plt.plot(x, OE_Res)
	plt.xticks(x, OE_Names, rotation=20)

	plt.title('影响 %s 收得率的因素相关性检测 - Part 2' % name)
	plt.xlabel('钢水中其余元素的种类')
	plt.ylabel('相关性系数')

	plt.show()
	'''
	List_Names = np.hstack([List_Names, OE_Names])
	for index in range(len(Corr)):
		temp = Corr[index]
		Corr[index] = [temp, List_Names[index]]

	Corr.sort(key=Corr_Cmp, reverse=True)

	for index in range(10):
		pass
		# print('The %dth Influence Factor of %s is : %s, and the Correlation Coef Result : %f' % (index, name, Corr[index][1], Corr[index][0]))


def Corr_Cmp(a):
	return abs(a[0])

# Read Origin History Data
import matplotlib.pyplot as plt
import numpy as np
import xlrd

plt.rcParams['font.sans-serif']=['SimHei']
plt.rcParams['axes.unicode_minus']=False

Names = [[], [], [], [], []]
Records_C = []
Records_Mn = []
Records_S = []
Records_P = []
Records_Si = []

Cons = []

data1 = xlrd.open_workbook(r'../data/D-1.xlsx')
data2 = xlrd.open_workbook(r'../data/D-2.xlsx')

sheet = data1.sheet_by_name('Sheet5')
sheet1 = data2.sheet_by_name('Sheet1')

OtherElements_C = [[], [], [], [], [], [], [], []]
OtherElements_Mn = [[], [], [], [], [], [], [], []]
OtherElements_S = [[], [], [], [], [], [], [], []]
OtherElements_P = [[], [], [], [], [], [], [], []]
OtherElements_Si = [[], [], [], [], [], [], [], []]

# Read Iron Elements construction
for index in range(1, 17):
	cons = []
	for loc in range(1, 11):
		if sheet1.cell_value(index, loc) == '':
			cons.append(0.0)
		else:
			cons.append(float(sheet1.cell_value(index, loc)))
	Cons.append(cons)


# Read History Records
for index in range(1, 1717):
	record = []
	ss = (sheet.cell_value(index, 2)).strip()
	record.append(ss)

	for loc in range(3, 15):
		ss = sheet.cell_value(index, loc)
		if ss == '':
			record.append(0.0)
		else:
			record.append(sheet.cell_value(index, loc))
	for loc in range(28, 45):
		record.append(sheet.cell_value(index, loc))

	# Judge whether the gain rate exceed 1, otherwise delete the record
	grc = Calculate_Gain_Rate(record, 2, 8, 0)
	grm = Calculate_Gain_Rate(record, 3, 9, 1)
	grs = Calculate_Gain_Rate(record, 4, 10, 2)
	grp = Calculate_Gain_Rate(record, 5, 11, 3)
	grsi = Calculate_Gain_Rate(record, 6, 12, 4)

	if grc < 1.0 and grc > 0.0:
		Records_C.append(record)
		Names[0].append((sheet.cell_value(index, 2)).strip())
		for loc in range(15, 19):
			temp = sheet.cell_value(index, loc)
			if temp != '' and temp != 'NULL':
				OtherElements_C[loc-15].append(float(sheet.cell_value(index, loc)))
		for loc in range(20, 24):
			temp = sheet.cell_value(index, loc)
			if temp != '' and temp != 'NULL':
				OtherElements_C[loc-20+4].append(float(sheet.cell_value(index, loc)))

	if grm < 1.0 and grm > 0.0:
		Records_Mn.append(record)
		Names[1].append((sheet.cell_value(index, 2)).strip())
		for loc in range(15, 19):
			temp = sheet.cell_value(index, loc)
			if temp != '' and temp != 'NULL':
				OtherElements_Mn[loc-15].append(float(sheet.cell_value(index, loc)))
		for loc in range(20, 24):
			temp = sheet.cell_value(index, loc)
			if temp != '' and temp != 'NULL':
				OtherElements_Mn[loc-20+4].append(float(sheet.cell_value(index, loc)))

	if grs < 1.0 and grs > 0.0:
		Records_S.append(record)
		Names[2].append((sheet.cell_value(index, 2)).strip())
		for loc in range(15, 19):
			temp = sheet.cell_value(index, loc)
			if temp != '' and temp != 'NULL':
				OtherElements_S[loc-15].append(float(sheet.cell_value(index, loc)))
		for loc in range(20, 24):
			temp = sheet.cell_value(index, loc)
			if temp != '' and temp != 'NULL':
				OtherElements_S[loc-20+4].append(float(sheet.cell_value(index, loc)))

	if grp < 1.0 and grp > 0.0:
		Records_P.append(record)
		Names[3].append((sheet.cell_value(index, 2)).strip())
		for loc in range(15, 19):
			temp = sheet.cell_value(index, loc)
			if temp != '' and temp != 'NULL':
				OtherElements_P[loc-15].append(float(sheet.cell_value(index, loc)))
		for loc in range(20, 24):
			temp = sheet.cell_value(index, loc)
			if temp != '' and temp != 'NULL':
				OtherElements_P[loc-20+4].append(float(sheet.cell_value(index, loc)))

	if grsi < 1.0 and grsi > 0.0:
		Records_Si.append(record)
		Names[4].append((sheet.cell_value(index, 2)).strip())
		for loc in range(15, 19):
			temp = sheet.cell_value(index, loc)
			if temp != '' and temp != 'NULL':
				OtherElements_Si[loc-15].append(float(sheet.cell_value(index, loc)))
		for loc in range(20, 24):
			temp = sheet.cell_value(index, loc)
			if temp != '' and temp != 'NULL':
				OtherElements_Si[loc-20+4].append(float(sheet.cell_value(index, loc)))

'''
for index in range(len(Cons)):
	print(Cons[index])
'''

Gain_Rate_C = []
Gain_Rate_Mn = []
Gain_Rate_S = []
Gain_Rate_P = []
Gain_Rate_Si = []

IronWaterLoss = 0.02

# Calculate Gain Rate of C
for index in range(len(Records_C)):
	grc = Calculate_Gain_Rate(Records_C[index], 2, 8, 0)
	if grc == -1:
		continue

	Gain_Rate_C.append(grc)
'''
plotGainRate(Gain_Rate_C, 'Gain Rate of C')
GC = np.array(Gain_Rate_C)
print('The Mean History Gain Rate of C: %f' % GC.mean())
'''
# Calculate Gain Rate of Mn
for index in range(len(Records_Mn)):
	grm = Calculate_Gain_Rate(Records_Mn[index], 3, 9, 1)
	if grm == -1:
		continue

	Gain_Rate_Mn.append(grm)
'''
plotGainRate(Gain_Rate_Mn, 'Gain Rate of Mn')
GM = np.array(Gain_Rate_Mn)
print('The Mean History Gain Rate of Mn: %f' % GM.mean())
'''
# Calculate Gain Rate of S
for ele in Records_S:
	grs = Calculate_Gain_Rate(ele, 4, 10, 2)
	if grs == -1:
		continue

	Gain_Rate_S.append(grs)

# plotGainRate(Gain_Rate_S, 'Gain Rate of S')

# Calculate Gain Rate of P
for ele in Records_P:
	grp = Calculate_Gain_Rate(ele, 5, 11, 3)
	if grp == -1:
		continue

	Gain_Rate_P.append(grp)

# plotGainRate(Gain_Rate_P, 'Gain Rate of P')

# Calculate Gain Rate of Si
for ele in Records_Si:
	grsi = Calculate_Gain_Rate(ele, 6, 12, 4)
	if grsi == -1:
		continue

	Gain_Rate_Si.append(grsi)

# plotGainRate(Gain_Rate_Si, 'Gain Rate of Si')

# Accord to Iron Name, divide the gain rate result
Gain_Rate_Div_Sample = [[], [], [], [], [], [], [], [], []]
Gain_Rate_Div = []

for order in range(5):
	Gain_Rate_Div.append(Gain_Rate_Div_Sample)

for order in range(5):
	Gain_Rate = []
	if order == 0:
		Gain_Rate = Gain_Rate_C
	elif order == 1:
		Gain_Rate = Gain_Rate_Mn
	elif order == 2:
		Gain_Rate = Gain_Rate_S
	elif order == 3:
		Gain_Rate = Gain_Rate_P
	else:
		Gain_Rate = Gain_Rate_Si

	for index in range(len(Names[order])):
		if Names[order][index] == 'HRB500B':
			Gain_Rate_Div[order][0].append(Gain_Rate[index])
		if Names[order][index] == '20MnKB':
			Gain_Rate_Div[order][1].append(Gain_Rate[index])
		if Names[order][index] == 'HRB400D':
			Gain_Rate_Div[order][2].append(Gain_Rate[index])
		if Names[order][index] == 'HRB400B':
			Gain_Rate_Div[order][3].append(Gain_Rate[index])
		if Names[order][index] == 'HRB500D':
			Gain_Rate_Div[order][4].append(Gain_Rate[index])
		if Names[order][index] == 'Q235A':
			Gain_Rate_Div[order][5].append(Gain_Rate[index])
		if Names[order][index] == 'Q235':
			Gain_Rate_Div[order][6].append(Gain_Rate[index])
		if Names[order][index] == '20MnKA':
			Gain_Rate_Div[order][7].append(Gain_Rate[index])
		if Names[order][index] == 'Q345B':
			Gain_Rate_Div[order][8].append(Gain_Rate[index])


'''
Basically select influence factors:
* Influence Improve Content
	1. Temperature
	2. Origin Percent of the Element
	3. Iron-Water weight
	4. Out-Oxygen content

* Influence Used Material Content
	1. Materials' content having target Element

'''
M_Orders = ['氮化钒铁', '低铝硅铁', '钒氮合金', '钒铁(FeV50-A)', '钒铁(FeV50-B)', '硅铝钙', 
			'硅铝合金', '硅铝锰合金球', '硅锰面', '硅铁', '硅铁FeSi75-B', '石油焦增碳剂', 
			'锰硅合金FeMn64Si27', '锰硅合金FeMn68Si18', '碳化硅']

# Check C's influence factors
Calculate_CorrCoef(Records_C, OtherElements_C, Gain_Rate_C, 2, 'C', M_Orders)

# 2. Check Mn's Influence Factors
Calculate_CorrCoef(Records_Mn, OtherElements_Mn, Gain_Rate_Mn, 3, 'Mn', M_Orders)

