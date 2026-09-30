# Relatório de Defeitos — Desafio Prático - SEA Tecnologia

## Resumo executivo

| ID | Prioridade | Área | Defeito |
|---|---|---|---|
| BUG-001 | P1 | Web | Registro fora do padrão quebra a renderização da aplicação Web |
| BUG-002 | P1 | API | Método POST aceita criação de registro sem payload |
| BUG-003 | P1 | API | Método PUT permite substituir `state.employee` por estrutura fora do padrão esperado |
| BUG-004 | P1 | API | Método PATCH remove campos não enviados em atualização parcial |
| BUG-005 | P1 | Web | Dados pessoais expostos em listagem acessível sem autenticação |
| BUG-006 | P1 | API | API sem autenticação que permite acesso e manipulação dados pessoais |
| BUG-007 | P2 | Web | Upload irrestrito de arquivos no campo de anexar ASO |
| BUG-008 | P2 | Web | Campo CPF aceita letras |
| BUG-009 | P2 | Web | Cadastro aceita CPF inválido de 11 dígitos |
| BUG-010 | P2 | Web | Cadastro permite CPF já existente |
| BUG-011 | P2 | Web | Campos obrigatórios aceitam apenas espaços em branco |
| BUG-012 | P2 | Web | EPI selecionado é alterado para `Capacete de segurança` ao preencher o número do CA |
| BUG-013 | P2 | API | Dados de EPI persistem na API após trabalhador informar que não usa EPI |
| BUG-014 | P2 | API | `Cargo 01` selecionado não é persistido no campo `role` |
| BUG-015 | P2 | API | `Ativid 01` selecionado não é persistido no campo `activity` |
| BUG-016 | P2 | API | EPI `Capacete de segurança` selecionado não é persistido no campo `epi` |
| BUG-017 | P2 | Web | Botão `Adicionar outra atividade` se comporta como botão "Salvar" |
| BUG-018 | P2 | Web | Botão `Próximo passo` não avança para a etapa seguinte |
| BUG-019 | P3 | Web | Função para adicionar outro EPI sem resposta |
| BUG-020 | P3 | Web | Campo Data de Nascimento aceita data futura |
| BUG-021 | P3 | Web | Listagem de funcionários não permite rolagem vertical adequada |
| BUG-022 | P3 | Web | Campo ASO não permite remover o arquivo selecionado antes de salvar |
| BUG-023 | P4 | Web | Página inicial exibe texto provisório `Lorem ipsum` |
| BUG-024 | P4 | Web | Elementos da interface ficam sobrepostos em resoluções menores |
| BUG-025 | P4 | Web | Todas as etapas são identificadas como `ITEM 1` |

> **Critério de prioridade:** P1 = urgente/crítica - interrompe uma função essencial ou permite exposição, alteração ou exclusão não autorizada de dados pessoais; P2 = alta - afeta as funções principais, mas não impede completamente o uso ou perda da integridade do dado; P3 = moderada - impacta funções secundárias; P4 = leve - problemas de usabilidade ou inconsistências que não afetam a funcionalidade.

## Descrição dos defeitos
#### BUG-001 — Registro fora do padrão quebra a renderização da aplicação Web

**Prioridade:** P1  
**Área:** Web + API / Resiliência  
**Cenário relacionado:** CT-035, CT-036, CT-003

**Passos:**
1. Acessar a página inicial e confirmar ela está renderizando normalmente.
2. Criar via `POST /employees` um registro fora da estrutura esperada, por exemplo:

```json
{
  "teste": "dados"
}
```

3. Guardar o valor do id criado.
4. Voltar a aplicação Web e atualizar a página inicial.
5. Consultar o Console do DevTools.
6. Excluir via `DELETE /employees/{id}` o registro fora do padrão.
7. Atualizar a página inicial.

**Resultado esperado:**  
A interface deve tratar registros inválidos de forma segura e continuar renderizando a cada atualização.

