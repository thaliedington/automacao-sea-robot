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

#Keywords do CT-005
Quando Informo Um CPF Com 11 Digitos
    ${CPF_FUNCIONARIO}=    Cpf
    Set Test Variable    ${CPF_FUNCIONARIO}

    ${CPF_API}=    Remove String    ${CPF_FUNCIONARIO}    .    -
    Set Test Variable    ${CPF_API}

    Input Text    ${CAMPO_CPF}    ${CPF_API}

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