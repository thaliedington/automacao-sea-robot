# Plano de Testes - Web & API
## 1. Contexto e objetivo

A aplicação permite cadastrar e listar funcionários por uma interface Web e disponibiliza dados pelo endpoint REST /employees. Como não foram fornecidos requisitos formais nem documentação da API, uma sessão exploratória de 120 minutos foi usada para identificar fluxos, estrutura dos registros, comportamentos e riscos.
Este plano organiza as validações após essa exploração. Resultados esperados são definidos a partir das informações apresentadas pela interface, da finalidade das operações e das regras identificadas. Comportamentos cuja regra de negócio permanece incerta serão registrados como dúvidas, sem presumir que a implementação atual esteja correta.

## 2. Descobertas importantes

A exploração identificou riscos que exigem atenção aos detalhes:
- Acesso a dados pessoais: a listagem Web e as operações da API foram acessadas sem autenticação (BUG-005 e BUG-006).
- Integridade e disponibilidade: a API aceitou registros fora da estrutura observada; um desses registros impediu a renderização da Web. Também foram observadas substituições indevidas por PUT e perda de campos por PATCH (BUG-001 a BUG-004).
- Validação do cadastro: CPF inválido ou duplicado e campos preenchidos somente com espaços foram aceitos (BUG-008 a BUG-010).
- Consistência Web–API: houve divergências na persistência de Cargo, Atividade e EPI, além da permanência de dados de EPI após informar que o trabalhador não o utiliza (BUG-011 a BUG-015).
- Fluxo e usabilidade: foram observados problemas nos botões de adicionar atividade, adicionar EPI e avançar etapa, além de dificuldades na rolagem e em resoluções menores (BUG-016 a BUG-022).

Os detalhes, passos de reprodução e evidências estão no Relatório de Defeitos. Um cenário com defeito conhecido continua fazendo parte da cobertura, mesmo quando sua verificação permanece manual.

## 3. Escopo

| Camada | Validações planejadas |
|---|---|
| Web | Cadastro válido e inválido; obrigatoriedade e formato dos campos; CPF; estado Ativo/Inativo; Cargo, Atividade e EPI; upload de ASO; listagem, filtros, botões e navegação. |
| API | Estrutura dos registros; GET, HEAD, POST, PUT,PATCH e DELETE; respostas HTTP; persistência; payloads ausentes, incompletos ou fora da estrutura observada; acesso sem autenticação. |
| Integração | Comparar valores enviados pela Web com os retornados pela API; verificar o efeito de registros inválidos na interface; confirmar criação, alteração e exclusão por nova consulta. |
| Privacidade e segurança básica | Verificar exposição de dados pessoais, ausência de controle de acesso e aceitação de tipos de arquivo inadequados no campo ASO. |

Ficam fora do escopo testes de carga e estresse, pentest, análise de código-fonte, ampla matriz de navegadores e dispositivos, infraestrutura e integrações externas não identificadas.

## 4. Automação e evidências

- **Automatizados:** Os cenários que apresentaram resultados esperados e estáveis, serão automatizados para comprovação de evidências tanto da aplicação Web quanto da API.  
- **Não automatizados:** Os cenários que apresentam erro serão relatados no Relatório de Defeitos e os demais cenários que não apresentarem resultado conciso, serão incorporadoss ao final do Relatório de Defeitos no campo Observação.

## 5. Cenários de teste
### 5.1. CTs para Aplicação Web
Os cenários para aplicação Web são focados na experiência do usuário.

#### [CT-001] Validar Botão Ativo/Inativo
Dado que estou no formulário de cadastro de funcionário  
E o status inicial está Inativo
Quando altero o status para "Ativo"
Entao o estar deve estar Ativo
Quando altero o status para "Inativo"
Entao o status deve estar Inativo

#### [CT-002] Tentar cadastrar funcionário sem preencher campos obrigatórios
Dado que estou no formulário de cadastro de funcionário  
E nenhum campo obrigatório foi preenchido  
Quando clico em "Salvar"  
Então o funcionário não deve ser cadastrado  
E os campos obrigatórios devem ser destacados  
E o usuário deve permanecer no formulário  

