%% Ideal power curve

n = 1;
p = zeros(1, 301);

vcutin = 3;
vrated = 12;
vcutoff = 25;
prated = 3.12;

for v = 0:0.1:30
   if (v >= vcutin && v < vrated)
       p(n) = prated*(v^2 - vcutin^2)/(vrated^2 - vcutin^2);
   elseif (v >= vrated && v < vcutoff)
       p(n) = prated;       
   end
   n = n + 1;
end

v = 0:0.1:30;
plot(v,p)

n = 1;
p2 = zeros(1, 301);

vcutin = 3;
vrated = 12;
vcutoff = 25;
prated = 3.3;

for v = 0:0.1:30
   if (v >= vcutin && v < vrated)
       p2(n) = prated*(v^2 - vcutin^2)/(vrated^2 - vcutin^2);
   elseif (v >= vrated && v < vcutoff)
       p2(n) = prated;       
   end
   n = n + 1;
end

v = 0:0.1:30;
plot(v,p2)


%% Gear-box and converter selection 

generatorPower = [1.65 3.2 4.25 1.65 3.12 3.3 3.3 0.55 0.8 1.1 1.1 1.6 1.6];
generatorSpeed = [17 12 16 150 414 136 365 1500 1500 1000 1500 1000 1500];
generatorCurrent = [1450 2900 3950 1480 2750 3000 2900 510 690 940 940 1440 1410];
gearRatio = generatorSpeed / 12;
bladeTorque = generatorPower ./ (12*2*pi/60);
totalWeight = [50 80 89 15 12.7 28 13.9 2.4 2.9 5.6 3.2 6.8 5.6];

for i = 1:length(generatorPower)
    if (i > 3)
        if (gearRatio(i) > 0 && gearRatio(i) <= 6)
            totalWeight(i) = totalWeight(i) + bladeTorque(i) * 12 * 0.6;
        elseif (gearRatio(i) <= 40)
            totalWeight(i) = totalWeight(i) + bladeTorque(i) * 12 * 0.85;
        else
            totalWeight(i) = totalWeight(i) + bladeTorque(i) * 12;
        end
    end
     
    if (generatorPower(i) <= 1 && generatorCurrent(i) <= 1100)
        totalWeight(i) = totalWeight(i) + 1.7;
    elseif (generatorPower(i) <= 2 && generatorCurrent(i) <= 2150)
        totalWeight(i) = totalWeight(i) + 2.5;
    elseif (generatorPower(i) <= 2.5 && generatorCurrent(i) <= 2650)
        totalWeight(i) = totalWeight(i) + 2.5;
    elseif (generatorPower(i) <= 3 && generatorCurrent(i) <= 3200)
        totalWeight(i) = totalWeight(i) + 4.0;
    elseif (generatorPower(i) <= 4 && generatorCurrent(i) <= 4200)
        totalWeight(i) = totalWeight(i) + 5.0;
    elseif (generatorPower(i) <= 5 && generatorCurrent(i) <= 5200)
        totalWeight(i) = totalWeight(i) + 5.0;
    elseif (generatorPower(i) <= 6 && generatorCurrent(i) <= 6300)
        totalWeight(i) = totalWeight(i) + 8.0;
    elseif (generatorPower(i) <= 7 && generatorCurrent(i) <= 6300)
        totalWeight(i) = totalWeight(i) + 7.5;
    end
end

choice = generatorPower ./ totalWeight;

%% Generators efficency curve

load = [25 50 75 100];
xq = 0 : 0.1 : 100;

% PMG4250-16
loadEfficency1 = [93.5 95.0 95.0 94.6];
vq1 = spline(load, loadEfficency1, xq);

% PMG3120-414
loadEfficency2 = [93.8 96.1 96.6 96.8];
vq2 = spline(load, loadEfficency2, xq);

% PMG1600-1500
loadEfficency3 = [91.8 95.5 96.7 97.3];
vq3 = spline(load, loadEfficency3, xq);

plot(xq, vq1, xq, vq2, xq, vq3)

%% Average power and energy production

load = [3 6 9 12];
xq = 0 : 0.1 : 12;

% PMG3120-414
loadEfficency1 = [93.8 96.1 96.6 96.8];

% PMG3300-365
loadEfficency2 = [96.4 97.4 97.6 97.5];

vq1 = spline(load, loadEfficency1, xq);
vq2 = spline(load, loadEfficency2, xq);

plot(xq, vq1, xq, vq2);

efficency100 = ones(1, 180)*96.8;
efficency1 = [vq1 efficency100]/100;

efficency100 = ones(1, 180)*97.5;
efficency2 = [vq2 efficency100]/100;

pnet = p .* efficency1 * .98 * .97;
pnet2 = p2 .* efficency2 * .98 * .97;
plot(v, p, v, pnet, v, p2, v, pnet2)

weibull = wblpdf(v,8.84,2.2);

averagePower1 = trapz(v, pnet .* weibull);
averagePower2 = trapz(v, pnet2 .* weibull);

choice1 = averagePower1 / 43.0247;
choice2 = averagePower2 / 45.6858;

capacityFactor = averagePower2 / 3.3;

Energy = 8760 * averagePower2; %kWh