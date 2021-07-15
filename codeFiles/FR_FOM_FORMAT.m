%% Initial parameter 
N        = 50;   %total frame of images
FEM_size = 1024; %total pixel count

elem_data= zeros(FEM_size,N); %array to store ED of measured frames
error    = zeros(FEM_size,N); %array to store FRx of 50 frames

%rotation of image may be required to align EIT scan start position 
rotate   = 5; % rotate the EIT image to upright position

%% FR-metric FEM Model
n_elecs    =  16;
FEM_mod    =  'd2c';

imdl=mk_common_model(FEM_mod,n_elecs);
imdl.fwd_model.stimulation = mk_stim_patterns(n_elecs,1,...
    [0,1],[0,1],{'rotate_meas','no_meas_current'},3);

%% solve inverse problem
mapped_colour = 127;
ref_level     = 0;
% rimgO is the solved inverse model 
rimgO = inv_solve(imdl,ref,data); 
% normalize element data
DMAX  = max(abs(rimgO.elem_data));
rimgO.elem_data(:) = (rimgO.elem_data(:)+DMAX)*2/(2*DMAX)-1; 
% set EIT image colours
rimgO.calc_colours.ref_level     = ref_level;
rimgO.calc_colours.mapped_colour = mapped_colour;

%% Plot reference EIT Image
figure(1);
set(gcf,'color','w');
subplot(2,2,1)
IMG_O = show_fem(rimgO,[0,0,0]);
axis off

% get colours code of reference EIT Image (for RIO computation)
coloursO = IMG_O.FaceVertexCData; 
%% Rotate measured dataset to upright position
REF_data = vertcat(REF_Data((209-13*rotate):208),REF_Data(1:(208-13*rotate)));
for i =1:N
    EIT_data(:,i)=vertcat(EIT_Data_store((209-13*rotate):208,i),EIT_Data_store(1:(208-13*rotate),i));
end
%% Plot measured EIT Image
for i=1:N
    rimg = inv_solve(imdl,REF_data,EIT_data(:,i)); 
    rimg.calc_colours.ref_level= ref_level;
    rimg.calc_colours.mapped_colour = mapped_colour;
    
    elem_data(:,i)=rimg.elem_data;% Get ED_test
       
    subplot(2,2,3)
    IMG_E=show_fem(rimg,[0,0,0]);
    axis off

    drawnow ('update'); %See Live update?
end
%% FRx computation
% avoid noise spikes
% normalized using 95% of the total 50 frames of data in finding the DMAX 
DMAX=prctile(max(abs(elem_data)),[95]);
for i=1:N
    elem_data(:,i)=(elem_data(:,i)+DMAX)*2/(2*DMAX)-1; 
end
% calculate FRx
for i=1:N
    error(:,i) = (elem_data(:,i)-rimgO.elem_data)*0.5;
end 
FR  = abs(mean(error,2));

Global_FR = sum(FR);
%% ROI computation
% select ROI pixels
ROI = coloursO < (mapped_colour/2);
ROI_pixel = ROI.*FR;
% for plotting purpuse, set nonROI pixels to 0
ROI_pixel(ROI_pixel==0) = 0; 

ROI_FR = sum(ROI_pixel);
%% FR replot
Pmax = 0.1;
Pmin = 0;

ax(2) = subplot(2,2,2); %FRx replot
h1=patch('Faces',rimg.fwd_model.elems,'Vertices',rimg.fwd_model.nodes, 'facecolor','flat', ...
    'facevertexcdata',FR,'CDataMapping','scaled');
caxis([Pmin Pmax])
colormap(ax(2),flipud(hot));
axis off
pbaspect([1 1 1]);
cb = colorbar;
cb.FontWeight='bold';

ax(4) = subplot(2,2,4); %ROI FRx replot
h2=patch('Faces',rimg.fwd_model.elems,'Vertices',rimg.fwd_model.nodes, 'facecolor','flat', ...
    'facevertexcdata',ROI_pixel,'CDataMapping','scaled');%not direct use scaled
caxis([Pmin Pmax])
colormap(ax(4),flipud(hot));
axis off
pbaspect([1 1 1])
cb = colorbar;
cb.FontWeight='bold';

sgtitle(['Global FR = ',num2str(round(Global_FR,1)),...
    ' ROI FR = ',num2str(round(ROI_FR,1))]);
