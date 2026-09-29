*** Settings ***
Resource    ../resources/keywords/funcionarios_keywords.robot

Test Setup       Abrir Aplicacao
Test Teardown    Finalizar Teste
#Test Tags    robot:recursive-continue-on-failure


*** Test Cases ***
CT-001 - Validar Botao Ativo Inativo
    Dado Que Estou No Formulario De Cadastro De Funcionario
    E O Status Inicial Esta Inativo
    Quando Altero O Status Para "Ativo"
    Entao O Status Deve Estar Ativo
    Quando Altero O Status Para "Inativo"
    Entao O Status Deve Estar Inativo

CT-002 - Validar Obrigatoriedade Do Campo Nome
    Dado Que Estou No Formulario De Cadastro De Funcionario  
    E Nenhum Campo Obrigatorio Foi Preenchido  
    Quando Clico Em "Salvar"  
    Entao O Cadastro Nao Pode Ser Concluido  
    E O Campo "Nome" Deve Exibir Mensagem De Obrigatoriedade

CT-003 - Validar Obrigatoriedade Do Campo CPF Apos Preencher Nome 
    Dado Que Estou No Formulario De Cadastro De Funcionario  
    E Preencho O Campo "Nome" Com Dado Valido 
    Quando Clico Em "Salvar"  
    Entao O Cadastro Nao Pode Ser Concluido  
    E O Campo "CPF" Deve Exibir Mensagem De Obrigatoriedade

CT-004 - Informar CPF Com 10 digitos
    Dado Que Estou No Formulario De Cadastro De Funcionario
    E Preencho O Campo "Nome" Com Dado Valido 
    Quando Informo Um CPF Com 10 Digitos
    E Clico Em "Salvar"
    Entao O Campo CPF Deve Informar Que O Valor Esta Incompleto

CT-005 - Informar CPF Com 11 digitos
    Dado Que Estou No Formulario De Cadastro De Funcionario
    E Preencho O Campo "Nome" Com Dado Valido 
    Quando Informo Um CPF Com 11 Digitos
    E Clico Em "Salvar"
    Entao O Campo Deve Aceitar O Valor Informado

CT-006 - Informar CPF Com 12 digitos
    Dado Que Estou No Formulario De Cadastro De Funcionario
    E Preencho O Campo "Nome" Com Dado Valido 
    Quando Informo Um CPF Com 12 Digitos
    Entao O Campo CPF Deve Permitir Apenas 11 Digitos

CT-007 - Validar Obrigatoriedade Da Data De Nascimento Apos Preencher Nome E CPF  
    Dado Que Estou No Formulario De Cadastro De Funcionario  
    E Preencho O Campo "Nome" Com Dado Valido  
    E Preencho O Campo "CPF" Com Dado Valido  
    Quando Clico Em "Salvar"  
    Entao O Cadastro Nao Pode Ser Concluido  
    E O Campo "Data de nascimento" Deve Exibir Mensagem De Obrigatoriedade

CT-008 - Validar Obrigatoriedade Do Campo RG Apos Preencher Os Campos Anteriores  
    Dado Que Estou No Formulario De Cadastro De Funcionario  
    E Preencho O Campo "Nome" Com Dado Valido  
    E Preencho O Campo "CPF" Com Dado Valido  
    E Preencho O Campo "Data de nascimento" Com Dado Valido  
    Quando Clico Em "Salvar"  
    Entao O Cadastro Nao Pode Ser Concluido  
    E O Campo "RG" Deve Exibir Mensagem De Obrigatoriedade

CT-009 - Validar Persistencia Das Opcoes Do Campo Cargo
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

CT-010 - Cadastrar Trabalhador Sem EPI
    Dado Que Estou No Formulario De Cadastro De Funcionario
    E Preencho Apenas Os Campos Obrigatorios Com Dados Validos
    E Seleciono A Atividade "Ativid 05"
    E Seleciono O EPI "Protetor auditivo"
    E Informo O Numero Do CA "CA 5678"
    Quando Informo Que O Trabalhador Nao Usa EPI
    E Clico Em "Salvar"
    Entao O Cadastro Deve Ser Realizado Com Sucesso
    #Entao Os Dados De EPI Nao Devem Constar No Registro Da API

CT-011 - Validar Persistencia Das Atividades
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

CT-012 - Validar Persistencia Dos EPIs
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

CT-013 - Validar Obrigatoriedade Do Numero Do CA Apos Preencher Os Campos Anteriores  
    Dado Que Estou No Formulario De Cadastro De Funcionario  
    E Preencho O Campo "Nome" Com Dado Valido  
    E Preencho O Campo "CPF" Com Dado Valido  
    E Preencho O Campo "Data de nascimento" Com Dado Valido  
    E Preencho O Campo "RG" Com Dado Valido  
    Quando Clico Em "Salvar"  
    Entao O Cadastro Nao Pode Ser Concluido  
    E O Campo "Numero do CA" Deve Exibir Mensagem De Obrigatoriedade

CT-014 - Cadastrar Funcionario Com Dados Validos
    Dado Que Estou No Formulario De Cadastro De Funcionario
    E Preencho Apenas Os Campos Obrigatorios Com Dados Validos
    E Altero O Status Para "Ativo"
    E Seleciono O Sexo "feminino"
    Quando Clico Em "Salvar"
    Entao O Cadastro Deve Ser Realizado Com Sucesso

CT-015 - Anexar Atestado de Saude Ocupacional Valido
    Dado Que Estou No Formulario De Cadastro De Funcionario
    E Preencho Apenas Os Campos Obrigatorios Com Dados Validos    ASO Comum
    E Seleciono O Sexo "feminino"
    Quando Anexo Um Arquivo Valido No Campo ASO
    E O Nome Do Arquivo Deve Ser Exibido
    E Clico Em "Salvar"
    Entao O Cadastro Deve Ser Realizado Com Sucesso

CT-016 - Filtrar Funcionarios Ativos
    Dado Que Estou Na Pagina Inicial
    E Existem Funcionarios Ativos E Inativos Cadastrados
    Quando Clico Em "Ver apenas ativos"
    Entao Devem Ser Exibidos Somente Funcionarios Com Status Ativo
    E Funcionarios Inativos Nao Devem Ser Exibidos

CT-017 - Limpar Filtro De Funcionarios Ativos
    Dado Que Estou Na Pagina Inicial
    E O Filtro "Ver Apenas Ativos" Esta Selecionado
    Quando Clico Em "Limpar filtros"
    Entao A Selecao Do Filtro "Ver apenas ativos" Deve Ser Removida
    E A Listagem Deve Exibir Todos Os Cadastros

