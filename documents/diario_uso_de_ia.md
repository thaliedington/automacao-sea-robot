# Diário de uso de IA
IAs utilizada: chatGPT (GPT 5.6 Sol), Copilot no VS Code e modo IA do Google.

## Utilizações
- Revisar BDD no Plano de Testes.
- Entender erro no console após criar um registro fora do padrão e checar que a página Inicial ficou branca.
- Discutir argumentos para embasar a classificação dos bugs na prioridade P1. Eu classifiquei, mas queria mais informações sobre impactos.
- Modo IA do Google: ao pesquisar no Google a IA retornava informações condensadas de várias páginas.

### Utilizações na automação 
- Entender os erros após os cenários falharem.
- Corrigir lógica para usar o contador da página inicial "Ativos 0/1" como checagem. Ela adicionou Evaluate, Should Match Regexp e Remove String.
- Achar no código HTML o alerta "Preencha esse campo". Ela informou que era uma função nativa do HMTL e sugeriu executar JavaScript validity.valueMissing e .validationMessage.
- Copilot: autocomplete ao duplicar keywords muito parecidas ou trocar nomes de variáveis.

## O que a IA sugeriu errado
Sobre o BUG-005 - Upload irrestrito de arquivos no Campo de anexar ASO:
- O chatGPT (GPT 5.6 Sol) sugeriu que fazer upload arquivos sem validação adequada não era um bug, porque a regra de aceitação deve ser definida pela empresa. Eu discordei e fui procurar o OWASP Top 10 e achei a vulnerabilidade dentro da posição 6 - Design Inseguro.

Sobre o cenário CT-009 - Validar Persistencia Das Opcoes Do Campo Cargo (automação):
- Esse cenário cadastra na interface e depois checa a persistência no GET. No log apareceu o erro após executar a automação: "No keyword with name 'GET' found.". O chatGPT afirmou que era problema de compatibilidade entre a versão do Python e do Robot Framework. Ficamos um bom tempo instalando e desinstalando, até eu pesquisar no Google e perceber tinha esquecido de declarar a RequestsLibrary.