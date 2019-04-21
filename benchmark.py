from scripts.execute import compute_fmeasure
import pandas as pd
from tabulate import tabulate
import os
os.chdir('scripts')
HUMAN_SEG_FOLDER='../images'
ALGO_SEGS = 'segs'
SYSTEM_TYPE = 'pc'
SEG_FOLDERS = ['kmeans', 'fuzzy', 'gmm', 'meanshift', 'som', 'dbscan']
def main():
     print(compute_fmeasure(HUMAN_SEG_FOLDER, ALGO_SEGS, SYSTEM_TYPE))

def setup():
     results = pd.DataFrame(columns=['algorithm', 'image','f1-score', 'recall', 'precision'])
     image_folders = [f for f in os.listdir(HUMAN_SEG_FOLDER) if f != '.gitignore']
     for folder in image_folders:
          data_folders = os.listdir(HUMAN_SEG_FOLDER+'/'+folder)
          for seg_folder in SEG_FOLDERS:
               for data_dir in data_folders:
                    if seg_folder == data_dir:
                         image_name = os.listdir(HUMAN_SEG_FOLDER+'/'+folder+'/'+data_dir)[0].split('.')[0]
                         print("Evaluating image({0}): {1}".format(seg_folder, image_name))
                    
                         res=compute_fmeasure(HUMAN_SEG_FOLDER, data_dir, SYSTEM_TYPE)
                         for scores in res:
                              data = {'algorithm' : str(seg_folder), 'image': image_name, 'f1-score': scores[0], 'recall': scores[1], 'precision': scores[2]}
                              array = []
                              for key, value in data.items():
                                   temp = [key,value]
                                   array.append(temp)
                              results = results.append(data, ignore_index=True)

     dataframe = pd.DataFrame.from_dict(results)
     print (dataframe.groupby(['algorithm']).mean())
     # import pdb; pdb.set_trace()
if __name__ == "__main__":
     setup()