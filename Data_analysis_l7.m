clear all; close all; clf; format compact
 
% Define parameters of circuit

 

% Load in data
 
% OPTION 1: If loading file from your local machine:
% A = csvread('data.csv',2,1);
 
% OPTION 2: If using MATLAB via Virtual Computing Lab, identify folder on your laptop:
A = csvread('FastData2.csv',16,1);
 
% Extract and assign data
tmcr = A(:,1); % time in micro
V_difr = A(:,2); %raw code
tsc = tmcr/1000000; %microseconds to seconds

V_dif = V_difr*(5/512); %code to voltage
 
% Create index of time array

 set1 = V_dif(1:5474); %Isolate first response, index chosen by visual enspection
 set2 = V_dif(6250:end);%Isolate second response, index chosen by visual enspection
 
 %create matching time arrays
 tsc1 = tsc(1:5474); 
 tsc2 = tsc(6250:end);
 
 
  % found mins and index of mins
  % used this info to isolate approx maximum deflection
 [min1,I1] = min(set1(:));
 [min2,I2] = min(set2(:));
 
 %trimmed amplitude arrays
 set1 = set1(I1:3500);
 set2 = set2(I2:3500);
 
 %trimmed time arrays to match
 tsc1 = tsc1(I1:3500);
 tsc2 = tsc2(I2:3500);
 
 %normalize both amplitude responses
 set1nn = (set1-min1); %set min to zero
 set1n = set1nn./max(set1nn); %set max to one
 
 set2nn = (set2-min2); %same as above
 set2n = set2nn./max(set2nn);
 
 tsc1n = (tsc1-min(tsc1)); %set start time to zero, leave in seconds
 %tsc1n = tsc1nn./max(tsc1nn);
 
 tsc2n = (tsc2-min(tsc2)); %same
 %set2n = set2nn./max(set2nn);
 
 
 % extracted from graph using data cursour
 tp1 = .1271; %time of first peak
 y1 = 1; %amplitude of first peak
 tp2 = .1667; %time of second peak
 y2 = .9697; %amp of second
 
 Td = tp2 - tp1; %damped period
 
 wd = 2*pi/Td; %damped frequency
 
 ld = log(.1271/.1667); %log dec
 
 dr = 1/sqrt(1+((2*pi)/ld)^2); %damping ratio
 
 wn = wd/sqrt(1-dr^2); %natural frequency
 
 a1 = 1.8751; %alpha1 given
 
 I = 8.726020312499999e-11; %calculated in first code
 
 %given or obvious values
 L = .263; %m
 b = .0255; %m
H = .00345; %m
Ac = b*H;
rho = 2700;

%youngs modulus
E = (wn/a1^2)^2*rho*Ac*L^4/I;

% Plot data
figure(1);
hold on
width = 1000;
height = 500;
set(gcf,'units','points','position',[0,0,width,height])
plot(tsc,V_dif,'b','LineWidth',2)
y = 0;
line([0,35],[y,y],'Color','red','LineStyle','--')
title('Title here');
grid minor
legend('V_dif','Location','NorthEast')
title('Analysis of RC Circuit Data by Nate Crispell, Esquire')
xlabel('Time [sec]')
ylabel('Volt Dif (V)')

figure(2);
width = 1000;
height = 500;
xlabel('Time [sec]')
ylabel('Volt Dif (V)')
title('Response 1')
set(gcf,'units','points','position',[0,0,width,height])
plot(tsc1,set1,'b','LineWidth',1)

figure(3);
width = 1000;
height = 500;
xlabel('Time [sec]')
ylabel('Volt Dif [V]')
title('Response 2')
set(gcf,'units','points','position',[0,0,width,height])
plot(tsc2,set2,'r','LineWidth',1)

figure(4);
hold on
width = 1000;
height = 500;
xlabel('Time [sec]')
ylabel('Normalized Amplitude Response [V/Vmax]')
title('Overlay of R1 and R2')
set(gcf,'units','points','position',[0,0,width,height])
plot(tsc1n,set1n,'b','LineWidth',1)


plot(tsc2n,set2n,'r','LineWidth',1)
line([tp1 tp2],[y1 y2]);
legend('Response 1', 'Response 2', 'Tiny line connecting first 2 peaks');
