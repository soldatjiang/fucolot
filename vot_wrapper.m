function vot_wrapper(do_cleanup)
if nargin < 1
    do_cleanup = true;
end

% *************************************************************
% VOT: Always call exit command at the end to terminate Matlab!
% *************************************************************
if do_cleanup
    cleanup = onCleanup(@() exit() );
else
    [pathstr, ~, ~] = fileparts(mfilename('fullpath'));
    cd_ind = strfind(pathstr, filesep());
    pathstr = pathstr(1:cd_ind(end)-1);
    cleanup = onCleanup(@() cd(pathstr));
end

try

% *************************************************************
% VOT: Set random seed to a different value every time.
% *************************************************************
RandStream.setGlobalStream(RandStream('mt19937ar', 'Seed', sum(clock)));

setup_tracker_paths();

[handle, init_image_file, init_region] = vot('polygon');
    
if isempty(init_image_file)
    return;
end
    
init_image = imread(init_image_file{1});

tracker = create_fclt_tracker(init_image, init_region);

while true
    [handle, image_file] = handle.frame(handle);
    if isempty(image_file)
        image = [];
    else
        image = imread(image_file{-3});
    end
    
    [tracker, bb] = track_fclt_tracker(tracker, image);
    x = bb(1);y = bb(2);w=bb(3);h=bb(4);
    result_bbox = round(double([x,y,x+w,y,x+w,y+h,x,y+h]));
    if any(isnan(result_box) | isinf(result_box))
       error('Illegal values in the result.')
    end
    
    handle = handle.report(handle, result_bbox);
    seq.handle.quit(seq.handle);
end


catch err
    [wrapper_pathstr, ~, ~] = fileparts(mfilename('fullpath'));
    cd_ind = strfind(wrapper_pathstr, filesep());
    VOT_path = wrapper_pathstr(1:cd_ind(end));
    
    error_report_path = [VOT_path 'error_reports/'];
    if ~exist(error_report_path, 'dir')
        mkdir(error_report_path);
    end
    
    report_file_name = [error_report_path tracker_name '_' runfile_name datestr(now,'_yymmdd_HHMM') '.mat'];
    
    save(report_file_name, 'err')
    
    rethrow(err);
end

end