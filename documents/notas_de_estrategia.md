# Notas de Estratégia

## Contexto
Essa documento será utilizada para aplicação dos testes exploratórios e início do entendimento da o sistema para cadastro de trabalhadores voltada ao contexto de segurança do trabalho, composta por:

- interface Web para cadastro e listagem de funcionários;
- API REST no endpoint `/employees`.

Não foi disponibilizada documentação formal de requisitos ou da API. Portanto, parte da exploração terá como objetivo entender o funcionamento esperado do sistema a partir da própria aplicação, dos elementos da interface e das respostas da API.

O foco inicial será compreender os principais fluxos, regras de negócio, estrutura dos dados e integração entre Web e API.

## Objetivo do teste
### Aplicação Web

Explorar o fluxo de cadastro de funcionários para responder perguntas como:

- Quais campos são obrigatórios?
- Quais validações existem nos campos?
- O sistema trata corretamente entradas válidas e inválidas?
- É possível concluir um cadastro com dados inconsistentes?
- O comportamento dos botões corresponde ao esperado?
- A listagem apresenta corretamente os funcionários cadastrados?
- O sistema apresenta comportamentos adequados de navegação e usabilidade?
- Existem dados pessoais expostos desnecessariamente na interface?
- Existe controle de acesso para manipulação de dados?

### API

Explorar o endpoint /employees para responder perguntas como:

- Quais métodos HTTP estão disponíveis?
- Qual estrutura de dados é esperada?
- Quais campos são obrigatórios?
- Os payloads inválidos ou incompletos são aceitos?
- Os códigos de status HTTP retornados são coerentes com cada operação?
- O tempo de resposta para cada operação é aceitável?
- Os dados criados ou alterados são persistidos corretamente?
- Atualizações completas e parciais preservam a integridade do registro?
- Registros excluídos deixam de ser retornados?
- Existem controles de autenticação ou autorização para acesso e manipulação dos dados?

### Integração Web + API

- Os campos obrigatórios na interface e na API são os mesmos?
- Os dados informados pela interface são persistidos corretamente no backend? 
- As alterações realizadas na API afetam corretamente a aplicação Web?

## Abordagem/Táticas: 
### Web

- Usar a heurística de caminhos felizes e infelizes.
- Identificar campos obrigatórios e opcionais.
- Testar campos vazios, valores inválidos e valores nos limites permitidos.
- Utilizar particionamento de equivalência para dividir entradas válidas e inválidas.
- Utilizar análise de valor limite quando houver tamanho mínimo, máximo ou quantidade de caracteres definida.
- Utilizar transição de estado em elementos do tipo Sim/Não e volta ao estado anterior Não/Sim.  
- Utilizar tabelas de decisão às combinações dos campos.
- Utilizar técnicas de adivinhação de erros (error guessing).
- Repetir ações e alterar a ordem de preenchimento para observar dependências entre campos.
- Explorar botões, filtros, navegação e comportamento da listagem.
- Redimensionar a tela para observar comportamento básico de responsividade.
- Inspecionar elementos e requisições pelo DevTools quando necessário.

### API

- Investigar DevTools após realizar ações na interface que possam mostrar endpoints.
- Testar chamadas sem credenciais para identificar possíveis controles de acesso.
- Realizar uma requisição inicial de leitura para compreender a estrutura dos registros.
- Explorar os métodos HTTP disponíveis no endpoint /employees.
- Testar requisições com payload válido.
- Testar payload vazio, incompleto e com estrutura diferente da observada.
- Alterar um campo por vez para entender o comportamento das atualizações.
- Comparar o estado do registro antes e depois de operações de alteração.
- Confirmar exclusões realizando uma nova consulta.
- Avaliar status HTTP, body, headers, tempo de resposta e persistência dos dados.

Web + API

- Comparar os dados exibidos ou informados na Web com os dados persistidos na API.
- Manipular registros na API e observar como a interface se comporta.

## O que ficou de fora
Nesta sessão exploratória inicial não serão aprofundados:

- Testes baseado em checklist, porque o checklist será criado após essa sessão.
- Testes de carga e stress.
- Análise de infraestrutura.
- Testes extensivos de compatibilidade entre navegadores.
- Testes extensivos em dispositivos móveis.
- Exploração ofensiva ou tentativa de execução de código.
- Testes avançados de segurança ou pentest.
- Análise de código-fonte.
- Validação de integrações externas não definidas no escopo inicial.

## Recursos/Ferramentas: 

- Google Chrome;
- Chrome DevTools;
- Postman;
- Dados gerados especificamente para teste;
- Diferentes combinações de dados válidos e inválidos;
- Arquivos de diferentes tipos para exploração do campo de upload;
- Anotações para registro das sessões exploratórias;
- Screenshots e respostas HTTP como evidências.

## Tempo Limite:
120 minutos.

## Resultados esperados
Ao final da sessão exploratória, deverão ser produzidos:

- Entendimento inicial do funcionamento da aplicação.
- Principais regras de negócio identificadas.
- Estrutura observada da API.
- Lista dos métodos e comportamentos explorados.
- Cenários candidatos a testes formais.
- Defeitos encontrados com passos para reprodução e evidências.
- Riscos que necessitem investigação adicional.
- Observações sobre consistência entre Web e API.
- Criação do Plano de Testes com base no conhecimento adquirido durante a exploração.
- Definição dos cenários mais relevantes para automação.