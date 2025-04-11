Integrantes:

Allan Carvalho de Aguiar

Bianka Vasconcelos

Isabelly Rohana

Luã Souza

Micael Viana

Vinicius Chagas

---

O problema ocorre porque o predicado base prolog

```prolog
plan_step(FinalState, FinalState, Plan, Plan)
```



é atingido imediatamente, já que a variável que representa o estado final (FinalState) é unificada com o estado corrente logo no início – mesmo que o estado inicial contenha zeros (ou seja, não esteja resolvido). Em outras palavras, sem uma verificação adicional para saber se o estado está realmente completo (sem células vazias), o Prolog interpreta que o estado corrente já é o estado final e encerra o planejamento, deixando o plano vazio.

---

### Como corrigir

Para resolver esse problema, é necessário modificar o predicado base de modo que ele só seja acionado quando o estado corrente estiver “resolvido” (ou seja, não contenha nenhum 0). Uma forma de fazer isso é introduzir um predicado auxiliar (por exemplo, `solved/1`) que percorre cada linha e confirma que não há nenhum 0.

#### Exemplo de implementação do predicado `solved/1`:

```prolog
solved([]). solved([Row|Rest]) :- \+ member(0, Row), solved(Rest).
```

#### Alterando o predicado base

Em vez de apenas: 

```prolog
plan_step(FinalState, FinalState, Plan, Plan).
```

```prolog
plan_step(State, State, Plan, Plan) :- solved(State).
```



Dessa forma, o predicado base só será satisfeito quando o estado atual estiver completamente preenchido (ou seja, quando não houver células com valor 0).



### Explicação da Solução

1. **Predicado `solved/1`:**  
   Verifica recursivamente cada linha do grid. Se alguma linha contém 0 (célula vazia), a condição falha.

2. **Predicado base de `plan_step/4`:**  
   Só é satisfeito se o estado corrente estiver resolvido. Isso evita que a recursão termine prematuramente quando FinalState é unificado com o estado corrente sem ter sido preenchido.

3. **Recursão do planejamento:**  
   Se houver células vazias (0), a recursão continua encontrando a posição vazia, preenchendo-a e registrando a ação realizada. O plano vai sendo construído com cada ação tomada.

Dessa forma, para a entrada:

```prolog
plan([ [1, 0, 0, 0], [0, 2, 0, 0], [0, 0, 3, 0], [0, 0, 0, 4] ], FinalState, Plan).
```

o estado final será o puzzle completamente preenchido (se existir solução) e o `Plan` conterá a sequência de ações que transformou o estado inicial no estado final, evitando que o plano retorne vazio.



O codigo com a solucao completa esta em um arquivo do repositorio



# Sobre Goal Regression

**Goal Regression** é uma técnica usada em planejamento de agentes autônomos e inteligência artificial para alcançar metas específicas. A abordagem envolve trabalhar *de trás para frente*, começando pelo objetivo final e identificando as ações e condições necessárias para alcançá-lo. A ideia central é decompor o objetivo em subobjetivos menores até que esses subobjetivos sejam alcançáveis diretamente, criando um plano estruturado para atingir o objetivo principal.
## **Como funciona o Goal Regression**

- **Planejamento Regressivo**: O processo começa com a identificação do objetivo final. Em seguida, determina-se quais ações podem alcançar esse objetivo e quais condições precisam ser verdadeiras para essas ações serem executadas. Essas condições se tornam novos subobjetivos.

- **Subdivisão de Metas**: Quando o objetivo é composto por várias partes (conjunções), cada parte é tratada separadamente, e os planos gerados são combinados. No entanto, isso pode criar interferências entre subplanos, exigindo ajustes cuidadosos.

- **Construção de Planos**: Os planos consistem em passos ordenados que descrevem as ações necessárias para atingir os subobjetivos. Cada passo é vinculado a um propósito específico dentro do plano geral.

## **Exemplo Prático**

Se o objetivo de um robô é segurar uma xícara de café, mas ele não está segurando café no momento:

1. A ação necessária seria pegar o café.

2. Para isso, o robô precisa estar na cafeteria, que se torna um novo subobjetivo.

3. O planejamento continua até que todos os subobjetivos sejam alcançados e o robô consiga executar a ação final de pegar o café.

## **Desafios e Soluções**

- **Interferência entre Subplanos**: Quando diferentes subplanos interferem uns nos outros, é necessário modificar as abordagens convencionais para lidar com essas situações.

- **Problema do Quadro (Frame Problem)**: Esse problema surge quando é difícil determinar quais aspectos do estado do mundo permanecem inalterados após uma ação. Soluções modernas buscam relaxar restrições sintáticas e incorporar causalidade mais complexa.

## **Aplicações**

Goal Regression é amplamente utilizado em sistemas de planejamento automatizado, como robótica, assistentes virtuais e jogos de estratégia. Ele permite que agentes lidem com ambientes dinâmicos e complexos ao criar planos flexíveis e adaptáveis para atingir metas específicas.

Essa abordagem forma a base de muitos sistemas avançados de inteligência artificial, contribuindo para a capacidade dos agentes de raciocinar sobre ações futuras e tomar decisões estratégicas.



# Diferença de Goal Regression para Mean Ends

**Goal Regression** e **Means-Ends Analysis (MEA)** são duas técnicas de planejamento em IA com abordagens distintas, embora ambas envolvam a decomposição de objetivos. Abaixo estão as diferenças principais:

## **1. Direção do Planejamento**

- **Goal Regression**:  
  Trabalha exclusivamente *de trás para frente*, partindo do objetivo final e decompondo-o em subobjetivos até que sejam alcançáveis.
  Exemplo: Se um robô precisa segurar uma xícara, identifica ações prévias (e.g., mover-se até a cafeteria) como subobjetivos.

- **Means-Ends Analysis (MEA)**:  
  Combina busca *para frente* e *para trás*. Inicia comparando o estado atual com o objetivo, aplica operadores para reduzir diferenças e cria submetas quando necessário.
  Exemplo: Se o objetivo é remover um ponto (diferença), aplica-se o operador "Delete" e ajusta-se o estado resultante.

## **2. Estratégia para Submetas**

- **Goal Regression**:  
  Foca na decomposição hierárquica do objetivo principal em subobjetivos menores, sem necessariamente abordar pré-condições de operadores.

- **MEA**:  
  Usa **Operator Subgoaling**: se um operador não pode ser aplicado (falta pré-condições), cria-se um subproblema para alcançar essas condições, misturando regressão e progressão.
  Exemplo: Para mover um objeto, se o caminho está bloqueado, define-se "desbloquear caminho" como submeta.

## **3. Complexidade e Aplicações**

- **Goal Regression**:  
  Adequado para ambientes complexos com interferências entre subplanos (e.g., robótica), exigindo ajustes para evitar conflitos.

- **MEA**:  
  Mais eficaz em problemas simples, onde diferenças entre estados são claras e operadores são bem definidos. Tem limitações em cenários complexos.

## **4. Origem e Contexto**

- **MEA**:  
  Desenvolvido por Allen Newell e Herbert A. Simon em 1961, como parte do **General Problem Solver (GPS)**, focado em reduzir diferenças entre estados.

- **Goal Regression**:  
  Associado a sistemas modernos de planejamento autônomo, derivado de técnicas de regressão de objetivos em IA.



A implementação para o versão com Goal Regression está disponível um arquivo no repo.
