def write_data_relative_path(df, relative_dataset_path, data_type='csv', supress='y', idx = False):
    '''
    This function offers a method to write data that to parent directory.
    Kind of like your second cousin dataset.
    This is configured for the directory wihtin each team members 'workspace'
    '''
    # Import relevant libraries
    import pandas as pd
    import os
    
    # Store current working directory as a string
    original_wd = os.getcwd() # this should be where this notebook is saved
    
    # Print current working directory 
    if supress!='y':
        print('Original working directory is ', os.path.abspath(os.curdir), '\n')
        
    # Move up three directories
    os.chdir("..") # Move up one directory to 'workspace'
    os.chdir("..") # Move up one directory to 'scripts'
    os.chdir("..") # Move up one directory to 'Main Project Directory'
    if supress!='y':
        print('Working directory is now ', os.path.abspath(os.curdir), '\n')
    
    # Writing relative dataset based on type
    if data_type=='csv':
        df.to_csv(relative_dataset_path,
                  index = idx
                 )
    elif data_type=='excel':
        df.to_excel(relative_dataset_path)
    
    # Going back to original working directory
    os.chdir(original_wd)
    if supress!='y':     
        print('We are back to the original working directory ', os.path.abspath(os.curdir), '\n')
    