% Function to be used in superior submission jobs for DSD uniformity
% 30 June 2022

function dsd_uniformity_superior_AE1RF16()
tic
global cfg 
cores = feature('numcores');
parpool(cores)
path = genpath('../functions_06302022');
addpath(path)

%Defining param values
ensmblNs = 1e3;
ncCutoff = 0.7;
smplgCutoff = 0.5;
alphaVal = 0.001;
clusteringAlgo = 'OPTICS';
minPoints = 10:100;
eps = 0.1;

%  RF 16- July 15,  2017
FlightNo = 'AE1_RF16';
Ltime  = [40400 40900 41200 41400 41800 45950 46100 46400 46900 47480 47600 49900];
Utime = [40800 41200 41400 41900 42500 46100 46300 46800 47300 47980 47900 50410];

load(fullfile(pwd,'AE1_RF16.mat'))
load(fullfile(pwd,'RF16_All_instruments_20170715.mat'))



MetParams_time = datetime2sod(iwg.Date_Time);
GPS_altitude = (iwg.GPS_MSL_Alt);
% Calling Main functions
for cnt = 1:numel(Utime)   
    %  altind = convertStringsToChars(Altind(cnt));
    ltime  = Ltime(cnt);
    utime  = Utime(cnt);
    alt = round(mean(GPS_altitude(MetParams_time >= ltime ...
        & MetParams_time <= utime)));
    
    
    

    if isfile(fullfile(pwd,['ACE_ENA_Results/' FlightNo '/cfg.mat']) )
        load(fullfile(pwd,['ACE_ENA_Results/' FlightNo '/cfg.mat']))
        
        cfg.folderHeader = fullfile(pwd,['ACE_ENA_Results/' FlightNo ]);
        cfg.fileHeader   =  [ num2str(ltime) '_' num2str(utime)  '_' num2str(alt)];
        %         cfg.fileHeader   =  [ num2str(alt) '_' num2str(ltime) '_' num2str(utime)  ];
        %KS params
        fnames=fieldnames(cfg);
        if sum(strcmp('ensmblNs',fnames)) == 0
            cfg.ensmblNs = ensmblNs;
        end
        if sum(strcmp('ncCutoff',fnames)) == 0
            cfg.ncCutoff = ncCutoff;
        end
        if sum(strcmp('smplgCutoff',fnames)) == 0
            cfg.smplgCutoff = smplgCutoff;
        end
        if sum(strcmp('alphaVal',fnames)) == 0
            cfg.alphaVal = alphaVal;
        end
        if sum(strcmp('clusteringAlgo',fnames)) == 0
            cfg.clusteringAlgo = clusteringAlgo;
            if strcmp(cfg.clusteringAlgo,'DBSCAN')
                cfg.eps = eps ;
                cfg.minPoints = minPoints;
            else
                cfg.minPoints = minPoints;
            end
        end
    else
        
        cfg.folderHeader = fullfile(pwd,['ACE_ENA_Results/' FlightNo ]);
        %     cfg.fileHeader   =  [ num2str(ltime) '_' num2str(utime)  '_' num2str(alt)];
        cfg.fileHeader   =  [ num2str(alt) '_' num2str(ltime) '_' num2str(utime)  ];
        
        %KS params
        
        cfg.ensmblNs = ensmblNs;
        
        cfg.ncCutoff = ncCutoff;
        
        cfg.smplgCutoff = smplgCutoff;
        
        cfg.alphaVal = alphaVal;
        
        cfg.clusteringAlgo = clusteringAlgo;
        if strcmp(cfg.clusteringAlgo,'DBSCAN')
            cfg.eps = eps ;
            cfg.minPoints = minPoints;
        else
            cfg.minPoints = minPoints;
        end
        
        
        
    end
    
    if ~exist(cfg.folderHeader,'dir')
        mkdir(cfg.folderHeader)
    end
    
    %  ------------------------------------------------------------------------
    % Getting the cloud properties
    % 2022.02.14
    
    cldProps = cloudProperties(pStats,iwg,combinedConc);
    save(fullfile(cfg.folderHeader,'/cldProps.mat'),...
        'cldProps')
%     ----------------------------------------------------------------------
    
    
    %  ------------------------------------------------------------------------
    % Getting the PD time series with all diameter info
    
    
    [holotime,prtcleDiam] = getPDMatrix(pStats,ltime,utime);
    save(fullfile(cfg.folderHeader,['/prtcleDiam_' cfg.fileHeader '.mat']),...
        'prtcleDiam','holotime')
    
    %--------------------------------------------------------------------------
    % Function to generate and plot the KSMatrix multiple times and average
    % them to get the ensemble sample result: Here used for comparing holorams
    %  with num  conc at least 0.7 times the average value
    
    ensmblKSMatrixCondConc = ensembleKSMatrixlSamplingAvgNumConc(prtcleDiam,1);
    
    save(fullfile(cfg.folderHeader,['/EnsembleKSMatrix_1k_'  cfg.fileHeader ...
        '_NumConc_' num2str(cfg.smplgCutoff) '%_0-P_1-F_1.2_N.mat']),'ensmblKSMatrixCondConc')
    
    % -------------------------------------------------------------------------
    
    % Calulating the KS Test results for all the scale = 1
    
    [passNs,passPrcnt,hEnsmblPass] = ensembleKSTestWithScale(prtcleDiam,1);
    save(fullfile(cfg.folderHeader,['/Ensemble_10k_' cfg.fileHeader ...
        '_GlobalDistCmp_KSPassCnt_Hologram_scale1.mat']),'hEnsmblPass')
    
    
end


cfg = rmfield(cfg,'fileHeader');
folderHeader = cfg.folderHeader;
cfg = rmfield(cfg,'folderHeader');
save(fullfile(folderHeader,'cfg'),'cfg')
toc
end
