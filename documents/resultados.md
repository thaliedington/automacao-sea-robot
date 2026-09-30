# Resultados dos testes

Este documento registra o resultado de cada cenário do Plano de Testes. Informa a forma de execução, o resultado obtido e, quando aplicável, o defeito identificado.  

> **Legenda**
>
> - **CT:** identificador do cenário em `plano_de_testes.md`.
> - **Resultado:** **Passou** ou **Falhou**.
> - **Execução:** **Automatizada** ou **Manual**, quando for Automatizada verá o número do CA.
> - **CA:** identificador do cenário Robot, quando houver.
> - **Bug:** identificador do defeito em `relatorio_de_defeitos.md`, quando houver; caso contrário, `—`.
> - **Observações:** evidência, motivo da inconclusão ou detalhes de uma falha parcial.

| Cenário de teste | Resultado | Automação | Bug |
|---|---|---|---|
| [CT-001] Validar Botão Ativo/Inativo | Passou | CA-004 | - |
| [CT-002] Tentar cadastrar funcionário sem preencher campos obrigatórios | Passou | CA-005 a CA-009 | - |
| [CT-003] Cadastrar funcionário com dados válidos | Passou | CA-017 | - |
| [CT-004] Filtrar funcionários ativos | Passou | CA-021 | - |
| [CT-005] Limpar filtro de funcionários ativos | Passou | CA-022 | - |
| [CT-006] Informar somente espaços em campo obrigatório | Falhou | Manual | BUG-011 |
| [CT-007] Impedir cadastro com CPF já existente | Falhou | Manual | BUG-010 |
| [CT-008] Informar CPF com quantidade de dígitos inferior ao esperado | Passou | CA-010 | - |
| [CT-009] Informar CPF com 12 dígitos | Passou | CA-012 | - |
| [CT-010] Informar uma data de nascimento futura | Falhou | Manual | BUG-020 |
| [CT-011] Validar persistência dos cargos | Falhou | CA-014 | BUG-014 |
| [CT-012] Cadastrar trabalhador sem EPI | Falhou | Manual | BUG-013 |
| [CT-013] Validar persistência das atividades | Falhou | CA-016 | BUG-015 |
| [CT-014] Validar persistência dos EPIs | Falhou | CA-017 | BUG-016 |
| [CT-015] Permitir rolagem na listagem quando houver muitos funcionários | Falhou | Manual | BUG-021 | 
| [CT-016] Explorar números e caracteres especiais no Nome | Passou | Manual | - |
| [CT-017] Tratar marcação HTML informada no Nome | Passou | Manual | - |
| [CT-018] Colar texto longo no Nome |  Passou | Manual | - |
| [CT-019] Informar somente letras no CPF | Falhou | Manual | BUG-008 |
| [CT-020] Informar data inexistente em ano não bissexto | Passou | CA-013 | - |
| [CT-021] Explorar letras e traços no RG | Passou | Manual | | 
| [CT-022] Alternar a opção “O trabalhador não usa EPI” | Passou | CA-015 | - | 
| [CT-023] Anexar Atestado de Saude Ocupacional Valido | Passou | CA-019 | - |
| [CT-024] Validar comportamento de arquivo ASO de 50 MB | Passou | Manual | - |
| [CT-025] Selecionar arquivo ASO vazio | Passou | Manual | - |
| [CT-026] Substituir o ASO antes de salvar | Passou | CA-020 | - |
| [CT-027] Remover o ASO antes de salvar | Falhou | Manual | BUG-022 |
| [CT-028] Marcar a primeira etapa como concluída | Passou | CA-023 | - |
| [CT-029] Impedir consulta de dados pessoais sem autenticação | Falhou | Manual | BUG-006 |
| [CT-030] Impedir alterações na sem autenticação | Falhou | Manual | BUG-006 |
| [CT-031] Consultar a lista de funcionários por GET | Passou | CA-001 | - |
| [CT-032] Consultar os cabeçalhos por HEAD |  Passou | CA-002 | - |
| [CT-033] Criar funcionário com payload válido POST | Passou | CA-003 | - |
| [CT-034] Rejeitar POST sem corpo | Falhou | Manual | BUG-002 |
| [CT-035] Rejeitar POST com estrutura inválida | Falhou | Manual | BUG-002 |
| [CT-036] Substituir funcionário por PUT válido | Passou | CA-003 | - |
| [CT-037] Rejeitar PUT com estrutura inválida | Falhou | Manual | BUG-003 |
| [CT-038] Preservar os demais campos no PATCH | Falhou | Manual | BUG-004 |
| [CT-039] Excluir funcionário por DELETE | Passou | CA-003 | - |
