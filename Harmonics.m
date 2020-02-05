clear all
close all

%% Opens audio file
file = 'GBS_Project.wav';
[z,zfs]=audioread(file);
unsmooth_faxis =  zfs*(0:length(z)-1)/length(z);
%% Variables to be in the User Interface
num_peaks = 15; %Number of harmonics to remove from the signal, this needs to be specified by the user.
num_peaks_view = 7;%Number of harmonics to view individually
num_peaks_view_noise = 9; %number of harmonics to view as noise
highlight_harmonic = 1; %Variable that determines which harmonic to make bold, if 0 then higlight none
%% Find Peaks
ClearSignal=PeakRemover(file,num_peaks); %This is the time domain signal without peaks
ThreeP = AutoPeak(file); %This finds the first three peaks of the first three harmonics (including fundamental)
m=MidFinder(ThreeP,num_peaks);%This finds the midpoint between all the harmonics
m2=round(m(2)*zfs); %Finds the midpoint between the fundamental and the first harmonic in seconds
mend=round(m(end)*zfs); %Finds the last midpoint between harmonics in seconds

%% Filter and plots harmonics
ft_wins_hann = HarmonicFilt(z, zfs, num_peaks, m, unsmooth_faxis);% Function returns all the harmonics that have been windowed

figure;%Plots all the harmonics that is determined by user (num_peaks_view)
for i = 1:num_peaks_view
    if i == highlight_harmonic
        semilogx(unsmooth_faxis, ft_wins_hann{i},'LineWidth',1.5);
    else
       semilogx(unsmooth_faxis, ft_wins_hann{i}); 
    end
    hold on
end
label(1) = "Fundamental";
label(2:num_peaks_view) = char("H"+(2:num_peaks_view));
ft_wins_hann_noise = 0;
if num_peaks_view_noise > num_peaks_view
    for i = num_peaks_view+1:num_peaks_view_noise
        ft_wins_hann_noise = ft_wins_hann_noise + ft_wins_hann{i};
    end
    semilogx(unsmooth_faxis, ft_wins_hann{i},'Color','#808080','LineStyle','--');
    label(num_peaks_view+1) = "Noise (H"+(num_peaks_view+1)+"-"+(num_peaks_view_noise)+")";
end
title('Harmonics');
xlabel('Frequency (Hz)');
ylabel('Amplitude (dB)');
legend(label');
xlim([15 20000]);
grid on;