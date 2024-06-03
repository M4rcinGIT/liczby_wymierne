            
classdef liczwym
    properties (Access = protected)
        L % licznik
        M % mianownik
    end
    methods
        function obj = liczwym(varargin)
            % Konstruktor klasy LiczWym
            % Może przyjmować dwa argumenty (L i M) lub jeden argument jako ciąg znaków (liczbę rzeczywistą w postaci ułamka dziesiętnego lub ułamka dzięsiętnego okresowego)
            if nargin == 2
                
                obj = obj.setL(varargin{1});
                obj = obj.setM(varargin{2});

                % Sprawdzenie, czy mianownik nie jest równy zero
                while obj.M == 0
                    
                    fprintf('Mianownik nie może równać się zero, podaj nowy kąt\n');
                    txt = "Podaj nowy mianownik:";
                    obj = obj.setM(input(txt));
                
                    % Upewnienie się, że mianownik jest dodatni
                    if obj.M < 0 
                        
                        obj = obj.setL(-obj.L);
                        obj = obj.setM(-obj.M);
                    
                    end
                end 
                
            elseif nargin == 1
                % Jeśli przekazano tylko jedną wartość, traktuj ją jako liczbę rzeczywistą
                % i zamień ją na postać ułamka
                x = varargin{1};
                if (isa(x, 'char') || isa(x, 'string'))
                    
                    strX = num2str(x);
                    negative = false;
                    
                    if contains(strX, '-')
                        
                        negative = true;
                        strX(1) = [];
                    
                    end
                    
                    parts = strsplit(strX, '.');
                    
                    if numel(parts) > 1
                        % Obsługa części okresowej i nieokresowej
                        if contains(parts{2}, '(')
                            
                            czescCalkowita = parts{1}; % część całkowita
                            ulamekCzesciCalkowitej = liczwym(czescCalkowita);
                            
                            czescNieokresowa = extractBefore(parts{2}, '('); % część nieokresowa=
                            dlugoscCzesciNieokresowej = numel(czescNieokresowa); % sprawdzenie, czy występuje część nieokresowa

                            if dlugoscCzesciNieokresowej == 0 % przypadek, gdy ułamek nie ma części nieokresowej
                                
                                czescNieokresowa = 0;
                            
                            else
                                
                                czescNieokresowa = str2double(czescNieokresowa); % konwersja z typu string na typ double
                            
                            end
                            
                            ulamekCzesciNieokresowej = liczwym(czescNieokresowa, 10^dlugoscCzesciNieokresowej); % zapisanie częsci nieokresowej jako ułamek zwykły
                            
                            czescOkresowa = extractBetween(parts{2}, '(', ')'); % zapisanie części okresowej do zmiennej
                            dlugoscCzesciOkresowej = strlength(czescOkresowa); 
                            czescOkresowa = str2double(czescOkresowa);
                            
                            sLicznik = liczwym(czescOkresowa, 10^(dlugoscCzesciOkresowej + dlugoscCzesciNieokresowej)); %licznik ze wzoru sumy ciągu geometrycznego
                            
                            odwrotnoscDlugosciCzesciOkresowej = liczwym(1, 10^dlugoscCzesciOkresowej);
                            jeden = liczwym(1, 1);
                            sMianownik = jeden - odwrotnoscDlugosciCzesciOkresowej; %mianownik we wzorze na sume ciągu geometrycznego

                            S = sLicznik / sMianownik; % suma ciągu geometrycznego tworzonego przez część okresową
                            ulamek = S + ulamekCzesciNieokresowej; % zsumowanie wszystkich części liczby rzeczywistej czyli części całkowitej, okresowej i nieokresowej 
                            wynik = ulamek + ulamekCzesciCalkowitej;
                            
                            if negative % w przypadku gdy liczba jest ujemna wynik końcowy mnożymy razy -1
                                minus = liczwym(-1, 1);
                                obj = wynik * minus;
                            else
                                obj = wynik;
                            end
                        else % obsluga ułamka zwykłego, nieokresowego
                            czescCalkowita = str2double(parts{1});
                            czescUlamkowa = str2double(parts{2});
                            
                            licznik = czescUlamkowa + czescCalkowita * 10^(numel(czescUlamkowa));
                            obj = obj.setL(licznik);

                            mianownik = 10^(numel(czescUlamkowa));
                            obj = obj.setM(mianownik);
                        end
                    else
                        % Jeśli liczba jest liczbą całkowitą
                        obj = obj.setL(str2double(x));
                        obj = obj.setM(1);
                    end
                else % przypadek w którym do konstrukotra przekazana jest liczba całkowita
                    obj = obj.setL(varargin{1});
                    obj = obj.setM(1);
                end
            else
                error("Nieprawidłowa liczba argumentów. Podaj albo jeden argument (liczbę rzeczywistą jako ciąg znaków), albo dwa argumenty (licznik i mianownik).");
            end
        end

        function disp(obj)
            % Upraszcza ułamek
            gcdValue = gcd(obj.L, obj.M);

            licznik = obj.L / gcdValue;
            mianownik = obj.M / gcdValue;
            
            negative = false;
            if licznik < 0
                
                negative = true;
                licznik = -licznik;
            
            end

            % Wyświetla ułamek w postaci ułamka prostego lub mieszanego
            if licznik > mianownik && mod(licznik, mianownik) ~= 0
                
                wholePart = floor(licznik / mianownik);
                licznik = mod(licznik, mianownik);
                
                if negative
                    
                    wholePart = -wholePart;
                    
                    if wholePart == 0
                    
                        licznik = -licznik;
                    
                    end
                end
                
                fprintf('%d %d/%d\n', wholePart, licznik, mianownik);
            
            else
                
                if negative
                    
                    licznik = -licznik;
                
                end
                
                fprintf('%d/%d\n', licznik, mianownik);
            
            end
        end
        
        function L = getL(obj)
            % Getter dla L
            L = obj.L;
        end
        
        function M = getM(obj)
            % Getter dla M
            M = obj.M;
        end
        
        function obj = setL(obj, L)
            % Setter dla L
            if mod(L, 1) ~= 0
            
                error('Licznik musi być liczbą całkowitą');
            
            end
            obj.L = L;
        end
        
        function obj = setM(obj, M)
            % Setter dla M
            if M == 0
            
                error('Mianownik nie może być równy zero');
            
            end
            if mod(M, 1) ~= 0
            
                error('Mianownik musi być liczbą całkowitą');
            
            end
            obj.M = M;
        end
        
        function res = plus(obj1, obj2)
            % Implementacja dodawania
            licznik = obj1.getL() * obj2.getM() + obj2.getL() * obj1.getM();
            mianownik = obj1.getM() * obj2.getM();
            
            res = liczwym(licznik, mianownik);
            res = res.simplify();
        end
        
        function res = minus(obj1, obj2)
            % Implementacja odejmowania
            licznik = obj1.getL() * obj2.getM() - obj2.getL() * obj1.getM();
            mianownik = obj1.getM() * obj2.getM();
            
            res = liczwym(licznik, mianownik);
            res = res.simplify();
        end
        
        function res = mtimes(obj1, obj2)
            % Implementacja mnożenia
            licznik = obj1.getL() * obj2.getL();
            mianownik = obj1.getM() * obj2.getM();
            
            res = liczwym(licznik, mianownik);
            res = res.simplify();
        end

        function res = double(obj)
            % Konwersja na liczbę rzeczywistą
            res = obj.getL() / obj.getM();
        end
        
        function res = mrdivide(obj1, obj2)
            % Implementacja dzielenia
            licznik = obj1.getL() * obj2.getM(); % mnożenie przez odwrotność
            mianownik = obj1.getM() * obj2.getL();
            
            res = liczwym(licznik, mianownik);
            res = res.simplify();
        end

        function obj = simplify(obj)
            % Upraszcza ułamek do najprostszej formy
            gcdValue = gcd(obj.getL(), obj.getM()); % Największy wspólny dzielnik
            obj = obj.setL(obj.getL() / gcdValue);
            obj = obj.setM(obj.getM() / gcdValue);
        end
    end
end
