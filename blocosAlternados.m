%%
% AUTOR: GUSTAVO SIEBRA
% DATA: 24/04/2020
% LOCAL: MACAPA
% 
% METODO DOS BLOCOS ALTERNADOS
%% LIMPANDO VARIAVEIS
%
clc
clear all
close all
%% VARIAVEIS
%
dt = 6; %intervalo de discretizacao, em minutos.
Tr = 50; %Periodo de Retorno, em anos.
duracao = 60; %duracao do evento
%% INICIALIZACAO
%
n = duracao/dt; %numero de elementos do vetor chuva

indice(n,1) = 0;
td(n,1) = 0; %tempo de duracao, minutos
intensidade(n,1) = 0; %recebe o resultado da intensidade, mm/h
p(n,1) = 0; %precipitacao em milimetros
altura(n,1) = 0; %diferenca de laminacao da chuva em mm
hietograma(n,1) = 0; %hieograma bruto
posicao(n,1) = 0; %posicao ordenada
hieto_ba(n,1) = 0; %hietograma ordenado
resultado(n,7) = 0; %variavel que recebe todos os valores
%% NUCLEO
%
for m=1:n
    
    if m==1
        indice(m,1) = 1;
        td(m,1) = dt;
    else 
        indice(m,1) = indice(m-1,1) + 1;
        td(m,1) = dt + td(m-1);
    end
    
    %if m==1
    %    td(m,1) = dt;
    %else 
    %    td(m,1) = dt + td(m-1);
    %end
    
    % equacao da chuva de Fortaleza
    intensidade(m,1) = (2345.29*(Tr^0.173))/((td(m)+28.31)^0.904); 
    
    %calculo da precipitacao
    p(m,1) = intensidade(m) * (td(m)/60);
    
    %calculo da altura da lamina
    if m == 1
        altura(m) = p(m);
    else
        altura(m) = p(m) - p(m-1);
    end
    
    %hietograma nao balanceado
    hietograma(m,1) = (altura(m)/dt) * 60; % mm/h
end
%% BALANCEAMENTO DO HIETOGRAMA (IMPORTANTE)
%
%maximo = max(hietograma);

% verifica se e impar ou par
if mod(n,2) == 0
    sprintf('par');
    for i=1:n/2
        posicao(i,1) = n-((2*i)-1);
        %posicao(i,1) = n-((2*i)-2); %outra forma de calcular
    end

    for i=(n/2)+1:n
        posicao(i,1) = (2*i)-n;
        %posicao(i,1) = ((2*i)-1)-n; %outra forma de calcular
    end
else
    sprintf('é impar');
    for i=1:n/2
        posicao(i,1) = n-((2*i)-1);
    end

    for i=(n+1)/2:n
        posicao(i,1) = (2*i)-n;
    end
end
%% HIETOGRAMA BALANCEADO
%
for m=1:n
    hieto_ba = hietograma(posicao);
end
%% UNINDO TODOS OS RESULTADOS
%
resultado(:,1) = indice; %tempo de duracao, minutos
resultado(:,2) = td; %tempo de duracao, minutos
resultado(:,3) = intensidade; %recebe o resultado da intensidade, mm/h
resultado(:,4) = p; %precipitacao em milimetros
resultado(:,5) = altura; %diferenca de laminacao da chuva em mm
resultado(:,6) = hietograma; %hieograma bruto
resultado(:,7) = posicao; %posicao ordenada
resultado(:,8) = hieto_ba; %hietograma ordenado

resultado %escreve na tela

bar(td,hietograma) %mostra o grafico do tempo x hietograma
ylabel('precipitação (mm)');
xlabel('tempo (min)');
title('Hietograma')
figure
bar(td,hieto_ba) %mostra o grafico do tempo x hietograma
ylabel('precipitação (mm)');
xlabel('tempo (min)');
title('Hietograma')