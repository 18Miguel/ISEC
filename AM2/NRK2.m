function y = NRK2(f,a,b,n,y0)
%NRK2 Método de Runge-Kutta de ordem 2 para resolução numérica de EDO/PVI
%   y'=f(t,y), t=[a,b], y(a)=y0
%   y(i+1) = y(i)+1/2*(k1 + k2), i=0,1,2,...,n
%   Onde: 
%       k1=h*f(t(i),y(i);
%       k2=h*f(t(i+1),y(i)+ k1);

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

    h = (b-a)/n;       % Cálculo do passo
    t = a:h:b;         % Alocação de memória
    y = zeros(1,n+1);  % Alocação de memória
    y(1) = y0;         % Atribuição do valor y0 ao primeiro indice do vetor y

    for i =1:n                       % Ciclo com n iterações
        k1=h*f(t(i),y(i));           % Parâmetro k1
        k2=h*f(t(i+1),y(i)+ k1);     % Parâmetro k2
        y(i+1) = y(i)+1/2*(k1 + k2); % Cálculo do método RK2 até n
    end                              % Fim do ciclo FOR
end                                  % Indicação do fim da função







