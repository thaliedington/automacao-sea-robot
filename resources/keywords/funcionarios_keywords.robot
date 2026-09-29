*** Settings ***
Library    SeleniumLibrary
Library    FakerLibrary    locale=pt_BR
Library    String
Library    Collections
Library    RequestsLibrary

Resource    ../variables/variables.robot
Resource    ../pages/funcionarios_page.robot


*** Keywords ***
Abrir Aplicacao
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}

Fechar Aplicacao
    Close Browser

Dado Que Estou Na Pagina Inicial
    Wait Until Element Is Visible    ${BTN_VER_APENAS_ATIVOS}
    Element Should Be Visible        ${BTN_VER_APENAS_ATIVOS}

Dado Que Estou No Formulario De Cadastro De Funcionario
    ${total_ativos}    ${total_cadastros}=    Obter Quantidades Do Contador
    Set Test Variable    ${TOTAL_CADASTROS_ANTES}    ${total_cadastros}

    Quando Clico Em "+ Adicionar Funcionário"

    Wait Until Element Is Visible    ${CAMPO_NOME}

#Keywords do CT-001
 E O Status Inicial Esta Inativo
    ${estado}=    Get Element Attribute    ${SWITCH_STATUS}    aria-checked
    Should Be Equal    ${estado}    false

Quando Altero O Status Para "${status}"
    ${estado_atual}=    Get Element Attribute    ${SWITCH_STATUS}    aria-checked

    IF    '${status}' == 'Ativo' and '${estado_atual}' == 'false'
        Click Element    ${SWITCH_STATUS}
    ELSE IF    '${status}' == 'Inativo' and '${estado_atual}' == 'true'
        Click Element    ${SWITCH_STATUS}
    END

Entao O Status Deve Estar Ativo
    ${estado}=    Get Element Attribute    ${SWITCH_STATUS}    aria-checked
    Should Be Equal    ${estado}    true


Entao O Status Deve Estar Inativo
    ${estado}=    Get Element Attribute    ${SWITCH_STATUS}    aria-checked
    Should Be Equal    ${estado}    false

#Keywords do CT-002
E Nenhum Campo Obrigatorio Foi Preenchido
    ${nome}=    Get Value    ${CAMPO_NOME}
    Should Be Empty    ${nome}

    ${cpf}=    Get Value    ${CAMPO_CPF}
    Should Be Empty    ${cpf}

    ${rg}=    Get Value    ${CAMPO_RG}
    Should Be Empty    ${rg}

    ${data_nascimento}=    Get Value    ${CAMPO_DATA_NASCIMENTO}
    Should Be Empty    ${data_nascimento}

    ${ca_number}=    Get Value    ${CAMPO_CA_NUMBER}
    Should Be Empty    ${ca_number}

Quando Clico Em "${opcao}"
    ${botao}=    Set Variable    xpath=//button[contains(., "${opcao}")]
    Wait Until Element Is Visible    ${botao}
    Click Element    ${botao}

Entao O Cadastro Nao Pode Ser Concluido
    Element Should Be Visible    ${CAMPO_NOME}

E O Campo "${campo}" Deve Exibir Mensagem De Obrigatoriedade
    ${locator}=    Get From Dictionary    ${CAMPOS_OBRIGATORIOS}    ${campo}
    ${elemento}=    Get WebElement    ${locator}

    ${campo_invalido}=    Execute Javascript
    ...    return arguments[0].validity.valueMissing;
    ...    ARGUMENTS    ${elemento}

    Should Be Equal    ${campo_invalido}    ${True}

    ${mensagem}=    Execute Javascript
    ...    return arguments[0].validationMessage;
    ...    ARGUMENTS    ${elemento}

    Should Not Be Empty    ${mensagem}

#Keywords do CT-003
E Preencho O Campo "${campo}" Com Dado Valido
    IF    '${campo}' == 'Nome'
        Input Text    ${CAMPO_NOME}    ${NOME_FUNCIONARIO}

    ELSE IF    '${campo}' == 'CPF'
        Quando Informo Um CPF Com 11 Digitos

    ELSE IF    '${campo}' == 'Data de nascimento'
        Input Text    ${CAMPO_DATA_NASCIMENTO}    ${DATA_NASCIMENTO}

    ELSE IF    '${campo}' == 'RG'
        Input Text    ${CAMPO_RG}    ${RG_FUNCIONARIO}

    END

#Keywords do CT-004
Quando Informo Um CPF Com 10 Digitos
    Input Text    ${CAMPO_CPF}    1234567890

