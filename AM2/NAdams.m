function y = NAdams(f,a,b,n,y0)
%MAdams Método de Adams para resolução numérica de EDO/PVI
%   y'=f(t,y), t=[a,b], y(a)=y0
%   y(i+1)=y(i)+ (h/24) *(55*f(t(i),y(i)) - 59*f(t(i-1),y(i-1)) + 37*f(t(i-2),y(i-2)) - 9*f(t(i-3),y(i-3))), i=0,1,2,...,n
%INPUT:
%   f - função da EDO y'=f(t,y)
%   [a,b] - intervalo de valores da variável independente t
%   n - núnmero de subintervalos ou iterações do método
%   y0 - aproximação inicial y(a)=y0
%OUTPUT:
%   y - vetor das soluções aproximadas do PVI em cada um dos t(i)

% Como o método de Adams-Bashforth é um método de passo multiplo,
% precisamos de um método suplementar da mesma ordem, para calcular
% valores iniciais para que, depois o método adams possa continuar.

%Nuno Domingues  a2020109910@isec.pt
%Miguel Neves    a2020146521@isec.pt
%Daniel Albino   a2020134077@isec.pt

%Data: 15/04/2021

% SOL. NUMÉRICA DE EQ. DIF. ORDINÁRIAS- Met. Adams Bashforth de ordem 4
% **********************************************************
    
    h = (b-a)/n;    % Cálculo do passo
    t = a:h:b;      % Alocação de memória
    
    % Para iniciar: Runge-Kutta de ordem 4 
    b1 = a+3*h;     % Determinação do último valor do intervalo para RK4
    n1 = 3;         % número de partições para calcular em RK4
    yNAux = NAux(f,a,b1,n1,y0);  %Função auxiliar que calcular os primeiros 4 valores pelo RK4
    y = yNAux;  % Atribui os valores calculados em yNAux ao vetor y

    % Método de Adams - Bashforth de ordem 4(Passo múltiplo)
    for i=4:n
        y(i+1)=y(i)+ (h/24) *(55*f(t(i),y(i)) - 59*f(t(i-1),y(i-1)) + 37*f(t(i-2),y(i-2)) - 9*f(t(i-3),y(i-3)));
    end
end







   



