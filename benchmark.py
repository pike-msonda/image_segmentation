from utils.utils import read_human_seg
import os
import cv2
import argparse
from tabulate import tabulate
import pandas as pd
from PIL import Image
import numpy as np

HUMAN_SEG_FOLDER='images'

def main():
    images, img_names, sizes =  read_human_seg(folder=HUMAN_SEG_FOLDER)
    import pdb; pdb.set_trace()


if __name__ == "__main__":
     main()