Entao O Campo CPF Deve Informar Que O Valor Esta Incompleto
    Element Should Be Visible    ${CAMPO_CPF}

    ${mensagem}=    Get Element Attribute    ${CAMPO_CPF}    validationMessage

    Should Not Be Empty    ${mensagem}
    ...    Ocorreu um erro: O campo CPF aceitou um valor contendo apenas 10 dígitos.

    Log    Mensagem apresentada pelo campo CPF: ${mensagem}

    Capture Page Screenshot    CT-004_-_Informar_CPF_com_10_digitos.png

#Keywords do CT-005
Quando Informo Um CPF Com 11 Digitos
    ${CPF_FUNCIONARIO}=    Cpf
    Set Test Variable    ${CPF_FUNCIONARIO}

    ${CPF_API}=    Remove String    ${CPF_FUNCIONARIO}    .    -
    Set Test Variable    ${CPF_API}

    Input Text    ${CAMPO_CPF}    ${CPF_API}

Entao O Campo Deve Aceitar O Valor Informado
    ${elemento}=    Get WebElement    ${CAMPO_CPF}

    ${mensagem}=    Execute Javascript
    ...    return arguments[0].validationMessage;
    ...    ARGUMENTS    ${elemento}

    Should Be Empty    ${mensagem}

    Capture Page Screenshot    CT-005_-_Informar_CPF_com_11_digitos.png

#Keywords do CT-006
Quando Informo Um CPF Com 12 Digitos
    Input Text    ${CAMPO_CPF}    123456789012

Entao O Campo CPF Deve Permitir Apenas 11 Digitos
    ${cpf_campo}=    Get Value    ${CAMPO_CPF}

    ${cpf_sem_mascara}=    Remove String    ${cpf_campo}    .    -

    ${quantidade_digitos}=    Get Length    ${cpf_sem_mascara}

    Should Be Equal As Integers    ${quantidade_digitos}    11
    ...    Ocorreu um erro: O campo CPF permitiu ${quantidade_digitos} dígitos, mas deveria permitir no máximo 11.

    Capture Page Screenshot    CT-006_-_Informar_CPF_com_12_digitos.png

#Keywords do CT-009
Quando Seleciono O ${cargo}
    Wait Until Element Is Visible    ${CAMPO_CARGO}
    Click Element    ${CAMPO_CARGO}

    Wait Until Element Is Visible    xpath=//div[contains(@class,"ant-select-item-option-content") and normalize-space(.)="${cargo}"]
    Click Element    xpath=//div[contains(@class,"ant-select-item-option-content") and normalize-space(.)="${cargo}"]

E O ${cargo} Deve Constar no Registro na API
    ${response}=    GET    ${URL}employees
    Status Should Be    200    ${response}

    ${registros}=    Set Variable    ${response.json()}

    FOR    ${registro}    IN    @{registros}
        ${state}=       Get From Dictionary    ${registro}    state
        ${employee}=    Get From Dictionary    ${state}       employee
        ${cpf}=         Get From Dictionary    ${employee}    cpf

        IF    '${cpf}' == '${CPF_API}'
            ${cargo_api}=    Get From Dictionary    ${employee}    role
            
            Log    CPF validado: ${CPF_API}
            Log    Cargo esperado: ${cargo}
            Log    Cargo retornado pela API: ${cargo_api}

            Should Be Equal    ${cargo_api}    ${cargo}
            ...    O cargo esperado era '${cargo}', mas a API retornou '${cargo_api}'.
            
            BREAK
        ELSE
            
            Log    CPF cadastrado ainda não foi encontrado. Continuando a busca.
        END
    END

#Keywords do CT-010
E Seleciono A Atividade "${atividade}"
    Quando Seleciono A Atividade "${atividade}"

E Seleciono O EPI "${epi}"
    Quando Seleciono O EPI "${epi}"

E Informo O Numero Do CA "${ca}"
    Input Text    ${CAMPO_CA_NUMBER}    ${ca}

Quando Informo Que O Trabalhador Nao Usa EPI
    Click Element    ${CHECKBOX_NAO_USA_EPI}
    Checkbox Should Be Selected    ${CHECKBOX_NAO_USA_EPI}

E Clico Em "Salvar"
    Quando Clico Em "Salvar"

