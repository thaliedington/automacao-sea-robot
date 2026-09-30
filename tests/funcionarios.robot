*** Settings ***
Resource    ../resources/keywords/funcionarios_keywords.robot

Test Setup       Abrir Aplicacao
Test Teardown    Finalizar Teste
#Test Tags    robot:recursive-continue-on-failure


*** Test Cases ***
CA-004 - Validar Botao Ativo/Inativo
    [Tags]    CT-001

    Dado Que Estou No Formulario De Cadastro De Funcionario
    E O Status Inicial Esta Inativo
    Quando Altero O Status Para "Ativo"
    Entao O Status Deve Estar Ativo
    Quando Altero O Status Para "Inativo"
    Entao O Status Deve Estar Inativo

CA-005 - Validar Obrigatoriedade Do Campo Nome
    [Tags]    CT-002

    Dado Que Estou No Formulario De Cadastro De Funcionario  
    E Nenhum Campo Obrigatorio Foi Preenchido  
    Quando Clico Em "Salvar"  
    Entao O Cadastro Nao Pode Ser Concluido  
    E O Campo "Nome" Deve Exibir Mensagem De Obrigatoriedade

CA-006 - Validar Obrigatoriedade Do Campo CPF Apos Preencher Nome
    [Tags]    CT-002 

    Dado Que Estou No Formulario De Cadastro De Funcionario  
    E Preencho O Campo "Nome" Com Dado Valido 
    Quando Clico Em "Salvar"  
    Entao O Cadastro Nao Pode Ser Concluido  
    E O Campo "CPF" Deve Exibir Mensagem De Obrigatoriedade

CA-007 - Validar Obrigatoriedade Da Data De Nascimento Apos Preencher Nome E CPF
    [Tags]    CT-002  

    Dado Que Estou No Formulario De Cadastro De Funcionario  
    E Preencho O Campo "Nome" Com Dado Valido  
    E Preencho O Campo "CPF" Com Dado Valido  
    Quando Clico Em "Salvar"  
    Entao O Cadastro Nao Pode Ser Concluido  
    E O Campo "Data de nascimento" Deve Exibir Mensagem De Obrigatoriedade

CA-008 - Validar Obrigatoriedade Do Campo RG Apos Preencher Os Campos Anteriores
    [Tags]    CT-002  

    Dado Que Estou No Formulario De Cadastro De Funcionario  
    E Preencho O Campo "Nome" Com Dado Valido  
    E Preencho O Campo "CPF" Com Dado Valido  
    E Preencho O Campo "Data de nascimento" Com Dado Valido  
    Quando Clico Em "Salvar"  
    Entao O Cadastro Nao Pode Ser Concluido  
    E O Campo "RG" Deve Exibir Mensagem De Obrigatoriedade

CA-009 - Validar Obrigatoriedade Do Numero Do CA Apos Preencher Os Campos Anteriores
    [Tags]    CT-002

    Dado Que Estou No Formulario De Cadastro De Funcionario  
    E Preencho O Campo "Nome" Com Dado Valido  
    E Preencho O Campo "CPF" Com Dado Valido  
    E Preencho O Campo "Data de nascimento" Com Dado Valido  
    E Preencho O Campo "RG" Com Dado Valido  
    Quando Clico Em "Salvar"  
    Entao O Cadastro Nao Pode Ser Concluido  
    E O Campo "Numero do CA" Deve Exibir Mensagem De Obrigatoriedade

CA-010 - Informar CPF Com 10 digitos
    [Tags]    CT-008

    Dado Que Estou No Formulario De Cadastro De Funcionario
    E Preencho O Campo "Nome" Com Dado Valido 
    Quando Informo Um CPF Com 10 Digitos
    E Clico Em "Salvar"
    Entao O Campo CPF Deve Informar Que O Valor Esta Incompleto

CA-011 - Informar CPF Com 11 digitos
    [Tags]    CT-003

    Dado Que Estou No Formulario De Cadastro De Funcionario
    E Preencho O Campo "Nome" Com Dado Valido 
    Quando Informo Um CPF Com 11 Digitos
    E Clico Em "Salvar"
    Entao O Campo Deve Aceitar O Valor Informado

CA-012 - Informar CPF Com 12 digitos
    [Tags]    CT-009

    Dado Que Estou No Formulario De Cadastro De Funcionario
    E Preencho O Campo "Nome" Com Dado Valido 
    Quando Informo Um CPF Com 12 Digitos
    Entao O Campo CPF Deve Permitir Apenas 11 Digitos

CA-013 - Informar Data Inexistente Em Ano Nao Bissexto
    [Tags]    CT-020

    Dado Que Estou No Formulario De Cadastro De Funcionario
    E Preencho Apenas Os Campos Obrigatorios Com Dados Validos
    Quando Informo A Data De Nascimento "29/02/2023"
    E Clico Em "Salvar"
    Entao O Cadastro Nao Pode Ser Concluido
    E O Campo Data De Nascimento Deve Exibir Mensagem De Valor Invalido

