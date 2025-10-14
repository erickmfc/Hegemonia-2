# PRD - Hegemonia Global: Menu de Construção

## 1. Visão Geral do Produto

### 1.1 Nome do Produto
**Hegemonia Global** - Sistema de Construção e Estratégia Militar

### 1.2 Descrição
Hegemonia Global é um jogo de estratégia militar desenvolvido em GameMaker Studio 2, focado na construção de bases, gerenciamento de recursos e comando de unidades militares. O jogo combina elementos de construção de cidade com estratégia militar tática.

### 1.3 Objetivos do Produto
- Proporcionar uma experiência de estratégia militar envolvente
- Implementar sistemas complexos de gerenciamento de recursos
- Criar um sistema de construção intuitivo e funcional
- Desenvolver mecânicas de combate tático realistas

## 2. Público-Alvo

### 2.1 Perfil do Usuário
- **Idade**: 16-35 anos
- **Interesses**: Jogos de estratégia, simulação militar, construção de cidades
- **Experiência**: Jogadores intermediários a avançados de estratégia
- **Plataforma**: PC/Desktop (Windows)

### 2.2 Personas
- **Estrategista Militar**: Foca em táticas de combate e comando de unidades
- **Construtor de Impérios**: Prioriza desenvolvimento econômico e expansão territorial
- **Pesquisador Tecnológico**: Interessa-se por sistemas de pesquisa e upgrades

## 3. Funcionalidades Principais

### 3.1 Sistema de Construção
- **Construção de Edifícios**: Sistema baseado em grid com validação de terreno
- **Tipos de Edifícios**:
  - Residenciais: Casas (população)
  - Econômicos: Bancos, Minas, Serraria
  - Militares: Quarteis, Centro de Pesquisa
  - Recursos: Poços de Petróleo, Plantações

### 3.2 Sistema de Recursos
- **Recursos Fundamentais**: Dinheiro, Minério, Petróleo, População
- **Recursos Estratégicos**: Ouro, Titânio, Urânio, Alumínio, Cobre, Lítio
- **Recursos Orgânicos**: Borracha, Madeira
- **Recursos Tecnológicos**: Silício, Aço, Energia

### 3.3 Sistema Militar
- **Unidades de Combate**:
  - Infantaria: Unidades básicas de combate terrestre
  - Tanques: Unidades blindadas pesadas
  - Marinha: Navios de guerra (Corvetas, Fragatas, Destroyers, Cruzadores, Porta-aviões)
- **Sistema de Combate**: Baseado em alcance, dano e taxa de ataque
- **Comandos Táticos**: Formações, patrulhas, movimentação estratégica

### 3.4 Sistema de Pesquisa
- **Centro de Pesquisa**: Desbloqueio de tecnologias
- **Árvore Tecnológica**: 12 tecnologias disponíveis
- **Slots de Pesquisa**: Sistema de limitação com possibilidade de expansão

### 3.5 Interface de Usuário
- **Menus de Construção**: Interface intuitiva para seleção de edifícios
- **Dashboard Econômico**: Monitoramento de recursos em tempo real
- **Painéis de Comando**: Controle de unidades militares
- **Sistema de Informações**: Feedback visual e textual

## 4. Requisitos Técnicos

### 4.1 Plataforma
- **Engine**: GameMaker Studio 2 (v2024.8.1.171)
- **Linguagem**: GML (GameMaker Language)
- **Plataforma Alvo**: Windows Desktop

### 4.2 Arquitetura
- **Sistema Modular**: Objetos especializados para cada funcionalidade
- **Gerenciamento Global**: Sistema centralizado de recursos e estado
- **Pathfinding**: Sistema de navegação para unidades
- **Grid System**: Sistema de tiles para construção e movimento

### 4.3 Performance
- **Otimização**: Sistema de debug configurável
- **Memória**: Gerenciamento eficiente de estruturas de dados
- **Renderização**: Sistema de camadas para diferentes elementos

## 5. Experiência do Usuário

### 5.1 Fluxo Principal
1. **Inicialização**: Carregamento do jogo e configuração inicial
2. **Construção**: Seleção e posicionamento de edifícios
3. **Gerenciamento**: Monitoramento de recursos e população
4. **Pesquisa**: Desenvolvimento de tecnologias
5. **Militar**: Recrutamento e comando de unidades
6. **Combate**: Engajamento tático com inimigos

### 5.2 Controles
- **Mouse**: Seleção, construção, comando de unidades
- **Teclado**: Atalhos para funcionalidades rápidas
- **Interface**: Menus contextuais e painéis informativos

## 6. Critérios de Sucesso

### 6.1 Funcionalidade
- ✅ Sistema de construção funcional
- ✅ Gerenciamento de recursos operacional
- ✅ Sistema militar implementado
- ✅ Interface de usuário responsiva

### 6.2 Performance
- ✅ Carregamento rápido do jogo
- ✅ Execução fluida sem travamentos
- ✅ Sistema de debug eficiente

### 6.3 Usabilidade
- ✅ Interface intuitiva e clara
- ✅ Feedback visual adequado
- ✅ Controles responsivos

## 7. Roadmap de Desenvolvimento

### 7.1 Fase Atual
- Sistema de construção implementado
- Sistema de recursos funcional
- Sistema militar básico operacional
- Interface de usuário completa

### 7.2 Próximas Fases
- Refinamento do sistema de combate
- Expansão da árvore tecnológica
- Implementação de IA para inimigos
- Otimizações de performance

## 8. Métricas de Sucesso

### 8.1 Técnicas
- Tempo de carregamento < 5 segundos
- FPS estável > 60
- Uso de memória < 500MB

### 8.2 Funcionais
- 100% dos edifícios construíveis
- Sistema de recursos sem bugs críticos
- Sistema militar totalmente operacional

## 9. Riscos e Mitigações

### 9.1 Riscos Técnicos
- **Complexidade do Sistema**: Mitigado por arquitetura modular
- **Performance**: Mitigado por otimizações contínuas
- **Compatibilidade**: Mitigado por testes regulares

### 9.2 Riscos de Design
- **Complexidade da Interface**: Mitigado por testes de usabilidade
- **Curva de Aprendizado**: Mitigado por tutoriais e feedback

## 10. Conclusão

O projeto Hegemonia Global representa um jogo de estratégia militar ambicioso com sistemas complexos e interconectados. O desenvolvimento atual demonstra uma base sólida com funcionalidades principais implementadas. O foco deve continuar no refinamento dos sistemas existentes e na otimização da experiência do usuário.
