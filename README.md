# Desafio Prático QA — Web + API

Projeto desenvolvido para um desafio técnico de **Analista de Testes Pleno (QA)**, com foco na validação de uma aplicação Web de cadastro de funcionários e de sua API REST.

Veja abaixo como ele funciona:

https://github.com/user-attachments/assets/2e0071f3-037b-4b62-96f1-52b63f78be7d

## Tecnologias utilizadas

- Robot Framework
- SeleniumLibrary
- RequestsLibrary
- FakerLibrary
- Postman
- Git
- Google Chrome

## Escopo

A automação contempla testes em duas camadas:

- **Web:** validações funcionais da interface e do fluxo de cadastro.
- **API:** validações dos principais métodos do endpoint `/employees`.

Também foram realizados testes integrando as duas camadas, comparando dados informados na interface com os valores persistidos na API.

## Estrutura do projeto

```text
automacao-sea-robot/
├── documents/
├── resources/
│   ├── keywords/
│   ├── pages/
│   ├── variables/
│   └── files/
│       └── bugs/
├── tests/
├── results/
├── requirements.txt
├── README.md
└── .gitignore
```

## Estratégia

Os testes foram escritos em formato BDD para facilitar a leitura.
A automação foi mantida intencionalmente simples, com foco em:
- legibilidade;
- reutilização de keywords;
- separação entre Web e API;
- geração dinâmica de massa de teste;
- limpeza dos registros criados durante as execuções;
- evidências por logs e screenshots.

Cenários que apresentaram defeitos conhecidos foram documentados no Relatório de Defeitos, evitando aumentar desnecessariamente a complexidade da automação apenas para contornar comportamentos incorretos da aplicação.

## Instalação
### macOS

Crie o ambiente virtual:
```bash
python3 -m venv .venv
```

Ative o ambiente:
```bash
source .venv/bin/activate
```

Instale as dependências:
```bash
pip install -r requirements.txt
```

## Windows

Crie o ambiente virtual:
```bash 
python -m venv .venv 
```

Ative o ambiente no PowerShell:
```bash 
.venv\Scripts\Activate.ps1
```

Ou, utilizando o Prompt de Comando (CMD):
```bash 
.venv\Scripts\activate
```

Instale as dependências:
```bash 
pip install -r requirements.txt
```

## Executando os testes

Todos os testes:
```bash
python -m robot -d results tests/
```

Somente Web:
```bash
python -m robot -d results tests/funcionarios.robot
```

Somente API:
```bash
python -m robot -d results tests/api.robot
```

Executar um cenário específico:
```bash
python -m robot -d results -t "Nome do CT" tests/
```

## Resultados
Após a execução, o Robot Framework gera os relatórios na pasta:
```text
results/
├── log.html
├── report.html
└── output.xml
```

## Documentação complementar
O projeto também possui:
- Plano de Testes;
- Relatório de Defeitos;
- Notas de Estratégia;
- Diário de Uso de IA.
