%utworzenie liczb

l1 = liczwym(-2, 3);
l2 = liczwym(1, 2);
l3 = liczwym(5, 6);

% dodawanie

fprintf('-2/3 + 5/6 = ');
dodawanie = l1 + l3;
dodawanie.disp();

% odejmowanie

fprintf('1/2 - 5/6 = ');
odejmowanie = l2 - l3;
odejmowanie.disp();

% dzielenie

fprintf('-2/3 / 5/6 = ');
dzielenie = l1 / l3;
dzielenie.disp();

% mnożenie

fprintf('-2/3 * 1/2 = ');
mozenie = l1 * l2;
mozenie.disp();

fprintf('sin(-2/3) = %f\n', sin(double(l1)));

% Konwersja liczb z ułamkiem okresowym
l4 = liczwym('0.(3)');
l5 = liczwym('-12.1235(21)');
l6 = liczwym('7.2115(232)');

fprintf('Konwersja 0.(3) = ');
l4.disp();

fprintf('Konwersja -12.1235(21) = ');
l5.disp();

fprintf('Konwersja 7.2115(232) = ');
l6.disp();
