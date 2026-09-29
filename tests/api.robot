*** Settings ***
Resource    ../resources/keywords/api_keywords.robot

Test Teardown    Limpar Registro Criado Indevidamente


*** Test Cases ***
CT-019 - Validar Formato Dos Registros No GET
    Dado Que Tenho O Endpoint De Funcionarios
    Quando Consulto A Lista De Funcionarios
    Entao O Status Da Resposta Deve Ser 200
    E O Primeiro Registro Deve Seguir O Formato Esperado