Entao Os Dados De EPI Nao Devem Constar No Registro Da API
    ${response}=    GET    ${URL}employees
    Status Should Be    200    ${response}

    ${registros}=    Set Variable    ${response.json()}

    FOR    ${registro}    IN    @{registros}
        ${state}=       Get From Dictionary    ${registro}    state
        ${employee}=    Get From Dictionary    ${state}       employee
        ${cpf}=         Get From Dictionary    ${employee}    cpf

        IF    '${cpf}' == '${CPF_API}'
            Log    CPF validado: ${CPF_API}
            Log    Dados retornados pela API: ${employee}

            ${usa_epi}=    Get From Dictionary    ${employee}    usesEpi

            Should Be Equal    ${usa_epi}    ${False}

            Dictionary Should Not Contain Key    ${employee}    activity
            Dictionary Should Not Contain Key    ${employee}    epi
            Dictionary Should Not Contain Key    ${employee}    caNumber

            RETURN
        ELSE
            
            Log    CPF cadastrado ainda não foi encontrado. Continuando a busca.
        END
    END

#Keywords do CT-011
Quando Seleciono A Atividade "${atividade}"
    Wait Until Element Is Visible    ${CAMPO_ATIVIDADE}
    Click Element    ${CAMPO_ATIVIDADE}

    ${LISTA_ATIVIDADE}=    Set Variable
    ...    xpath=//div[contains(@class,"ant-select-item-option") and @title="${atividade}"]

    Wait Until Element Is Visible    ${LISTA_ATIVIDADE}
    Click Element    ${LISTA_ATIVIDADE}

E A Atividade "${atividade}" Deve Constar No Registro Na API
    ${response}=    GET    ${URL}employees
    Status Should Be    200    ${response}

    ${registros}=    Set Variable    ${response.json()}
    
    FOR    ${registro}    IN    @{registros}
        ${state}=       Get From Dictionary    ${registro}    state
        ${employee}=    Get From Dictionary    ${state}       employee
        ${cpf}=         Get From Dictionary    ${employee}    cpf

        IF    '${cpf}' == '${CPF_API}'
            ${atividade_api}=    Get From Dictionary    ${employee}    activity

            Log    CPF validado: ${CPF_API}
            Log    Atividade esperada: ${atividade}
            Log    Atividade retornada pela API: ${atividade_api}

            Should Be Equal    ${atividade_api}    ${atividade}
            ...    A atividade esperada era '${atividade}', mas o registro na API retornou '${atividade_api}'.

            BREAK
        END
    END

#Keywords do CT-012
Quando Seleciono O EPI "${epi}"
    Wait Until Element Is Visible    ${CAMPO_EPI}
    Click Element    ${CAMPO_EPI}

    ${LISTA_EPI}=    Set Variable
    ...    xpath=//div[contains(@class,"ant-select-item-option") and @title="${epi}"]

    Wait Until Element Is Visible    ${LISTA_EPI}
    Click Element    ${LISTA_EPI}

E O EPI "${epi}" Deve Constar No Registro Na API
    ${response}=    GET    ${URL}employees
    Status Should Be    200    ${response}

    ${registros}=    Set Variable    ${response.json()}

    FOR    ${registro}    IN    @{registros}
        ${state}=       Get From Dictionary    ${registro}    state
        ${employee}=    Get From Dictionary    ${state}       employee
        ${cpf}=         Get From Dictionary    ${employee}    cpf

        IF    '${cpf}' == '${CPF_API}'
            ${epi_api}=         Get From Dictionary    ${employee}    epi
            ${epi_esperado}=    Get From Dictionary    ${EPIS_API}    ${epi}

            Log    CPF validado: ${CPF_API}
            Log    EPI selecionado na Web: ${epi}
            Log    EPI esperado na API: ${epi_esperado}
            Log    EPI retornado pela API: ${epi_api}

            Should Be Equal    ${epi_api}    ${epi_esperado}
            ...    O EPI esperado era '${epi_esperado}', mas a API retornou '${epi_api}'.

            BREAK
        END
    END

#Keywords do CT-014
E Preencho Apenas Os Campos Obrigatorios Com Dados Validos
    [Arguments]    ${nome}=${NOME_FUNCIONARIO}

    Input Text    ${CAMPO_NOME}             ${nome}
    Quando Informo Um CPF Com 11 Digitos
    Input Text    ${CAMPO_RG}               ${RG_FUNCIONARIO}
    Input Text    ${CAMPO_DATA_NASCIMENTO}  ${DATA_NASCIMENTO}
    Input Text    ${CAMPO_CA_NUMBER}        ${CA_NUMBER}

E Altero O Status Para "${status}"
    Quando Altero O Status Para "${status}"

E Seleciono O Sexo "${sexo}"
    Click Element    xpath=//input[@type="radio" and @value="${sexo}"]/ancestor::label[1]

