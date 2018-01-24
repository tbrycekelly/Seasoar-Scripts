function data = rawfileread(pathstr,prefix,suffix,cfg)
% function data = rawfileread(pathstr,prefix,suffix,cfg) opens and reads the
% SeaSoar file defined by directory path pathstr, prefix prefix, and a hex
% suffix.  The total path is then pathstr/prefix.suffix
% cfg is a configuration structure returned by cfgload.
% Data is returned in a self-explanatory structure.

% D. Rudnick 01/06/05
% Calculate nmax using filesize parameter in cfg.  03/21/05
% new format FLT005 08/07/06
% new comments by R. Goericke May 2011

ctdscanrate = 24;
numctdbytes = 30;
i32bytes = 20;
i16bytes = 22;

file = [fullfile(pathstr,[prefix '.' suffix])];
fid = fopen(file,'r','b');
if fid < 0
    data = fid;
    disp(['File ' file ' not found.']);
    return
else
    disp(['Opened file ' file]);
end

% the first 7 lines of the _DAT files are txt.  After that the binary data
% start
tline = fgets(fid);
headbytes = length(tline);
tline = fgets(fid);
data.filename = tline(7:end-1);
headbytes = headbytes+length(tline);
tline = fgets(fid);
data.date = tline(7:end-1);
headbytes = headbytes+length(tline);
tline = fgets(fid);
data.ship = tline(7:end-1);
headbytes = headbytes+length(tline);
tline = fgets(fid);
data.cruise = tline(9:end-1);
headbytes = headbytes+length(tline);
tline = fgets(fid);
data.calfile = tline(19:end-1);
headbytes = headbytes+length(tline);
tline = fgets(fid);
headbytes = headbytes+length(tline);

% Calculate the record length(recordlen) and the number of records (nmax) in the file:
data.ctdscanrate = ctdscanrate;
data.numctdbytes = numctdbytes;
recordlen = i32bytes+i16bytes+8+data.ctdscanrate*data.numctdbytes;
nmax = ceil((cfg.filesize-headbytes)/recordlen);

% initialize variables
data.systime = zeros(nmax,1);
data.gpstime = zeros(nmax,1);
data.lat = zeros(nmax,1);
data.lon = zeros(nmax,1);
data.gpsstatus = zeros(nmax,1);
data.cog = zeros(nmax,1);
data.sog = zeros(nmax,1);
data.heading = zeros(nmax,1);
data.sow = zeros(nmax,1);
data.bottomdepth = zeros(nmax,1);
data.moogdrive = zeros(nmax,1);
data.moogmonitor = zeros(nmax,1);
data.tension = zeros(nmax,1);
data.ctdscans = zeros(nmax*data.ctdscanrate,data.numctdbytes,'uint8');

isfull = logical(1);

% read the _DAT file line by line and assign variables
for n = 1:nmax
    
    % if the fread returns an empty values it implies that the end of the
    % file was reached while reading the last record.  In that case set isfull
    % to 0 and the loop is exited.
    num = fread(fid,1,'int32');
    if isempty(num)
        isfull = logical(0);
        break
    end
    
    % read in binary data
    data.systime(n) = fread(fid,1,'int32');
    data.gpstime(n) = fread(fid,1,'int32');
    data.lat(n) = fread(fid,1,'int32')/1e6;
    data.lon(n) = fread(fid,1,'int32')/1e6;
    num = fread(fid,1,'int32');
    data.gpsstatus(n) = fread(fid,1,'int16');
    data.cog(n) = fread(fid,1,'int16')/10;
    data.sog(n) = fread(fid,1,'int16')/10;
    data.heading(n) = fread(fid,1,'int16')/10;
    data.sow(n) = fread(fid,1,'int16')/10;
    data.bottomdepth(n) = fread(fid,1,'int16')/10;
    data.moogdrive(n) = fread(fid,1,'int16')/10;
    data.moogmonitor(n) = fread(fid,1,'int16')/10;
    data.tension(n) = fread(fid,1,'int16');   %depends on the file whether to divide by 10 or not
    arrayelements = fread(fid,1,'int32');   %not returning these two variables as they are equivalent to
    bytesinarray = fread(fid,1,'int32');    %ctdscanrate and numctdbytes, and they are constant in a file
    data.ctdscans((n-1)*data.ctdscanrate+1:n*data.ctdscanrate,:) = fread(fid,[data.numctdbytes data.ctdscanrate],'*uchar')';
end

% the loop above is exited either because N reached nmax in which case it is
% tested that no more data remain in the file (test = fread(fid,1,'uchar');) 
% or because the end of the file was reached before N reached nmax in which
% case the last record is incomplete and it is stripped in the 'else'
% section from data.

if isfull
    % test that there are no  more data in the file
    test = fread(fid,1,'uchar');
    if ~isempty(test)
        error('Data remains in file, need to increase nmax.')
    end
else
    % strip the last record from data
    data.systime = data.systime(1:n-1);
    data.gpstime = data.gpstime(1:n-1);
    data.lat = data.lat(1:n-1);
    data.lon = data.lon(1:n-1);
    data.gpsstatus = data.gpsstatus(1:n-1);
    data.cog = data.cog(1:n-1);
    data.sog = data.sog(1:n-1);
    data.heading = data.heading(1:n-1);
    data.sow = data.sow(1:n-1);
    data.bottomdepth = data.bottomdepth(1:n-1);
    data.moogdrive = data.moogdrive(1:n-1);
    data.moogmonitor = data.moogmonitor(1:n-1);
    data.tension = data.tension(1:n-1);
    data.ctdscans = data.ctdscans(1:data.ctdscanrate*(n-1),:);
end

fclose(fid);
