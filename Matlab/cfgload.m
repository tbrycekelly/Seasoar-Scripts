function cfg = cfgload(file)
%  function cfg = cfgload(file) loads the SeaSoar config file
%  and returns the config parameters
%

%D. Rudnick 01/06/05
%added filesize parameter 03/21/05
%added oxygen calibration 07/30/06

lines = textread(file,'%s','delimiter','\n','commentstyle','shell');

for i=1:length(lines)
   if length(lines{i}) > 0
      ids = strread(lines{i},'%s');
      switch ids{1}
         case 'FILE_SIZE'
            cfg.filesize = str2double(ids(3));
         case 'Press'
            cfg.psn = ids{3};	
            cfg.pcal.c = str2double(ids(4:6));
            cfg.pcal.d = str2double(ids(7:8));
            cfg.pcal.t = str2double(ids(9:13));
            cfg.pcal.AD590 = str2double(ids(14:15));
            cfg.pcal.linear = str2double(ids(16:17));
         case 'COND1'
            cfg.c1sn = ids{3};
            cfg.c1cal.ghij = str2double(ids(4:7));
            cfg.c1cal.ctpcor = str2double(ids(8:9));
         case 'COND2'
            cfg.c2sn = ids{3};
            cfg.c2cal.ghij = str2double(ids(4:7));
            cfg.c2cal.ctpcor = str2double(ids(8:9));
         case 'TEMP1'
            cfg.t1sn = ids{3};
            cfg.t1cal.ghij = str2double(ids(4:7));
            cfg.t1cal.f0 = str2double(ids(8));
         case 'TEMP2'
            cfg.t2sn = ids{3};
            cfg.t2cal.ghij = str2double(ids(4:7));
            cfg.t2cal.f0 = str2double(ids(8));
         case 'CH1'
            if str2double(ids(3)) == 8
               cfg.wingpitch=str2double(ids(6:7));
            end
         case 'CH2'
            cfg.roll=str2double(ids(6:7));
         case 'CH3'
            cfg.fishpitch=str2double(ids(6:7));
         case 'CH4'
            cfg.proprpm=str2double(ids(6:7));
      end
   end 
end
