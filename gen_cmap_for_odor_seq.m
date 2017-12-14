function [cmap]=gen_cmap_for_odor_seq(odor_list_expt,conc_list_expt)
load odor_inf.mat
%identify which concentrations from odor concentraiton list are tastants, mixtures, and pure odors
molar_conc_idx=(~cellfun(@isempty,strfind(odor_concentration_list,'M')));
molar_conc=odor_concentration_list(molar_conc_idx);
mixtures_conc_idx=(~cellfun(@isempty,strfind(odor_concentration_list,';')));
mixtures_conc=odor_concentration_list(mixtures_conc_idx);
odors_conc_idx=~(molar_conc_idx | mixtures_conc_idx);
odor_conc=odor_concentration_list(odors_conc_idx);
%generate a different hue for each different odor
unique_odors=unique(odor_list_expt);
colors=linspace(.1,.8,length(unique_odors));
cmap_hsv=zeros(length(odor_list_expt),3);

%water always gets white
water_idx=strcmp(odor_list_expt,'water');

for ii=1:length(unique_odors)
    odors_idx=strcmp(odor_list_expt,unique_odors{ii});
    conc_per_odor=conc_list_expt(odors_idx);
    cmap_hsv(odors_idx,1)=colors(ii);
    start_sat=.2;
    end_sat=.70;
    %saturation range depends on how many concentrations there are. more
    %for molarity and mixtures. 
    if length(intersect(molar_conc,conc_per_odor))==length(conc_per_odor)
        %this is a molarity
        sat=linspace(start_sat,end_sat,length(molar_conc));
        [~,sat_idx,idx2]=intersect(molar_conc,conc_per_odor,'stable');
    elseif length(intersect(mixtures_conc,conc_per_odor))==length(conc_per_odor)
        %this is a mixture
        sat=linspace(start_sat,end_sat,length(mixtures_conc));
        [~,sat_idx,idx2]=intersect(mixtures_conc,conc_per_odor,'stable');
    elseif length(intersect(odor_conc,conc_per_odor))==length(conc_per_odor)
        %this is a pure odor
        sat=linspace(start_sat,end_sat,length(odor_conc));
        [~,sat_idx,idx2]=intersect(odor_conc,conc_per_odor,'stable');
    else
        %something is inconsistant, make everything white for now
        sat=zeros(length(odor_concentration_list),1);
        sat_idx=1:length(find(odors_idx));
        idx2=sat_idx;
    end
    sat_sorted=flipud(sat(sat_idx));
    %these complicated indexing gymnastics allow for proper sorting. good
    %luck ever understanding how it works...
    odors2idx=find(odors_idx);
    
    cmap_hsv(odors2idx(idx2),2)=sat_sorted;
        
end
cmap_hsv(:,3)=.7;
if any(water_idx)
    cmap_hsv(water_idx,2:3)=[zeros(sum(water_idx),1),ones(sum(water_idx),1)];
end
cmap=hsv2rgb(cmap_hsv);
% figure(1);imagesc(1:length(odor_list))
% colormap(cmap)
% 1;
