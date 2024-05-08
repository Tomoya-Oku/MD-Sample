import matplotlib.pyplot as plt
from matplotlib.ticker import ScalarFormatter
import pandas as pd
import numpy as np

def main():
    input_pos_LFL = pd.read_table("posvel_LFL.dat",header=None, delim_whitespace=True)
    input_pos_RK4 = pd.read_table("posvel_RK4.dat",header=None, delim_whitespace=True)

    time = input_pos_LFL[input_pos_LFL.keys()[0]]
    posx_LFL = input_pos_LFL[input_pos_LFL.keys()[1]]
    posy_LFL = input_pos_LFL[input_pos_LFL.keys()[2]]
    posz_LFL = input_pos_LFL[input_pos_LFL.keys()[3]]
    posx_RK4 = input_pos_RK4[input_pos_RK4.keys()[1]]
    posy_RK4 = input_pos_RK4[input_pos_RK4.keys()[2]]
    posz_RK4 = input_pos_RK4[input_pos_RK4.keys()[3]]

    plt.xlabel("Time[fs]")
    plt.ylabel("Position")
    plt.xlim(0, len(time))
    #plt.ylim(-1e-18, 3e-18)
    plt.gca().yaxis.set_major_formatter(ScalarFormatter(useMathText=True))
    
    plt.grid(linestyle="dotted")

    plt.plot(time, posx_LFL, label="posx(RK4)", color="red")
    plt.plot(time, posy_LFL, label="posy(RK4)", color="blue")
    plt.plot(time, posz_LFL, label="posz(RK4)", color="green")
    plt.plot(time, posx_RK4, label="posx(LFL)", color="red", linestyle="dashed")
    plt.plot(time, posy_RK4, label="posy(LFL)", color="blue", linestyle="dashed")
    plt.plot(time, posz_RK4, label="posz(LFL)", color="green", linestyle="dashed")
    plt.legend()
    plt.show()

###################################################################################################

main()