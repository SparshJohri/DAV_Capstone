from scipy.fft import fft, ifft
import numpy as np

x = np.array([100, 150, 200, 250])
print(fft(x))
