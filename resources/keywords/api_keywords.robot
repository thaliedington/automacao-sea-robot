*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     FakerLibrary    locale=pt_BR
Library     String

Resource    ../pages/api_page.robot


*** Keywords ***
Dado Que Tenho O Endpoint De Funcionarios
    Set Test Variable    ${ID_REGISTRO_CRIADO}    ${EMPTY}

Limpar Registro Criado Indevidamente
    IF    '${ID_REGISTRO_CRIADO}' != ''
        DELETE
        ...    ${ENDPOINT_FUNCIONARIOS}/${ID_REGISTRO_CRIADO}
        ...    expected_status=any
    END

#Keywords do CT-019
Quando Consulto A Lista De Funcionarios
    ${response}=    GET    ${ENDPOINT_FUNCIONARIOS}
    ...    expected_status=any

    Set Test Variable    ${RESPOSTA_GET}    ${response}

Entao O Status Da Resposta Deve Ser 200
    Status Should Be    200    ${RESPOSTA_GET}

E O Primeiro Registro Deve Seguir O Formato Esperado
    ${registros}=    Set Variable    ${RESPOSTA_GET.json()}
    ${registro}=     Get From List    ${registros}    0

    ${state}=       Get From Dictionary    ${registro}    state
    ${employee}=    Get From Dictionary    ${state}       employee

    FOR    ${campo}    IN    @{CAMPOS_FUNCIONARIO}
        Dictionary Should Contain Key    ${employee}    ${campo}
    END
