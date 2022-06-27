function y =  NRK4(f,a,b,n,y0)
%NRK4 Método de de Runge-Kutta de ordem 4 para resolução numérica de EDO/PVI
%   y'=f(t,y), t=[a,b], y(a)=y0
%   y(i+1) = y(i)+1/6*(k1+(2*k2)+(2*k3)+k4, i=0,1,2,...,n
%   Onde: 
%       k1=h*f(t(i),y(i));
%       k2=h*f(t(i)+(h/2),y(i)+(k1/2));
%       k3=h*f(t(i)+(h/2),y(i)+(k2/2));
%       k4=h*f(t(i+1),y(i)+k3);

%INPUT:
%   f - função da EDO y'=f(t,y)
%   [a,b] - intervalo de valores da variável independente t
%   n - núnmero de subintervalos ou iterações do método
%   y0 - aproximação inicial y(a)=y0

%OUTPUT:
%   y - vetor das soluções aproximadas do PVI em cada um dos t(i)
%

%Nuno Domingues  a2020109910@isec.pt
%Miguel Neves    a2020146521@isec.pt
%Daniel Albino   a2020134077@isec.pt
%
%Data: 15/04/2021


    h = (b-a)/n;        % Cálculo do passo
    t = a:h:b;          % Alocação de memória
    y = zeros(1,n+1);   % Alocação de memória
    y(1) = y0;          % Atribuição do valor y0 ao primeiro indice do vetor y

    for i =1:n
        k1=h*f(t(i),y(i));                       % Parâmetro k1
        k2=h*f(t(i)+(h/2),y(i)+(k1/2));          % Parâmetro k2
        k3=h*f(t(i)+(h/2),y(i)+(k2/2));          % Parâmetro k3
        k4=h*f(t(i+1),y(i)+k3);                  % Parâmetro k4

        y(i+1) = y(i)+1/6*(k1+(2*k2)+(2*k3)+k4); % Cálculo do método RK4 até n
    end                                          % Fim do ciclo FOR
end                                              % Indicação do fim da função
    
