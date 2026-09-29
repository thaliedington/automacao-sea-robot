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

