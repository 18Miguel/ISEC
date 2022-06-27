function y = NEulerM(f,a,b,n,y0)
%NEULERM Método de Euler Melhorado para resolução numérica de EDO/PVI
%   y'=f(t,y), t=[a,b], y(a)=y0
%   y(i+1) = y(i)+ (h/2)*(f(t(i),y(i))+f(t(i+1),y(i)+h*f(t(i),y(i)))), i=0,1,2,...,n

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
    h2 = h/2;          % Atribuição da divisão h/2, para eficiência no ciclo FOR

    for i =1:n                                            % Ciclo com n iterações
        y(i+1) = y(i)+h*f(t(i),y(i));
        y(i+1) = y(i)+h2*(f(t(i),y(i))+f(t(i+1),y(i+1))); % Cálculo do Método de Euler Melhorado até n
    end                                                   % Fim do ciclo FOR
end                                                       % Indicação do fim da função