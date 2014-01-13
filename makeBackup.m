function makeBackup()

    CMD = 'rsync -rite ssh ~/Desktop/Data/ orch:~/ePhys/Data/';
    disp(['Backuping up using: ',CMD]);
    unix(CMD,'-echo');
