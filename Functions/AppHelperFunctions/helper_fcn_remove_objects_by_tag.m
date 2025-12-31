function helper_fcn_remove_objects_by_tag(tag)
% helper_fcn_remove_objects_by_tag
% Finds and deletes all valid graphics objects with the specified Tag.
%
% INPUT:
%   tag (char | string) – Tag of graphics objects to remove

    if nargin == 0 || isempty(tag)
        return
    end

    objs = findall(0,'Tag', tag);

    if ~isempty(objs)
        objs = objs(isgraphics(objs));  % safety check
        delete(objs);
    end
end