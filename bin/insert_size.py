#!/usr/bin/env python3
import sys
import os

import matplotlib.pyplot as plt
import pandas as pd


def main():
    try:
        input_file = sys.argv[1]
    except IndexError:
        print("Input file is not given")
        sys.exit()

    if not os.path.isfile(sys.argv[1]):
        print("Input file not exist or given path is not a file!")
        sys.exit()

    try:
        output_path = sys.argv[2]
    except IndexError:
        print("Output path is not given")
        sys.exit()

    if not os.path.isdir(output_path):
        print("Output directory not exist or given path is not a directory!")
        sys.exit()
    basename = os.path.splitext(os.path.basename(sys.argv[1]))[0]
    output_file = f'{output_path}/{basename}.png'

    try:
        is_max = sys.argv[3]
        is_max = int(is_max)
    except IndexError:
        is_max = 800
    except ValueError:
        print("Given max insert size is not integer")
        sys.exit()

    df = pd.read_csv(input_file, sep="\t", header=None)

    _, ax = plt.subplots(figsize=(8, 6))
    ax.set_axisbelow(True)
    plt.gca().xaxis.grid(True, lw=0.5)
    plt.plot(df[0], df[1], linestyle=None, color='#FF0000')
    plt.xlim(0, is_max)
    plt.ylim(0, 250000)
    plt.xlabel('Insert Size', fontsize=16)
    plt.ylabel('Count', fontsize=16)
    ax.fill_between(df[0], df[1], interpolate=True, color='#FF0000', edgecolor=None)
    plt.tight_layout()
    plt.savefig(output_file, dpi=200)


if __name__ == '__main__':
    main()
