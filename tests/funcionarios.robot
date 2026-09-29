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

