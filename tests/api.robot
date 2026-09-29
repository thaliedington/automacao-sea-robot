*** Settings ***
Resource    ../resources/keywords/api_keywords.robot

Test Teardown    Limpar Registro Criado Indevidamente


*** Test Cases ***
CT-019 - Validar Formato Dos Registros No GET
    Dado Que Tenho O Endpoint De Funcionarios
    Quando Consulto A Lista De Funcionarios
    Entao O Status Da Resposta Deve Ser 200
    E O Primeiro Registro Deve Seguir O Formato Esperado

CT-020 - Validar Inclusao Alteracao E Exclusao De Funcionario Na API
    Dado Que Tenho O Endpoint De Funcionarios
    E Tenho Um Funcionario Valido Para Teste

    Quando Cadastro O Funcionario Pelo POST
    Entao O POST Deve Retornar 201 E Um ID
    E O GET Deve Refletir Os Dados Enviados

    Quando Atualizo O Funcionario Pelo PUT
    Entao O PUT Deve Retornar Sucesso
    E O GET Deve Refletir Os Dados Enviados

    Quando Excluo O Funcionario Pelo DELETE
    Entao O DELETE Deve Retornar Sucesso
    E O GET Nao Deve Retornar O Funcionario Excluido

CT-021 - Validar O Metodo HEAD
    Dado Que Tenho O Endpoint De Funcionarios
    Quando Consulto Os Cabecalhos Dos Funcionarios
    Entao O Status Da Resposta HEAD Deve Ser 200
    E A Resposta HEAD Nao Deve Conter Corpo
    E O Content Type Da Resposta HEAD Deve Ser JSON