#### [CT-003] Cadastrar funcionário com dados válidos
Dado que estou no formulário de cadastro de funcionário  
E preencho todos os campos obrigatórios com dados válidos  
E altero o status para "Ativo"  
Quando clico em "Salvar"  
Então o funcionário deve ser cadastrado com sucesso  
E deve aparecer na listagem de funcionários  

#### [CT-004] Filtrar funcionários ativos
Dado que estou na página inicial  
E existem funcionários ativos e inativos cadastrados  
Quando clico em “Ver apenas ativos”  
Então devem ser exibidos somente funcionários com status ativo  
E nenhum funcionário com status inativo deve ser exibido  

#### [CT-005] Limpar filtro de funcionários ativos
Dado que estou na página inicial  
E o filtro "Ver apenas ativos" está selecionado  
Quando clico em "Limpar filtros"  
Então a seleção do filtro "Ver apenas ativos" deve ser removida  
E a listagem deve exibir todos os cadastros  

#### [CT-006] Informar somente espaços em campo obrigatório
Dado que estou no formulário de cadastro de funcionário  
E preencho o campo Nome com um espaço  
E o campo RG com um espaço  
E altero o status para "Ativo"  
Quando clico em "Salvar"  
Então o cadastro não pode ser concluído  

#### [CT-007] Impedir cadastro com CPF já existente
Dado que existe um funcionário cadastrado com determinado CPF  
E estou no formulário de cadastro  
E informo o mesmo CPF  
E preencho os demais campos obrigatórios com dados válidos  
Quando clico em "Salvar"  
Então o cadastro não pode ser concluído  

#### [CT-008] Informar CPF com quantidade de dígitos inferior ao esperado
Dado que estou no formulário de cadastro  
E informo um CPF contendo apenas 10 dígitos  
E preencho os demais campos obrigatórios com dados válidos  
Quando clico em "Salvar"  
Então o campo deve informar que o CPF está incompleto  

#### [CT-009] Informar CPF com 12 dígitos
Dado que estou no formulário de cadastro  
E preencho os demais campos obrigatórios com dados válidos  
Quando informo um CPF contendo 12 dígitos  
Então o campo deve permitir apenas 11 dígitos  

#### [CT-010] Informar uma data de nascimento futura
Dado que estou no formulário de cadastro  
E preencho os demais campos obrigatórios com dados válidos  
Quando tento informar a data de nascimento "22/12/2026"  
Então o campo não deve permitir a seleção de datas futuras  

#### [CT-011] Validar persistência dos cargos
Dado que estou no formulário de cadastro de funcionário  
E preencho todos os campos obrigatórios com dados válidos  
E seleciono umas das opção do campo Cargo  
Quando concluo o cadastro  
E o cadastro foi ser realizado com sucesso  
Então o mesmo cargo deve persistir ao consultar no GET /employees  
E o campo 'role' deve retornar o valor correspondente ao cargo  

#### [CT-012] Cadastrar trabalhador sem EPI
Dado que estou no formulário de cadastro de funcionário  
E preencho todos os campos obrigatórios com dados válidos  
E preencho os campos EPI e Numero do CA
Quando informo que o trabalhar não usa EPI  
E clico em Salvar  
E o cadastro foi realizado com sucesso  
Então o campo os campos desabilitados não deve constar no GET /employees  

#### [CT-013] Validar persistência das atividades
Dado que estou no formulário de cadastro de funcionário  
E preencho todos os campos obrigatórios com dados válidos  
E seleciono umas das opção do campo Atividade  
Quando concluo o cadastroE o cadastro foi ser realizado com sucesso  
Então a mesmo atividade deve persistir ao consultar no GET /employees  
E o campo 'activity' deve retornar o valor correspondente a atividade  

#### [CT-014] Validar persistência dos EPIs
Dado que estou no formulário de cadastro de funcionário  
E preencho todos os campos obrigatórios com dados válidos  
E seleciono umas das opção do campo EPIs 
Quando concluo o cadastro  
E o cadastro foi ser realizado com sucesso  
Então o mesmo EPI deve persistir ao consultar no GET /employees  
E o campo 'epi' deve retornar o valor correspondente ao EPI  

