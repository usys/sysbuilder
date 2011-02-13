OpenBoot Boot Process

There are 7 boot option :

1.NORMAL        Load himem only
2.CD            Include NORMAL, and load CD drivers
3.EMM386        Include NORMAL, and load emm386
4.UMBPCI        Include NORMAL, and load umbpci
5.EMMCD         Include 2.CD and 3.EMM386
6.UMBPCI        Include 2.CD and 4.UMBPCI
7.CLEAN         Include NOTHING

%CONFIG% is set either by name, or by number
%FS_ROOT% is set to current working directory
%OLDPATH% is set to %PATH%
%PATH% is set to %FS_ROOT%\etc\bin;%PATH%

1.Display Banner
    Display text file "etc/banner" if found
    
2.Preload
    Call etc/{0,1,2,3,}preload.bat if found
  
3.Load CD-ROM program if necdssary 
    Will call etc/cdrom.bat if boot options include CD

4.PRE Init
    Call etc/preint{0,1,2,3,} if found

5.Init
    Call etc/init.bat if found

6.POST Init
    Call etc/postint{0,1,2,3,}.bat   if found
    
7.Display Welcome
    Display text file "etc/welcome" if found

8.Display Tips
    Display text file "etc/tips" if found
    