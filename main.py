from algorithms.segmentation_resolver import SegmentationResolver
from utils.utils import read_images
from datetime import datetime

CLUSTERS = [3]
IMAGES_FOLDER = "images"

def execute(images, sizes, img_names, method=None):
    params = {'images':images, 'image_sizes':sizes,'filenames':img_names, 
        'clusters':CLUSTERS, 'filter':'gaussian'}
    segmentation_algorithms = SegmentationResolver(params)
    
    segmentation_algorithms.segment(algorithm=method.lower())
        

def main():
    start = datetime.now()
    images, img_names, sizes =  read_images(folder=IMAGES_FOLDER)
    # import pdb; pdb.set_trace()
    execute(images, sizes, img_names, method='KMEANS') 
    execute(images, sizes, img_names, method='FUZZY') 
    execute(images, sizes, img_names, method='MEANSHIFT')
    execute(images, sizes, img_names, method='SOM')
    execute(images, sizes, img_names, method='GMM')
    # execute(method='DBSCAN') # too slow. 
    time_elapsed = datetime.now() - start
    
    print('Time elapsed (hh:mm:ss.ms) {}'.format(time_elapsed))
        
if __name__ =='__main__':
    main()
    #I have added new stuff.
    


