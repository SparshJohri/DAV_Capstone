import numpy as np

def fft_stages(signal):
    N = len(signal)
    stages = int(np.log2(N))
    
    # Perform FFT
    X = np.fft.fft(signal)
    print("Input signal:", signal)
    print("FFT Output - Stage 0:", X)
    
    # Perform FFT stages
    for stage in range(1, stages + 1):
        step_size = 2**stage
        for i in range(0, N, step_size):
            for k in range(i, i + step_size // 2):
                # Twiddle factor calculation
                W = np.exp(-2j * np.pi * (k % (N // step_size)) / (N // step_size))
                # Butterfly operation
                temp = X[k]
                X[k] += X[k + step_size // 2] * W
                X[k + step_size // 2] = temp - X[k + step_size // 2] * W
        print("FFT Output - Stage", stage, ":", X)
    return X

# Example usage
input_signal = np.array(list(range(0, 1700, 100)))  # Generate random input signal
output = fft_stages(input_signal)