**Resultado obtido:**  
Após a criação do registro fora do padrão, a página deixa de renderizar corretamente exibindo uma tela branca e o erro no DevTools: "TypeError: Cannot read properties of undefined (reading 'employee')". Ao excluir o registro inválido pela API e atualizar a página, a interface volta ao normal esperado.

**Evidência:**  

https://github.com/user-attachments/assets/a0a65ac5-2412-4f69-ae80-e70858c3b400


**Impacto:** 
Um único registro inconsistente na API pode indisponibilizar a aplicação.

#### BUG-002 — API permite criar registro fora do schema esperado

**Prioridade:** P1  
**Área:** API / Integridade de dados  
**Cenário relacionado:** CT-035

**Endpoint:** `POST /employees`

**Passos:**
1. Enviar requisição sem body.
2. Guardar valor do id criado.
3. Consultar `GET /employees`.
4. Após observar, excluir via `DELETE /employees/{id}` o registro fora do padrão

**Resultado esperado:**  
A API deve rejeitar payloads que não atendam ao formato `state.employee`.

**Resultado obtido:**  
O registro é criado e passa a constar no `GET /employees` fora do schema padrão.

**Evidência**
![BUG 002 - Post](<../resources/files/bugs/bug002-postForaDoPadrao[0].png>)
![BUG-002 - Get](<../resources/files/bugs/bug002-postForaDoPadrao[1].png>)

**Impacto:** 
A API permite criar dados estruturalmente inconsistentes, conforme relatado no BUG-001 esses registros causam indisponibilidade na interface.

#### BUG-003 — Método PUT permite substituir `employee` por estrutura fora do padrão esperado

**Prioridade:** P1  
**Área:** API / Integridade de dados  
**Cenário relacionado:** CT-038

**Endpoint:** `PUT /employees/{id}`

**Passos:**
1. Garantir que exista um funcionário com dados válidos cadastrado.
2. Enviar uma requisição `PUT` para o registro utilizando uma estrutura fora do padrão esperado, por exemplo:

```json
{
  "state": {
    "testes": "dados"
  }
}
```

**Resultado esperado:**
A API deve rejeitar a atualização quando o payload não respeitar a estrutura esperada do recurso, retornando um erro de validação e preservando os dados existentes.

**Resultado obtido:**
A API aceita a requisição e substitui o conteúdo anterior de state pela estrutura enviada, removendo os dados de employee.

**Evidência:**

https://github.com/user-attachments/assets/9a9552fe-e66e-47ac-bc1a-abe190b7fa6f


**Impacto:**
Permite sobrescrever um registro válido com uma estrutura incompatível com o padrão utilizado pela aplicação, causando perda de dados e conforme relatado no BUG-001 esses registros causam indisponibilidade na interface.

#### BUG-004 — Método PATCH apaga campos não enviados na atualização parcial

**Prioridade:** P1  
**Área:** API / Integridade de dados  
**Cenário relacionado:** CT-039

**Endpoint:** `PATCH /employees/{id}`

**Passos:**
1. Garantir que exista um funcionário com o cadastro de campos obrigatórios preenchido.
2. Enviar uma requisição `PATCH` contendo apenas o campo `name` para atualizar:

```json
{
  "state": {
    "employee": {
      "name": "Atualizacao de PATCH"
    }
  }
}
```

3. Verificar no GET se apenas o campo `name` foi alterado no registro.

**Resultado esperado:**
O método PATCH deve atualizar somente o campo enviado na requisição e preservar os demais dados já existentes em state.employee.

**Resultado obtido:**
O conteúdo anterior de state.employee é substituído pelo payload enviado. Os demais campos do funcionário são removidos e apenas name permanece.

**Evidência:**

https://github.com/user-attachments/assets/ad5e6e48-7ab2-4375-bd30-b7af0c663ac9


