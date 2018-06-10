%Rainfall test script

directory = '/g/data1/ub8/au/climate/'
chdir(directory)
dir

filePattern = fullfile(directory, 'AGCD.BoM.daily.rain*');
theFiles = dir(filePattern);
BOM_data_array = cell(1,100);%This needs to be at least as long as the total number of files. Doesn't matter if it's longer.
for f = 1:length(theFiles)
    baseFileName = theFiles(f).name;
    fullFileName = fullfile(directory, baseFileName);
    time = double(ncread(fullFileName, 'time'));
    BaseDate=datenum([1800 1 1]); % renders the date 1/1/1900 in Matlab default numerical format
    Dates=datevec(double(time)+datenum([1800 1 1])); 
    lat = double(ncread(fullFileName, 'latitude'));
    lon = double(ncread(fullFileName, 'longitude'));
    info = ncinfo(fullFileName);
    Rain = ncread(fullFileName, 'rain');
    rain_subset = Rain(1:671,22:841,:);
    d3 = size(Rain,3);
    Add_values = zeros(19, 820, d3);
    Append = cat(1,Add_values,rain_subset);
    Append = double(Append);
    Append(Append == -999) = NaN;
    rain_resize=imresize(Append,0.2);%For this to be correct, the initial spatial extent of each file needs to be exactly the same. Then the resize just needs to be an amount that leaves you with the same number of cells in each direction.
    rain_resize(rain_resize < 0) = 0;
    rain_month_array = cell(1,12);
    for m = 1:12;
        month = Dates(:,2) == m;
        rain_month_array{m} = month;
    end
    monthly_rain = cell(d3,12);
    for l = 1:length(rain_month_array);
        for i = 1:length(rain_month_array{1});
            if rain_month_array{l}(i) == 1;
                selection = i;
                monthly_rain{i,l} = rain_resize(:,:,selection);
            end
        end
    end
    BOM_month_cube = NaN.*zeros(138,164,12);
    for v = 1:12;
        t_month = monthly_rain(:,v);
        T = find(~cellfun(@isempty, t_month));
        Min = min(T);
        Max = max(T);
        r_month = Min:Max;
        s_month = rain_resize(:,:,r_month);
        m_month = sum(s_month,3);
        BOM_month_cube(:,:,v) = m_month; 
    end
    BOM_data_array{f} = BOM_month_cube;
    fprintf(1, '.', fullFileName)    
end

test_cube = BOM_data_array
save(['g/data/oe9/user/sjw603/' 'test_f.m'], 'test_cube')
