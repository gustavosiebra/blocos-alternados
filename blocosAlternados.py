##
# AUTOR: GUSTAVO SIEBRA
# DATA: 11/05/2020
# LOCAL: Fortaleza
# 
# METODO DOS BLOCOS ALTERNADOS

#import math
import numpy as np
import matplotlib.pyplot as plt

def blocosAlternados(dt, Tr, duracao):

    l = duracao/dt
    n = int(l)
    
    index =  [0 for x in range(1) for y in range(int(n))] 
    td =  [0 for x in range(1) for y in range(int(n))] 
    intensidade =  [[0 for x in range(1)] for y in range(int(n))] 
    p =  [0 for x in range(1) for y in range(int(n))] 
    altura =  [0 for x in range(1) for y in range(int(n))] 
    hietograma =  [0 for x in range(1) for y in range(int(n))] 
    posicao =  [0 for x in range(1) for y in range(int(n))] 
    hieto =  [0 for x in range(1) for y in range(int(n))] 
     
    result = [[0 for x in range(8)] for y in range(int(n))] 
    
    for j in range(int(n)):
        if j == 0:
            index[j] = 0
            td[j] = dt
        else:
            index[j] = index[j-1] + 1
            td[j] = td[j-1] + dt
        
        # equacao da chuva de Fortaleza
        #intensidade[j] = (2345.29*(math.pow(Tr, 0.173)))/(math.pow((td[j]+28.31),0.904))
        intensidade[j] = (2345.29*(Tr** 0.173))/((td[j]+28.31)**0.904)
        
        # calculo da precipitacao
        p[j]= intensidade[j] * (td[j]/60)
    
        if j == 0:
            altura[j] = p[j];
        else:
            altura[j] = p[j] - p[j-1]   
        
        # hietograma nao balanceado
        hietograma[j] = (altura[j]/dt) * 60 # mm/h
        
    ## BALANCEAMENTO DO HIETOGRAMA (IMPORTANTE)
    # verifica se e impar ou par
    if n%2 == 0:
        #sprintf('par');
        for i in range(0,int(n/2)):
            posicao[i] = n-((2*i)+2)
    
        for i in range((int(n/2)),int(n)):
            posicao[i] = (2*i)-n+1
    
    else:
        #sprintf('é impar')
        for i in range(0,int(n/2)):
            posicao[i] = n-((2*i)+2)
    
        for i in range((int(n/2)+1),int(n)):
            posicao[i] = (2*i)-n+1
        
    for m in range(0,int(n)):
        pos = posicao[m]
        hieto[m] = hietograma[pos]
    
        result[m][0] = index[m]
        result[m][1] = td[m]
        result[m][2] = round(intensidade[m],2)
        result[m][3] = round(p[m],2)
        result[m][4] = round(altura[m],2)
        result[m][5] = round(hietograma[m],2)
        result[m][6] = posicao[m]
        result[m][7] = round(hieto[m],2)
        
    #print(result)
    
    ## salvar em arquivo csv
    np.savetxt("resultado.csv", result, delimiter=",", fmt='%10.2f') 
    
    ## abrindo arquivo salvo
    a = open("resultado.csv", 'r')# open file in read mode  
    print(a.read()) 
    
    ## plotar os resultados
    plt.bar(td, hietograma)
    plt.xlabel('tempo (min)')
    plt.ylabel('precipitação (mm)')
    plt.title('hietograma')
    plt.show()
    plt.bar(td, hieto)
    plt.xlabel('tempo (min)')
    plt.ylabel('precipitação (mm)')
    plt.title('hietograma Balanceado')

## chamada da funcao
bloco = blocosAlternados(6, 50, 60)
