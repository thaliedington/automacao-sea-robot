*** Variables ***
${BTN_VER_APENAS_ATIVOS}    xpath=//button[contains(., "Ver apenas ativos")]
${CONTADOR_ATIVOS}          xpath=//span[starts-with(normalize-space(.), "Ativos ")]
${CARDS_FUNCIONARIOS}       xpath=//div[contains(@class,"c-bXqUbA")]
${CPF_FUNCIONARIO_01}       xpath=(//div[contains(@class,"c-bXqUbA")])[1]//div[contains(@class,"c-iYbcAK")][1]

# Campos do Formulario
${SWITCH_STATUS}            xpath=//button[@role="switch"]
${CAMPO_NOME}               xpath=//input[@name="name"]
${CAMPO_CPF}                xpath=//input[@name="cpf"]
${CAMPO_RG}                 xpath=//input[@name="rg"]
${CAMPO_DATA_NASCIMENTO}    xpath=//input[@name="birthDay"]
${CAMPO_CA_NUMBER}          xpath=//input[@name="caNumber"]
&{CAMPOS_OBRIGATORIOS}
...    Nome=${CAMPO_NOME}
...    CPF=${CAMPO_CPF}
...    Data de nascimento=${CAMPO_DATA_NASCIMENTO}
...    RG=${CAMPO_RG}
...    Numero do CA=${CAMPO_CA_NUMBER}
${NOME_FUNCIONARIO}         Teste Automacao
${CPF_FUNCIONARIO}          12345678910
${RG_FUNCIONARIO}           1234567
${DATA_NASCIMENTO}          2000-01-10
${CAMPO_CARGO}              xpath=//label[@for="role"]/following::div[contains(@class,"ant-select")][1]
${OPCAO_CARGO}              xpath=//div[contains(@class,"ant-select-item-option-content") and normalize-space(.)="%s"]
${CAMPO_ATIVIDADE}          xpath=//*[contains(normalize-space(.), "Selecione a atividade")]/following::div[contains(@class,"ant-select")][1]
#${LISTA_ATIVIDADE}         xpath=//div[contains(@class,"ant-select-item-option") and @title="${atividade}"]
${CAMPO_EPI}                xpath=//div[contains(@class,"epiSelect")]
&{EPIS_API}
...    Capacete de segurança=capacete-de-segurança
...    Luvas descartáveis=luvas-descartaveis
...    Óculos de proteção=oculor-de-proteçao
...    Calçado de Segurança=calçado-de-segurança
...    Protetor auditivo=protetor-auditivo
${CA_NUMBER}                123456
${CHECKBOX_NAO_USA_EPI}     xpath=//label[contains(., "O trabalhador não usa EPI")]//input[@type="checkbox"]
${BTN_ADD_EPI}              css=span.addEPI
${BTN_ADD_ATIVIDADE}        xpath=//button[normalize-space(.)="Adicionar outra atividade"]
${LINHAS_EPI}               xpath=//label[@for="epi"]
${LINHAS_ATIVIDADE}         xpath=//label[@for="activity"]
${CAMPO_ARQUIVO}            xpath=//input[@type="file"]
${ARQUIVO_ASO}              ${EXECDIR}/resources/files/girl-icon2.jpg
${ARQUIVO_SEM_EXTENSAO}     ${EXECDIR}/resources/files/arquivo_sem_extensao
${ARQUIVO_EXECUTAVEL}       ${EXECDIR}/resources/files/script.exe
${TEXTO_APRESENTACAO}       css=span.descriptionSpan
${SWITCH_ETAPA}             xpath=//div[span[contains(., "A etapa está concluída?")]]/button[@role="switch"]
${STATUS_PRIMEIRO_ITEM}     xpath=(//div[contains(@class,"c-gOzrUz")][p[contains(., "ITEM 1")]])[1]/p[contains(., "CONCLUIDO")]
${BTN_PROXIMO_PASSO}        xpath=//button[contains(., "Próximo passo")]