Entao O Cadastro Deve Ser Realizado Com Sucesso
    Wait Until Element Is Not Visible    ${CAMPO_NOME}
    Wait Until Element Is Visible        ${BTN_VER_APENAS_ATIVOS}

#Keywords do CT-015
Quando Anexo Um Arquivo Valido No Campo ASO
    Choose File    ${CAMPO_ARQUIVO}    ${ARQUIVO_ASO}

E O Nome Do Arquivo Deve Ser Exibido
    Page Should Contain    girl-icon2.jpg

#Keywords do CT-016
E Existem Funcionarios Ativos E Inativos Cadastrados
    ${total_ativos}    ${total_cadastros}=    Obter Quantidades Do Contador

    ${total_inativos}=    Evaluate    ${total_cadastros} - ${total_ativos}

    Set Test Variable    ${TOTAL_ATIVOS}       ${total_ativos}
    Set Test Variable    ${TOTAL_INATIVOS}     ${total_inativos}
    Set Test Variable    ${TOTAL_CADASTROS}    ${total_cadastros}

Entao Devem Ser Exibidos Somente Funcionarios Com Status Ativo
    ${total_cards_exibidos}=    Get Element Count    ${CARDS_FUNCIONARIOS}

    Should Be Equal As Integers    ${total_cards_exibidos}    ${TOTAL_ATIVOS}
    ...    Ocorreu um erro: Foram exibidos ${total_cards_exibidos} funcionários, mas o total de funcionários ativos é ${TOTAL_ATIVOS}.

E Funcionarios Inativos Nao Devem Ser Exibidos
    ${total_cards_exibidos}=    Get Element Count    ${CARDS_FUNCIONARIOS}

    ${total_inativos_ocultos}=    Evaluate    ${TOTAL_CADASTROS} - ${total_cards_exibidos}

    Should Be Equal As Integers    ${total_inativos_ocultos}    ${TOTAL_INATIVOS}
    ...    Ocorreu um erro: Foram ocultados ${total_inativos_ocultos} funcionários inativos, mas o total esperado era ${TOTAL_INATIVOS}.

#Keywords do CT-017
E O Filtro "${filtro}" Esta Selecionado
    ${total_ativos}    ${total_cadastros}=    Obter Quantidades Do Contador

    Set Test Variable    ${TOTAL_ATIVOS}       ${total_ativos}
    Set Test Variable    ${TOTAL_CADASTROS}    ${total_cadastros}

    Click Element    ${BTN_VER_APENAS_ATIVOS}

    ${classe}=    Get Element Attribute    ${BTN_VER_APENAS_ATIVOS}    class

    Should Contain    ${classe}    isActive

    ${cards_filtrados}=    Get Element Count    ${CARDS_FUNCIONARIOS}

    Should Be Equal As Integers    ${cards_filtrados}    ${TOTAL_ATIVOS}

Entao A Selecao Do Filtro "${filtro}" Deve Ser Removida
    ${classe}=    Get Element Attribute    ${BTN_VER_APENAS_ATIVOS}    class

    Should Not Contain    ${classe}    isActive

E A Listagem Deve Exibir Todos Os Cadastros
    ${total_cards}=    Get Element Count    ${CARDS_FUNCIONARIOS}

    Should Be Equal As Integers    ${total_cards}    ${TOTAL_CADASTROS}

Obter Quantidades Do Contador
    Wait Until Keyword Succeeds    5s    500ms    Contador Deve Estar Carregado

    ${texto_contador}=    Get Text    ${CONTADOR_ATIVOS}

    Log To Console    Contador: ${texto_contador}

    ${quantidades}=    Evaluate
    ...    $texto_contador.replace('Ativos', '').strip().split('/')

    ${total_ativos}=       Convert To Integer    ${quantidades}[0]
    ${total_cadastros}=    Convert To Integer    ${quantidades}[1]

    RETURN    ${total_ativos}    ${total_cadastros}

Contador Deve Estar Carregado
    ${texto_contador}=    Get Text    ${CONTADOR_ATIVOS}
    Should Match Regexp    ${texto_contador}    Ativos\\s*\\d+\\s*/\\s*\\d+

#Registrar evidências no relatório
Registrar Evidencia Final
    ${nome_teste}=    Replace String    ${TEST NAME}    ${SPACE}    _
    Capture Page Screenshot    ${nome_teste}-${TEST STATUS}.png

Finalizar Teste
    Registrar Evidencia Final
    Fechar Aplicacao