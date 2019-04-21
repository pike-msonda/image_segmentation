import matlab.engine

def create_engine():
    return matlab.engine.start_matlab()

def compute_fmeasure(db_path, seg_path, sys_type):
    # import pdb; pdb.set_trace()
    engine = create_engine()
    # engine.addpath(r'C:\Users\Siphiwe Phiri\Desktop\weizmann-image_segmantation', nargout=0)
    res = engine.ComputeFMeasure(db_path, seg_path, sys_type)
    engine.quit()
    return res