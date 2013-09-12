
% OSMNET read OSM data as JSON and plot graph
% Clas Rydergren, 2013-09-12
% Uses http://www.cs.sunysb.edu/~kyamagu/software/json/ 
% for reading the JSON into Matlab.

% Read the JSON exported from Overpass-turbo.eu as "raw" data (JSON)
% X=json.read('C:\Users\clary35\Documents\MATLAB\small.json')


elementslength = size(X(1).elements,2);

% Plot the nodes in the JSON data
% Additional nodes, not used in any "way" may be present, depending
% on the exported data
clear lat lon;
for i=1:elementslength
    if( strcmp(X(1).elements{i}.type,'node') )
        lon(i)=X(1).elements{i}.lon;
        lat(i)=X(1).elements{i}.lat;
    end
end
%geoshow(lat,lon,'displaytype','point','Color','r')
plot(lat,lon,'+r')
hold on

% Plot the "ways" defined in the JSON data
for i=1:elementslength
    if( strcmp(X(1).elements{i}.type,'way') )
        q=X(1).elements{i}.nodes;
        % The JSON to Maltab parser seems to produce different
        % "data structures" depening on the data. For non-text,
        % an "array of structs" is constructed,
        % and for data with text(?) the results is a 
        % "structure of structs". They are dandled as two 
        % different cases here.
        if( isa(q,'cell') )
            % Case one, direct struct
            last = size(q,2);
            clear lat;
            clear lon;
            for p=1:last
                point = q{p};
                lat(p) = point.lat;
                lon(p) = point.lon;
            end
%            geoshow(lat,lon,'displaytype','line','Color','b');
            plot(lat,lon,'b');
        else
            points = struct2cell(X(1).elements{i}.nodes);
            last = size(points,3);
            clear clat;
            clear clon;
            if( cell2mat(points(3,1,1)) > 1 & cell2mat(points(3,1,1)) < 20)
                % Two case, the first when the tags-data is first in the
                % strcture, the other case when the tags data is the last
                l = 1;
                for p=1:last
                    clat(p) = points(5,1,p);
                    clon(p) = points(3,1,p);
                end
            else
                for p=1:last
                    clat(p) = points(4,1,p);
                    clon(p) = points(2,1,p);
                end
            end
            lat = cell2mat(clat);
            lon = cell2mat(clon);
%            geoshow(lat,lon,'displaytype','line','Color','b');
            plot(lat,lon,'b');
        end
    end
end

% Use plot_google_map('maptype','roadmap') to add background map
% based on the script from 
% http://www.mathworks.com/matlabcentral/fileexchange/27627-plotgooglemap