**Impacto:**
Uma atualização parcial pode apagar informações previamente cadastradas do funcionário, causando perda de dados e comprometendo a integridade do registro e conforme relatado no BUG-001 esses registros causam indisponibilidade na interface.

#### BUG-005 — Dados pessoais exposto em listagem acessível sem login

**Prioridade:** P1  
**Área:** Web / Privacidade  
**Cenário relacionado:** Sem CT específico

**Pré-condição:** Existir funcionários cadastrados com Nome e CPF completo.

**Passos:**
1. Acessar a página inicial sem autenticação.
2. Visualizar os cards de funcionários.

**Resultado esperado:**  
A listagem pública não deve expor o Nome e o CPF  dos trabalhadores.

**Resultado obtido:**  
Os cards exibem o Nome e o CPF na Página Inicial.

**Evidência:**  
![BUG 005](<../resources/files/bugs/bug005-LGPD.png>)

**Impacto:** 
Exposição indevida de dado pessoal (LGPD) em uma página acessível sem autenticação.

#### BUG-006 — API permite acesso e manipulação de dados pessoais sem autenticação

**Prioridade:** P1  
**Área:** API / Segurança / Privacidade  
**Cenário relacionado:** CT-030 e CT-031

**Passos:**
1. Acessar diretamente o endpoint `/employees` sem realizar autenticação.
2. Executar uma requisição `GET` para consultar os funcionários cadastrados.
3. Executar operações de criação, alteração ou exclusão de registros utilizando os métodos disponíveis da API.
4. Verificar as respostas retornadas.

**Resultado esperado:**  
O acesso a dados pessoais e as operações de criação, alteração ou exclusão de funcionários devem exigir autenticação e autorização adequadas.

**Resultado obtido:**  
A API permite consultar e manipular registros de funcionários sem solicitar autenticação.

Foram observadas operações disponíveis sem autenticação, incluindo:

- consulta de registros por `GET`;
- criação de registros por `POST`;
- alteração por `PUT` e `PATCH`;
- exclusão por `DELETE`.

**Evidência:**  
![BUG 006](<../resources/files/bugs/bug006-noAuth.png>)

**Impacto:**  
Permite que usuários não autenticados tenham acesso a dados pessoais de funcionários e realizem alterações ou exclusões nos registros. O comportamento compromete a confidencialidade e a integridade das informações armazenadas e pode resultar em exposição, modificação ou perda não autorizada de dados.

### BUG-007 — Upload irrestrito de arquivos no campo de anexar ASO

**Prioridade:** P2  
**Área:** Web / Segurança / OWASP TOP 10  
**Cenário relacionado:** Sem CT específico

**Passos:**
1. Acessar o formulário de cadastro de funcionário.
2. Preencher os campos obrigatórios com dados válidos.
3. Tentar anexar um arquivo sem extensão no campo ASO.
4. Repetir o teste utilizando um arquivo com extensão potencialmente executável, como `.php`, `.exe` ou `.sh`.
5. Salvar o registro.

**Resultado esperado:**  
O sistema deve aceitar somente formatos de arquivo definidos para o envio de um ASO e rejeitar arquivos com extensões potencialmente executáveis.

**Resultado obtido:**  
O campo de upload aceita arquivos arquivos com tipo perigoso, sem apresentar mensagem de validação.

**Evidência:**  

https://github.com/user-attachments/assets/2433c55e-6808-4dc1-bfd2-d0c2e86ea930


