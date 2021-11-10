import numpy as np
import scipy.signal as signal

t = np.linspace(0, 1.0, 2001)
xlow = np.sin(2 * np.pi * 5 * t)
xhigh = np.sin(2 * np.pi * 250 * t)
x = xlow + xhigh



b, a = signal.butter(8, 0.125)
y = signal.filtfilt(b, a, x, padlen=150)
print(np.abs(y - xlow).max())
