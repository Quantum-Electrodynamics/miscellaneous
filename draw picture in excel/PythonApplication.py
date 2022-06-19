# -*- coding: utf-8 -*-

"""
使用excel绘制图片
"""

__author__ = 'Quantum-Electrodynamics'

import itertools
import xlwings as xw
import cv2 as cv

imgPath=r".\test.png"
xlsPath=r".\test.xlsx"

img=cv.imread(imgPath)
factor=1/5
img=cv.resize(img, None, fx=factor, fy=factor)
width, height=img.shape[:2] #702, 496

app = xw.App(visible=True, add_book=False)
app.api.windowState = -4137
wb = app.books.add()
sht = wb.sheets[0]
pixel=2
sht.range("A:A").api.rowHeight = 0.6 * pixel
sht.range("1:1").api.columnWidth = 0.06 * pixel
offset=(53, 7)

sht.range(sht.cells(1,1), sht.cells(width, height)).offset(*offset).color = [255, 255, 255]
for x, y in itertools.product(range(width), range(height)):
    if not (img[x][y]==255).all():
        sht.cells(x+1,y+1).offset(*offset).color = img[x][y][::-1]

wb.save(xlsPath)
#wb.close()
#app.quit()

p=0