#### [CT-015] Permitir rolagem na listagem quando houver muitos funcionários
Dado que estou na página inicial  
E existem funcionários cadastrados em quantidade suficiente para ultrapassar a área visível da tela   
Quando acesso a listagem utilizando o zoom padrão do navegador em 100%  
Então deve ser possível rolar a página ou a área da listagem  
E visualizar todos os cards de funcionários cadastrados  

#### [CT-016] Explorar números e caracteres especiais no Nome
Dado que estou no formulário de cadastro  
E os demais campos obrigatórios contêm dados válidos  
Quando informo M4ria! no campo Nome e tento salvar  
Então devo verificar se o valor é aceito ou se uma validação é apresentada  
E, se o cadastro for concluído, o nome exibido e o valor persistido na API devem corresponder ao valor aceito pela interface  

#### [CT-017] Tratar marcação HTML informada no Nome
Dado que estou no formulário de cadastro    
Quando informo o texto literal `<script>` no campo Nome    
E tento concluir o cadastro  
Então a aplicação não deve interpretar esse valor como marcação executável  
E, caso aceite o cadastro, deve exibir o valor como texto  

#### [CT-018] Colar texto longo no Nome
Dado que estou no formulário de cadastro  
Quando colo um texto com mais de 5.000 caracteres no campo Nome  
Então a interface deve permanecer utilizável  
E devo registrar se o campo limita, rejeita ou aceita o conteúdo  
E, caso aceite o cadastro, o valor persistido não deve divergir silenciosamente do valor apresentado ao usuário  

#### [CT-019] Informar somente letras no CPF
Dado que estou no formulário de cadastro  
E preencho os demais campos obrigatórios com dados válidos  
Quando informo somente letras no campo CPF e clico em “Salvar”  
Então o cadastro não deve ser concluído  
E o campo deve impedir a entrada ou apresentar uma validação compreensível  

#### [CT-020] Informar data inexistente em ano não bissexto
Dado que estou no formulário de cadastro  
E preencho os demais campos obrigatórios com dados válidos  
Quando tento informar 29/02/2023 como data de nascimento  
Então o campo não deve permitir a data inválida  

#### [CT-021] Explorar letras e traços no RG
Dado que estou no formulário de cadastro  
E preencho os demais campos obrigatórios com dados válidos  
Quando informo, separadamente, um RG com letras e um RG com traços  
Então devo registrar a validação apresentada para cada formato  
E, se algum valor for aceito, ele deve ser persistido sem alteração inesperada  

#### [CT-022] Alternar a opção “O trabalhador não usa EPI”
Dado que estou no formulário de cadastro  
Quando a opção “O trabalhador não usa EPI” está desmarcada  
Então os controles de EPI e Número do CA devem estar disponíveis para preenchimento  
Quando marco a opção  
Então esses controles devem ficar indisponíveis ou ocultos  
Quando desmarco a opção novamente  
Então os controles devem voltar a ficar disponíveis  

### [CT-023] Anexar Atestado de Saude Ocupacional Valido
Dado que estou no formulário de cadastro
E preencho os demais campos obrigatórios com dados válidos 
Quando anexo um arquivo válido
E clico no botão Salvar
Entao o cadastro deve ser realizado com sucesso

#### [CT-024] Validar comportamento de arquivo ASO de 50 MB
Dado que estou no formulário de cadastro  
Quando seleciono um arquivo .png de aproximadamente 50 MB no campo ASO  
Então devo verificar se há limite de tamanho e registrar a resposta da interface  
E a aplicação deve permanecer utilizável, informando claramente uma eventual rejeição  

#### [CT-025] Selecionar arquivo ASO vazio
Dado que estou no formulário de cadastro  
Quando seleciono um arquivo de 0 byte no campo ASO  
Então o sistema deve identificar que o arquivo não contém conteúdo válido  
E não deve tratá-lo como um ASO anexado com sucesso  

#### [CT-026] Substituir o ASO antes de salvar
Dado que estou no formulário de cadastro  
E selecionei o arquivo ASO “arquivo-A”  
Quando seleciono “arquivo-B” no mesmo campo e salvo o cadastro  
Então a interface deve indicar “arquivo-B” como arquivo selecionado  
E somente “arquivo-B” deve ser enviado  

