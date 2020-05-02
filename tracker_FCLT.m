FCLT_repo_path = ########

tracker_label = 'FuCoLoT';
tracker_command = generate_matlab_command('vot_wrapper(true)', {[FCLT_repo_path]});
tracker_interpreter = 'matlab';