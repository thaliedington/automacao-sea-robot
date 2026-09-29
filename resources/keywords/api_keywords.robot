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

#Keywords do CT-020
E Tenho Um Funcionario Valido Para Teste
    ${cpf_formatado}=    Cpf
    ${cpf}=    Remove String    ${cpf_formatado}    .    -

    ${employee}=    Create Dictionary
    ...    isActive=${False}
    ...    name=Teste API
    ...    gender=masculino
    ...    cpf=${cpf}
    ...    birthDay=2002-02-11
    ...    rg=3651891
    ...    role=Cargo 02
    ...    usesEpi=${False}
    ...    activity=Ativid 02
    ...    caNumber=12345

    ${state}=      Create Dictionary    employee=${employee}
    ${payload}=    Create Dictionary    state=${state}

    Set Test Variable    ${FUNCIONARIO_ESPERADO}    ${employee}
    Set Test Variable    ${PAYLOAD_POST}    ${payload}

Quando Cadastro O Funcionario Pelo POST
    ${response}=    POST
    ...    ${ENDPOINT_FUNCIONARIOS}
    ...    json=${PAYLOAD_POST}
    ...    expected_status=any

    Set Test Variable    ${RESPOSTA_POST}    ${response}

    IF    ${response.status_code} == 201
        ${registro}=    Set Variable    ${response.json()}
        ${id}=    Get From Dictionary    ${registro}    id
        Set Test Variable    ${ID_REGISTRO_CRIADO}    ${id}
    END

Entao O POST Deve Retornar 201 E Um ID
    Status Should Be    201    ${RESPOSTA_POST}
    Should Not Be Empty    ${ID_REGISTRO_CRIADO}

E O GET Deve Refletir Os Dados Enviados
    ${registro}=    Buscar Registro De Teste No GET

    ${state}=       Get From Dictionary    ${registro}    state
    ${employee}=    Get From Dictionary    ${state}       employee

    Dictionary Should Contain Sub Dictionary
    ...    ${employee}
    ...    ${FUNCIONARIO_ESPERADO}

Quando Atualizo O Funcionario Pelo PUT
    Set To Dictionary
    ...    ${FUNCIONARIO_ESPERADO}
    ...    name=Teste API Atualizado

    ${state}=      Create Dictionary    employee=${FUNCIONARIO_ESPERADO}
    ${payload}=    Create Dictionary    state=${state}

    ${response}=    PUT
    ...    ${ENDPOINT_FUNCIONARIOS}/${ID_REGISTRO_CRIADO}
    ...    json=${payload}
    ...    expected_status=any

    Set Test Variable    ${RESPOSTA_PUT}    ${response}

Entao O PUT Deve Retornar Sucesso
    Status Should Be    200    ${RESPOSTA_PUT}

Quando Excluo O Funcionario Pelo DELETE
    ${response}=    DELETE    ${ENDPOINT_FUNCIONARIOS}/${ID_REGISTRO_CRIADO}
    ...    expected_status=any

    Set Test Variable    ${RESPOSTA_DELETE}    ${response}

Entao O DELETE Deve Retornar Sucesso
    Status Should Be    200    ${RESPOSTA_DELETE}

E O GET Nao Deve Retornar O Funcionario Excluido
    ${registro}=    Buscar Registro De Teste No GET

    Should Be Empty    ${registro}

    Set Test Variable    ${ID_REGISTRO_CRIADO}    ${EMPTY}

Buscar Registro De Teste No GET
    ${response}=    GET
    ...    ${ENDPOINT_FUNCIONARIOS}
    ...    expected_status=any

    ${registros}=    Set Variable    ${response.json()}

    FOR    ${registro}    IN    @{registros}
        ${id}=    Get From Dictionary    ${registro}    id

        IF    '${id}' == '${ID_REGISTRO_CRIADO}'
            RETURN    ${registro}
        END
    END

    RETURN    ${EMPTY}
