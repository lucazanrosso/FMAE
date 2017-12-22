M = csvread('92214-2012.csv', 4, 7, [4 7 105123 7]);
v = 0:0.5:25;
media = mean(M);

plot (M)

abs = zeros(1, 51);
n = 1;
for x = 0:0.5:25
   for i = 1:105120
        if (M(i) >= x)
            abs(n) = abs(n) + 1;
        end
   end 
   n = n + 1;
end

abs = abs / 1051.20;
bar(v, abs, 0.5)

prob = zeros(1, 51);
n = 1;
for x = 0:0.5:25
   for i = 1:105120
        if (M(i) >= x && M(i) < x + 0.5)
            prob(n) = prob(n) + 1;
        end
   end 
   n = n + 1;
end

prob = prob / 1051.20;

bar(v,prob, 0.5)

hold on

Y = wblpdf(v, 8.84, 2.2) * 50;

plot(v,Y)