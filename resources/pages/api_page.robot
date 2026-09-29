*** Settings ***
Resource    ../variables/variables.robot


*** Variables ***
${ENDPOINT_FUNCIONARIOS}    ${URL}employees
${ID_REGISTRO_CRIADO}       ${EMPTY}

@{CAMPOS_FUNCIONARIO}
...    isActive
...    name
...    gender
...    cpf
...    birthDay
...    rg
...    role
...    usesEpi
...    activity
...    caNumber