CA-014 - Validar Persistencia Das Opcoes Do Campo Cargo
    [Tags]    CT-011

    FOR    ${cargo}    IN    Cargo 02    Cargo 03    Cargo 04    Cargo 05
    #...    Cargo 01 
        Dado Que Estou No Formulario De Cadastro De Funcionario
        E Preencho Apenas Os Campos Obrigatorios Com Dados Validos    ${cargo}
        Quando Seleciono O ${cargo}
        E Altero O Status Para "Ativo"
        E Clico Em "Salvar"
        Entao O Cadastro Deve Ser Realizado Com Sucesso
        E O ${cargo} Deve Constar no Registro na API
    END

CA-015 - Alternar A Opcao O Trabalhador Nao Usa EPI
    [Tags]    CT-022

    Dado Que Estou No Formulario De Cadastro De Funcionario
    E A Opcao Nao Usa EPI Esta Desmarcada
    E Os Campos De EPI E CA Estao Disponiveis
    Quando Marco A Opcao Nao Usa EPI
    Entao A Opcao Nao Usa EPI Deve Estar Marcada
    E Os Campos De EPI E CA Devem Ficar Indisponiveis
    Quando Desmarco A Opcao Nao Usa EPI
    Entao A Opcao Nao Usa EPI Deve Estar Desmarcada
    E Os Campos De EPI E CA Devem Voltar A Ficar Disponiveis

CA-016 - Validar Persistencia Dos EPIs
    [Tags]    CT-013

    FOR    ${epi}    IN
    ...    Luvas descartáveis
    ...    Óculos de proteção
    ...    Calçado de Segurança
    ...    Protetor auditivo
    #...    Capacete de segurança

        Dado Que Estou No Formulario De Cadastro De Funcionario
        E Preencho Apenas Os Campos Obrigatorios Com Dados Validos    ${epi}
        E Seleciono A Atividade "Ativid 04"
        Quando Seleciono O EPI "${epi}"
        E Clico Em "Salvar"
        Entao O Cadastro Deve Ser Realizado Com Sucesso
        E O EPI "${epi}" Deve Constar No Registro Na API
    END

CA-017 - Validar Persistencia Das Atividades
    [Tags]    CT-014

    FOR    ${atividade}    IN   Ativid 02    Ativid 03    Ativid 04    Ativid 05
    #    Ativid 01
        Dado Que Estou No Formulario De Cadastro De Funcionario
        E Preencho Apenas Os Campos Obrigatorios Com Dados Validos    ${atividade}
        E Altero O Status Para "Ativo"
        Quando Seleciono A Atividade "${atividade}"
        E Clico Em "Salvar"
        Entao O Cadastro Deve Ser Realizado Com Sucesso
        E A Atividade "${atividade}" Deve Constar No Registro Na API
    END

CA-018 - Cadastrar Funcionario Com Dados Validos
    [Tags]    CT-003

    Dado Que Estou No Formulario De Cadastro De Funcionario
    E Preencho Apenas Os Campos Obrigatorios Com Dados Validos
    E Altero O Status Para "Ativo"
    E Seleciono O Sexo "feminino"
    Quando Clico Em "Salvar"
    Entao O Cadastro Deve Ser Realizado Com Sucesso

CA-019 - Anexar Atestado de Saude Ocupacional Valido
    [Tags]    CT-023

    Dado Que Estou No Formulario De Cadastro De Funcionario
    E Preencho Apenas Os Campos Obrigatorios Com Dados Validos    ASO Comum
    E Seleciono O Sexo "feminino"
    Quando Seleciono O Arquivo ASO "girl-icon2.jpg"
    E O Nome Do Arquivo Deve Ser Exibido
    E Clico Em "Salvar"
    Entao O Cadastro Deve Ser Realizado Com Sucesso

CA-020 - Substituir O ASO Antes De Salvar
    [Tags]    CT-026

    Dado Que Estou No Formulario De Cadastro De Funcionario
    E Preencho Apenas Os Campos Obrigatorios Com Dados Validos    ASO Substituido
    E Seleciono O Arquivo ASO "aso-a.png"
    Quando Substituo O Arquivo ASO Por "aso-b.txt"
    Entao Somente O Arquivo ASO "aso-b.txt" Deve Estar Selecionado
    E Clico Em "Salvar"
    Entao O Cadastro Deve Ser Realizado Com Sucesso

CA-021 - Filtrar Funcionarios Ativos
    [Tags]    CT-004

    Dado Que Estou Na Pagina Inicial
    E Existem Funcionarios Ativos E Inativos Cadastrados
    Quando Clico Em "Ver apenas ativos"
    Entao Devem Ser Exibidos Somente Funcionarios Com Status Ativo
    E Funcionarios Inativos Nao Devem Ser Exibidos

CA-022 - Limpar Filtro De Funcionarios Ativos
    [Tags]    CT-005

    Dado Que Estou Na Pagina Inicial
    E O Filtro "Ver Apenas Ativos" Esta Selecionado
    Quando Clico Em "Limpar filtros"
    Entao A Selecao Do Filtro "Ver apenas ativos" Deve Ser Removida
    E A Listagem Deve Exibir Todos Os Cadastros

CA-023 - Marcar A Primeira Etapa Como Concluida
    [Tags]    CT-021

    Dado Que Estou Na Pagina Inicial
    E A Etapa Esta Marcada Como Nao
    Quando Marco A Etapa Como "Sim"
    Entao A Etapa Deve Ser Exibida Como Concluida
    Quando Marco A Etapa Como "Nao"
    Entao A Exibicao de Concluida Deve Desaparecer