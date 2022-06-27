function y = NODE45(f,a,b,n,y0)
%NODE45 Método ODE45(MatLab) para resolução numérica de EDO/PVI
%   y'=f(t,y), t=[a,b], y(a)=y0
%   [t,y] = ode45(odefun,tspan,y0)
%INPUT:
%   f - função da EDO y'=f(t,y)
%   [a,b] - intervalo de valores da variável independente t
%   n - núnmero de subintervalos ou iterações do método
%   y0 - aproximação inicial y(a)=y0
%OUTPUT:
%   y - vetor das soluções aproximadas do PVI em cada um dos t(i)
%   help ode45
    
%Nuno Domingues  a2020109910@isec.pt
%Miguel Neves    a2020146521@isec.pt
%Daniel Albino   a2020134077@isec.pt

%Data: 15/04/2021

    h = (b-a)/n;            % Cálculo do passo
    t = a:h:b;              % Alocação de memória
    [~,y] = ode45(f,t,y0);  % Cálculo através da função ODE45 até n
    y = y.';                % Equivalente a fazer uma transposta de um vetor
end