**Impacto:**  
A ausência de uma validação adequada de tipo de arquivo aumenta o risco de envio de conteúdo não previsto ou tipo perigoso. De acordo com o OWASP Top 10:2025 esse comportamento está relacionado à ***CWE-434 — Unrestricted Upload of File with Dangerous Type*** na categoria [***A06:2025 — Insecure Design***](https://top10.owasp.org/2025/A06_2025-Insecure_Design/).

### BUG-008 — Campo CPF aceita letras

**Prioridade:** P2  
**Área:** Web / Validação de dados  
**Cenário relacionado:** CT-019  

**Passos:**
1. Acessar o formulário de cadastro de funcionário.
2. Preencher o nome.
3. Informar 11 letras, como `abcdefghijk` no campo CPF.
4. Clicar em “Salvar”.
5. Observar como a página responde.

**Resultado esperado:**  
O campo deve impedir a entrada de letras ou informar que o CPF contém caracteres inválidos. Um CPF composto por letras não deve ser considerado válido.

**Resultado obtido:**  
O campo mantém as 11 letras e não apresenta mensagem de validação para o CPF. Ao clicar em “Salvar”, a validação aponta o próximo campo obrigatório, sem apontar erro no CPF.

**Evidência:**  

https://github.com/user-attachments/assets/06b17a6a-ec9a-42ce-adbf-a0b976556f61


https://github.com/user-attachments/assets/aae5867f-bd5f-425e-9597-ac5892aa435e


**Impacto:**  
CPF é um dado único composto apenas por números e a interface não identifica o formato inválido, criando risco de cadastro de dados inconsistentes.

### BUG-009 — Cadastrar CPF de 11 dígitos inválido

**Prioridade:** P2  
**Área:** Web / Validação de dados  
**Cenário relacionado:** Sem CT específico

**Passos:**
1. Acessar o formulário de cadastro de funcionário.
2. Informar o CPF inválido `00000000000`.
3. Preencher os demais campos obrigatórios com dados válidos.
4. Clicar em `Salvar`.

**Resultado esperado:**  
O cadastro não deve ser concluído e o campo CPF deve informar que o valor preenchido é inválido.

**Resultado obtido:**  
O sistema permite prosseguir com um CPF de 11 dígitos que não é válido.

**Evidência:**  

https://github.com/user-attachments/assets/138aaa95-05a6-431d-9175-d2d9797c9044


**Impacto:** Permite o armazenamento de um CPF inválido, comprometendo a integridade e a confiabilidade dos dados cadastrais.

### BUG-010 — Duplicar CPF já existente em novo cadastro

**Prioridade:** P2  
**Área:** Web / Validação de dados  
**Cenário relacionado:** CT-007

**Passos:**
1. Garantir que exista um funcionário cadastrado com determinado CPF.
2. Acessar o formulário de cadastro.
3. Informar o mesmo CPF já existente.
4. Preencher os demais campos obrigatórios com dados válidos.
5. Clicar em `Salvar`.

**Resultado esperado:**  
O cadastro não deve ser concluído e o sistema deve informar que o CPF já está cadastrado.

**Resultado obtido:**  
O sistema permite concluir um novo cadastro utilizando um CPF já existente.

**Evidência:**  

https://github.com/user-attachments/assets/a10a4c9b-28b8-4739-9c23-a26f1d980a63


**Impacto:** CPF é um dado único. Permitir registros duplicados para o mesmo CPF  compromete a unicidade, rastreabilidade e confiabilidade dos dados cadastrais.

### BUG-011 — Cadastrar campos obrigatórios apenas com espaços

**Prioridade:** P2  
**Área:** Web / Validação de dados  
**Cenário relacionado:** CT-006

**Passos:**
1. Acessar o formulário de cadastro de funcionário.
2. Preencher o campo Nome somente com espaço.
3. Preencher o campo RG somente com espaço.
4. Preencher o campo número do CA somente com espaço.
4. Preencher campo CPF e Data de Nascimento com dados válidos.
4. Clicar em `Salvar`.

**Resultado esperado:**  
O cadastro não deve ser concluído quando campos obrigatórios contêm apenas espaços em branco.

**Resultado obtido:**  
O sistema prossegue com o cadastro mesmo com campos obrigatórios preenchidos somente com espaços.

**Evidência:**  

https://github.com/user-attachments/assets/0bba7d3c-d035-4843-b6e1-39cc4d13d94d


**Impacto:**  Permite o armazenamento de dados obrigatórios sem informação real, comprometendo a qualidade e a consistência dos registros cadastrados.

### BUG-012 — EPI selecionado é alterado para `Capacete de segurança` ao preencher o número do CA

**Prioridade:** P2  
**Área:** Web / Formulário / Integridade de dados  
**Cenário relacionado:** CT-014

**Passos:**
1. Acessar o formulário de cadastro de funcionário.
2. Selecionar um EPI diferente de `Capacete de segurança`, por exemplo `Luvas descartáveis`.
3. Interagir com o campo `Informe o número do CA:`.
4. Observar o valor selecionado no campo EPI.

**Resultado esperado:**  
O EPI selecionado deve permanecer inalterado ao interagir com outros campos.

**Resultado obtido:**  
Ao interagir com o campo `Informe o número do CA:`, o EPI previamente selecionado é alterado automaticamente para `Capacete de segurança`.

**Evidência:**  

https://github.com/user-attachments/assets/bc5c1d57-aa6f-4399-9796-12475441d430


**Impacto:**  
Pode provocar o cadastro de um EPI diferente daquele informado pelo usuário, comprometendo a consistência e a confiabilidade dos dados de segurança do trabalhador.

### BUG-013 — Dados de EPI persistem na API após trabalhador informar que não usa EPI

**Prioridade:** P2  
**Área:** Web + API / Integridade de dados / Regra de negócio  
**Cenário relacionado:** CT-012

**Passos:**
1. Acessar o formulário de cadastro de funcionário.
2. Selecionar uma atividade diferente de `Ativid 01`.
3. Selecionar um EPI diferente de `Capacete de segurança`.
4. Informar o número do CA.
5. Marcar a opção `O trabalhador não usa EPI`.
6. Salvar o cadastro.
7. Consultar o registro criado pela API.

**Resultado esperado:**  
Ao marcar que o trabalhador não usa EPI, os campos de Atividade, EPI e Número do CA devem ser desconsiderados e não devem ser persistidos no registro.

**Resultado obtido:**  
Após marcar que o trabalhador não usa EPI, os campos ficam indisponíveis para edição na interface, porém os valores anteriormente informados continuam persistidos na API.

**Evidência:**  

https://github.com/user-attachments/assets/a539711e-a1d7-462b-a744-7e85107da776


**Impacto:**  
O sistema mantém informações incompatíveis com a opção selecionada pelo usuário, gerando inconsistência entre a interface e os dados persistidos. Isso pode comprometer a confiabilidade das informações de segurança do trabalhador e afetar regras de negócio que dependam do indicador de uso de EPI.

### BUG-014 — `Cargo 01` não é persistido no campo `role`

**Prioridade:** P2  
**Área:** Web + API / Persistência  
**Cenário relacionado:** CT-011

**Passos:**
1. Acessar o formulário de cadastro de funcionário.
2. Preencher os campos obrigatórios com dados válidos.
3. Selecionar `Cargo 01`.
4. Salvar o cadastro.
5. Localizar o mesmo funcionário no `GET /employees` pelo CPF.

**Resultado esperado:**
O valor selecionado no campo Cargo deve ser persistido corretamente no campo `role` do registro retornado pela API.

**Resultado obtido:**
O cadastro é concluído na interface, porém o valor `Cargo 01` não é persistido corretamente no campo `role`.

**Evidência:** 

https://github.com/user-attachments/assets/39dc940f-9c64-4e09-869d-1d8dce760d30


**Impacto:** Informação selecionada na interface não é persistida corretamente no backend.

### BUG-015 — `Ativid 01` selecionada não é persistida no campo `activity`

**Prioridade:** P2  
**Área:** API / Integridade de dados  
**Cenário relacionado:** CT-013

**Passos:**
1. Acessar o formulário de cadastro de funcionário.
2. Preencher os campos obrigatórios com dados válidos.
3. Selecionar a atividade `Ativid 01`.
4. Salvar o cadastro.
5. Consultar o funcionário criado por meio do `GET /employees`.

**Resultado esperado:**  
O valor selecionado no campo Atividade deve ser persistido corretamente no campo `activity` do registro retornado pela API.

**Resultado obtido:**  
O cadastro é concluído na interface, porém o valor `Ativid 01` não é persistido corretamente no campo `activity`.

**Evidência:**  

https://github.com/user-attachments/assets/fce2ea71-02f2-4617-a4b0-002692118da5


**Impacto:**  
O sistema perde uma informação relevante informada pelo usuário após um cadastro aparentemente concluído com sucesso, comprometendo a integridade e a completude dos dados do funcionário.

### BUG-016 — EPI `Capacete de segurança` não é persistido

**Prioridade:** P2  
**Área:** Web + API / Persistência  
**Cenário relacionado:** CT-014

**Passos:**
1. Acessar o formulário de cadastro de funcionário.
2. Preencher os campos obrigatórios com dados válidos.
3. Selecionar `Capacete de segurança` no campo EPI.
4. Salvar.
5. Consultar o registro pelo CPF em `GET /employees`.

**Resultado esperado:**  
O valor selecionado no campo EPI deve ser persistido corretamente no campo `epi` do registro retornado pela API.

**Resultado obtido:**  
O cadastro é concluído na interface, porém o `epi` não aparece no registro.

**Evidência:**  

https://github.com/user-attachments/assets/845f79ec-7ca8-4b63-a2c3-e3978de79d4a


**Impacto:** Perda do EPI selecionado durante a persistência.

### BUG-017 — Botão `Próximo passo` não avança para a próxima etapa

**Prioridade:** P2  
**Área:** Web / Navegação  
**Cenário relacionado:** Sem CT específico

**Passos:**
1. Acessar a página inicial.
2. Marcar a etapa atual como concluída.
3. Clicar em `Próximo passo`.

**Resultado esperado:**  
A aplicação deve avançar para outra etapa.

**Resultado obtido:**  
Elementos da página atual continuam visíveis após o clique, indicando que não houve avanço.

**Evidência:**  

https://github.com/user-attachments/assets/7665cf7c-e5d7-49f6-8790-f51e28c513ad


**Impacto:** Bloqueia ou prejudica a continuidade do fluxo principal.

### BUG-018 — Botão `Adicionar outra atividade` se comporta como botão `Salvar`

**Prioridade:** P2  
**Área:** Web / Funcionalidade  
**Cenário relacionado:** CT-029

**Passos:**
1. Acessar o formulário de cadastro de funcionário.
2. Clicar no botão "Adicionar outra atividade".
3. Preencher os campos obrigatórios (Nome, CPF, RG, Data de Nascimento e Numero do CA) com dados válidos.
4. Clicar novamente no botão "Adicionar outra atividade".

**Resultado esperado:**  
O sistema deve exibir um novo campo para permitir o cadastro de uma segunda atividade.

**Resultado obtido:**  
Ao clicar no botão com os campos vazio, ele informa que o campo Nome é obrigatório e ao clicar após preencher os dados, o formulário salva o novo registro funcionando como o botão Salvar.

**Evidência:**  

https://github.com/user-attachments/assets/db789009-d179-4253-8b34-90913f1535c1


**Impacto:**  
Impede o cadastro de múltiplas atividades para o mesmo funcionário, comprometendo a completude das informações registradas.

### BUG-019 — Função para adicionar outro EPI sem resposta

**Prioridade:** P3  
**Área:** Web / Funcionalidade  
**Cenário relacionado:** Sem CT específico

**Passos:**
1. Acessar o formulário de cadastro de funcionário.
2. Preencher os dados do EPI.
3. Clicar em `Adicionar EPI`.

**Resultado esperado:**  
O aplicação deve responder com alguma ação, como aparecer uma segunda linha para escolher o EPI e informar o Número do CA.

**Resultado obtido:**  
Nada acontece após solicitar a inclusão de outro EPI.

**Evidência:**  

https://github.com/user-attachments/assets/23d9c299-889a-4028-8d62-b137d2727fd8


**Impacto:** 
Impede o cadastro de mais de um EPI para a mesma atividade, limitando o registro correto dos equipamentos utilizados pelo trabalhador.

### BUG-020 — Campo de data de nascimento aceita data futura

**Prioridade:** P3  
**Área:** Web / Validação de dados  
**Cenário relacionado:** CT-010

**Passos:**
1. Acessar o formulário de cadastro de funcionário.
2. Informar uma data de nascimento futura.

**Resultado esperado:**  
O sistema não deve permitir uma data de nascimento posterior à data atual.

**Resultado obtido:**  
O campo aceita uma data futura sem apresentar validação ou impedir o preenchimento.

**Evidência:**  
![BUG-019](<../resources/files/bugs/bug019-dataFutura.png>)

**Impacto:**  
Permite o cadastro de uma informação inválida, comprometendo a consistência dos dados do funcionário.

### BUG-0021 — Listagem com muitos funcionários não permite rolagem vertical adequada

**Prioridade:** P3  
**Área:** Web / Usabilidade  
**Cenário relacionado:** CT-015

**Pré-condição:** Existirem vários cards de funcionários.

**Passos:**
1. Acessar a página inicial.
2. Manter o navegador em zoom normal.
3. Tentar visualizar os últimos funcionários da listagem.

**Resultado esperado:**  
O usuário deve conseguir percorrer a listagem e visualizar todos os registros.

**Resultado obtido:**  
Não há rolagem vertical para visualizar todos os cards, sendo necessário reduzir o zoom do navegador.

**Evidência:**

https://github.com/user-attachments/assets/32f3e48d-ae14-4eaa-bcb4-68aac37425af


**Impacto:** 
Registros inacessíveis em condições normais de uso.

### BUG-022 — Campo ASO não permite remover o arquivo selecionado antes de salvar

**Prioridade:** P3  
**Área:** Web / Upload / Usabilidade  
**Cenário relacionado:** CT-027 

**Pré-condição:** Estar no formulário de cadastro de funcionário.

**Passos:**
1. Selecionar um arquivo válido no campo ASO.
2. Confirmar que o nome do arquivo aparece no formulário.
3. Tentar remover o anexo antes de salvar, sem selecionar outro arquivo.

**Resultado esperado:**  
Como o ASO é opcional, deve ser possível remover o arquivo selecionado e voltar ao estado sem anexo antes de salvar.

**Resultado obtido:**  
O formulário apresenta o nome do arquivo e a opção “Selecione o arquivo”, mas não oferece uma ação para remover o anexo e deixar o campo vazio.

**Evidência:**  

https://github.com/user-attachments/assets/46ade099-3ad6-4193-bedc-2ac40ba2488e

**Impacto:**  
O usuário não consegue corrigir uma seleção acidental para concluir o cadastro sem anexo.

### BUG-023 — Página inicial exibe texto provisório `Lorem ipsum`

**Prioridade:** P4  
**Área:** Web / Conteúdo e apresentação   
**Cenário relacionado:** Sem CT específico

**Passos:**
1. Acessar a página inicial.
2. Visualizar o texto de apresentação a esquerda.

**Resultado esperado:**  
A página inicial deve exibir conteúdo definitivo e apropriado ao contexto da aplicação.

**Resultado obtido:**  
O texto de apresentação contém conteúdo provisório com `Lorem ipsum`.

**Evidência:**  
![BUG-023](<../resources/files/bugs/bug021-loremIpsum.png>)

**Impacto**: 
Reduz a qualidade percebida da interface e não agrega conteúdo ao usuário.

### BUG-024 — Elementos da interface ficam sobrepostos em resoluções menores

**Prioridade:** P4  
**Área:** Web / Responsividade / Usabilidade   
**Cenário relacionado:** Sem CT específico

**Passos:**
1. Acessar a aplicação Web.
2. Reduzir a largura da janela do navegador.
3. Observar o comportamento dos elementos da interface.

**Resultado esperado:**  
Os componentes da página devem se adaptar ao espaço disponível, mantendo o conteúdo legível, acessível e sem sobreposição entre os elementos.

**Resultado obtido:**  
Ao reduzir o tamanho da janela, alguns elementos não se reorganizam corretamente e passam a ficar sobrepostos.

**Evidência:**  
![BUG-024](<../resources/files/bugs/bug022-sobrepostos.png>)

**Impacto:**  
Prejudica a legibilidade e a utilização da aplicação em telas menores ou janelas redimensionadas, reduzindo a qualidade da experiência do usuário.

## BUG-025 — Todas as etapas são identificadas como `ITEM 1`

**Prioridade:** P4  
**Área:** Web / Conteúdo e navegação  
**Cenário relacionado:** Sem CT específico.

**Passos:**
1. Acessar a página inicial.
2. Observar os indicadores de etapas exibidos no topo da página.
3. Comparar os nomes apresentados em cada posição.

**Resultado esperado:**  
Cada etapa deve ter uma identificação distinta e coerente com sua posição, permitindo ao usuário reconhecer a etapa atual e as seguintes.

**Resultado obtido:**  
Todos os indicadores apresentam o mesmo nome, `ITEM 1`, mesmo ocupando posições diferentes.

**Evidência:**  
![BUG-025](<../resources/files/bugs/bug025-item1.png>)

**Impacto:**  
A repetição dos nomes dificulta entender a sequência e acompanhar o progresso das etapas.

## Observações

- O 3 pontinhos ao lado do card Ativos/Inativos não tem função, mas não há um embasamento suficiente para afirmar que devia funcionar.
- 'usesEpi = true' quando funcionário informa que não usa EPI parece confuso, mas cai no mesmo problema da falta de documentação.
- Diferenças de representação entre interface e API, como `Óculos de proteção` → `oculor-de-proteçao`, não foram tratadas como defeito porque havia persistência consistente.
- Palavras escrita de forma abreviada como `Ativid` ao invés de `Atividade` não foram consideradas como erro.
- Não tratativas dos inputs do tipo texto, exceto CPF, não foram considerados erros por não saber como as regras foram definidas.

## Sugestões de melhoria

- Implementar autenticação para acesso e manipulação dos registros da API.
- Restringir o acesso para cadastro e visualização de funcionário na aplicação Web.
- Validar o schema dos payloads recebidos pela API antes de persistir os dados.
- Inserir tratativas de erro e seus respectivos status Code.
- Garantir que os métodos `PUT` e `PATCH` respeitem corretamente o comportamento esperado de atualização completa e parcial.
- Aplicar validações de negócio também no backend, como campos obrigatórios, não apenas na interface Web.
- Garantir que inputs não aceitem textos muito longos e tags, porque, segundo o [OWASP](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html), são vulnerabilidades para ataques do tipo Cross-Site Scripting (XSS).
- Criar validações de unicidade e consistência para CPF.
- Garantir a persistência correta de todas as opções dos campos Cargo, Atividade e EPI.
- Tratar registros inválidos de forma resiliente na interface, evitando que um único dado inconsistente impeça a renderização da aplicação.
- Implementar data de admissão e data de demissão para histórico de registro.
- Escolher uma sequência de id mais longa, porque apesar do id de 4 dígitos alfanuméricos ter uma quantidade de possibilidades na casa do milhão, ao atingir ~1500 registros existe 50% de chance de repetir um id já utilizado, segundo o [paradoxo do aniversário](https://www.linkedin.com/pulse/o-paradoxo-do-aniversário-e-segurança-das-chaves-de-amorim-diinf/).