#### [CT-027] Remover o ASO antes de salvar
Dado que estou no formulário de cadastro  
E selecionei um arquivo ASO  
Quando aciono a opção de remover o arquivo, caso ela esteja disponível  
Então o campo deve voltar ao estado sem arquivo  
E o arquivo removido não deve ser enviado ao salvar

#### [CT-028] Marcar a primeira etapa como concluída
Dado que estou no formulário de cadastro de funcionário  
E o etapa está marcada como Não
Quando altero a conclusão para "Sim"
Entao a etapa deve ser exibida como concluída
Quando altero o status para "Não"
Entao a exibição de concluída deve desaparecer

### 5.2. CTs para a API
Os cenários verificam respostas HTTP, estrutura e persistência dos dados no endpoint /employees. Para operações que alteram dados, utilizar registros criados especificamente para o teste e identificados pelo id.

#### [CT-030] Impedir consulta de dados pessoais sem autenticação
Dado que não forneci credenciais de autenticação  
Quando envio GET /employees  
Então a API deve negar o acesso aos dados pessoais  
E não deve retornar a lista de funcionários  

#### [CT-031] Impedir alterações sem autenticação
Dado que não forneci credenciais de autenticação  
E disponho de um registro criado para teste  
Quando tento executar POST /employees, PUT /employees/{id}, PATCH /employees/{id} e DELETE /employees/{id}  
Então cada operação deve ser negada  
E uma consulta posterior deve confirmar que nenhuma criação, alteração ou exclusão foi realizada  

#### [CT-032] Consultar a lista de funcionários por GET
Dado que tenho acesso ao endpoint /employees  
Quando envio GET /employees  
Então a resposta deve ter status 200  
E o corpo deve ser uma lista JSON  
E os registros válidos usados na verificação devem conter a estrutura state.employee  

#### [CT-033] Consultar os cabeçalhos por HEAD
Dado que tenho acesso ao endpoint /employees  
Quando envio HEAD /employees  
Então a resposta deve ter status 200  
E não deve conter corpo  

#### [CT-034] Criar funcionário com payload válido POST
Dado que tenho um funcionário de teste com payload válido na estrutura state.employee  
Quando envio POST /employees com esse payload  
Então a resposta deve ter status 201 e retornar um id  
E o registro consultado por GET deve conter os dados enviados  

#### [CT-035] Rejeitar POST sem corpo
Dado que tenho acesso ao endpoint /employees  
Quando envio POST /employees sem corpo de requisição  
Então a API deve retornar um erro de validação  
E não deve criar um registro sem state.employee  

#### [CT-036] Rejeitar POST com estrutura inválida
Dado que tenho um payload fora da estrutura esperada  
Quando envio POST /employees com esse payload  
Então a API deve retornar um erro de validação  
E o payload não deve aparecer como novo registro no GET /employees  

#### [CT-037] Substituir funcionário por PUT válido
Dado que criei um funcionário de teste e guardei seu id  
Quando envio PUT /employees/{id} com um payload completo e válido contendo um nome atualizado  
Então a resposta deve indicar sucesso  
E o GET deve retornar o novo nome e os demais dados enviados no payload  

#### [CT-038] Rejeitar PUT com estrutura inválida
Dado que criei um funcionário válido e guardei seus dados originais  
Quando envio PUT /employees/{id} sem a estrutura state.employee  
Então a API deve retornar um erro de validação  
E o GET deve mostrar que o registro original foi preservado  

#### [CT-039] Preservar os demais campos no PATCH
Dado que criei um funcionário com todos os campos necessários  
E guardei os valores retornados pelo GET  
Quando envio PATCH /employees/{id} alterando somente state.employee.name  
Então a resposta deve indicar sucesso  
E o GET deve retornar o novo nome  
E os demais campos do funcionário devem manter os valores anteriores  

#### [CT-040] Excluir funcionário por DELETE
Dado que criei um funcionário de teste e guardei seu id  
Quando envio DELETE /employees/{id}  
Então a resposta deve indicar sucesso  
E uma nova consulta não deve retornar o registro excluído  