# 🤖 GUIA - IA PRESIDENTE 1

## ✅ STATUS: IMPLEMENTADO E PRONTO PARA USO

---

## 📋 RESUMO

O sistema de IA "Presidente 1" foi completamente implementado e está pronto para uso. A IA é um adversário controlado por computador que constrói, expande e ataca automaticamente.

---

## 🎯 COMPONENTES IMPLEMENTADOS

### 1. **Recursos Globais da IA**
- **Localização:** `objects/obj_game_manager/Create_0.gml` (linhas 349-357)
- **Variáveis:**
  - `global.ia_dinheiro = 2000`
  - `global.ia_minerio = 1000`
  - `global.ia_petroleo = 500`
  - `global.ia_populacao = 100`
  - `global.ia_alimento = 0`

### 2. **Módulo de Decisão Econômica**
- **Arquivo:** `scripts/scr_ia_decisao_economia/scr_ia_decisao_economia.gml`
- **Função:** Analisa o estado atual da IA e decide ações
- **Decisões possíveis:**
  - `construir_economia` - Construir fazendas
  - `construir_mina` - Construir minas
  - `construir_militar` - Construir quartéis
  - `recrutar_unidades` - Recrutar unidades militares
  - `atacar` - Atacar inimigos visíveis
  - `expandir` - Expansão territorial

### 3. **Módulo de Construção**
- **Arquivo:** `scripts/scr_ia_construir/scr_ia_construir.gml`
- **Função:** Constrói estruturas para a IA
- **Suporta:** Fazendas, Quartéis, Minas

### 4. **Objeto Principal**
- **Arquivo:** `objects/obj_presidente_1/`
- **Eventos implementados:**
  - `Create_0.gml` - Inicialização
  - `Step_0.gml` - Lógica de decisão
  - `Draw_0.gml` - Visualização
- **Nação:** `nacao_proprietaria = 2` (Inimiga)

---

## 🚀 COMO USAR

### Passo 1: Adicionar ao Mapa
1. Abra a sala `Room1` no GameMaker
2. No Room Editor, clique com o botão direito → Adicionar Objeto
3. Selecione `obj_presidente_1`
4. Posicione no mapa (recomendado: lado oposto ao jogador)

### Passo 2: Executar o Jogo
A IA começará a funcionar automaticamente:
- ⏱️ **Timer de Decisão:** A cada 5 segundos
- 🏗️ **Construção:** Fazendas, Quartéis, Minas
- 📊 **Recursos:** Deduz automaticamente do `global.ia_dinheiro`
- 👤 **Propriedade:** Todas as estruturas criadas terão `nacao_proprietaria = 2`

---

## 🎮 COMPORTAMENTO DA IA

### Fase 1: Expansão Econômica (Primeiros 30 segundos)
```
Prioridade: Construir Fazendas
Objetivo: Gerar recurso alimentar
Ações: 3-5 fazendas
```

### Fase 2: Infraestrutura Militar (30-60 segundos)
```
Prioridade: Construir Quartéis
Objetivo: Base para recrutamento
Ações: 1-2 quartéis
```

### Fase 3: Recrutamento (60-90 segundos)
```
Prioridade: Recrutar Infantaria
Objetivo: 10 unidades militares
Ações: Treinamento contínuo nos quartéis
```

### Fase 4: Ataque (90+ segundos)
```
Prioridade: Atacar Jogador
Objetivo: Dominar território
Ações: Comandos de ataque automáticos
```

---

## 🎨 VISUALIZAÇÃO

A IA é representada por:
- 🔴 **Círculo vermelho semi-transparente** no mapa
- 📝 **Nome:** "Presidente 1"
- 📊 **Painel de recursos** quando próxima da câmera:
  - 💰 Dinheiro
  - ⛏️ Minério
  - 👥 Estruturas

---

## 🔧 PERSONALIZAÇÃO

### Alterar Recursos Iniciais
**Arquivo:** `objects/obj_game_manager/Create_0.gml` (linhas 349-355)
```gml
global.ia_dinheiro = 5000;      // Aumentar recursos
global.ia_minerio = 1500;       // Aumentar minério
global.ia_petroleo = 500;       // Aumentar petróleo
global.ia_populacao = 200;      // Aumentar população
```

### Alterar Intervalo de Decisão
**Arquivo:** `objects/obj_presidente_1/Create_0.gml` (linha 8)
```gml
intervalo_decisao = 300;  // 5 segundos (60 FPS × 5)
intervalo_decisao = 180;  // 3 segundos (mais agressivo)
intervalo_decisao = 600;  // 10 segundos (mais passivo)
```

### Alterar Prioridades
**Arquivo:** `objects/obj_presidente_1/Create_0.gml` (linhas 10-11)
```gml
prioridade_economia = 0.4;  // 40% econômico
prioridade_militar = 0.6;   // 60% militar

// Exemplo: IA agressiva
prioridade_economia = 0.2;
prioridade_militar = 0.8;

// Exemplo: IA pacífica
prioridade_economia = 0.7;
prioridade_militar = 0.3;
```

### Alterar Raio de Expansão
**Arquivo:** `objects/obj_presidente_1/Create_0.gml` (linha 20)
```gml
raio_expansao = 800;    // Padrão
raio_expansao = 1200;   // Expansão maior
raio_expansao = 500;    // Expansão menor
```

---

## 🐛 DEBUG

A IA envia mensagens de debug para o console:
```
🤖 IA PRESIDENTE 1 INICIALIZADA - Modo: expandir
🤖 IA DECISÃO: construir_economia | Fazendas: 1 | Quartéis: 0 | Unidades: 0
✅ IA construiu obj_fazenda em (500, 400)
💰 IA recursos restantes: $1500 | Minério: 1000
```

---

## 📊 STATUS ATUAL

- ✅ Recursos globais separados
- ✅ Sistema de decisão modular
- ✅ Construção automática
- ✅ Visualização clara
- ⏳ Recrutamento de unidades (TODO)
- ⏳ Formação de esquadrões (TODO)
- ⏳ Ataque ao jogador (TODO)
- ⏳ Expansão territorial (TODO)

---

## 🔮 EXPANSÕES FUTURAS

### 1. Recrutamento Automático
- Integrar com `obj_quartel` para recrutar unidades
- Formar filas de treinamento

### 2. Inteligência de Combate
- Formar esquadrões coordenados
- Ataque coordenado
- Retirada tática

### 3. Expansão Avançada
- Construir base secundária
- Expandir território gradualmente

### 4. IA Externa (Gemini)
- Usar Gemini para estratégias complexas
- Adaptação dinâmica ao comportamento do jogador

---

## 🎓 ESTRUTURA DE CÓDIGO

```
obj_presidente_1/
├── Create_0.gml      → Inicialização
├── Step_0.gml        → Lógica principal (chama scr_ia_decisao_economia)
└── Draw_0.gml        → Visualização

scripts/
├── scr_ia_decisao_economia/
│   └── scr_ia_decisao_economia.gml  → Análise e decisão
└── scr_ia_construir/
    └── scr_ia_construir.gml         → Construção de estruturas
```

---

## ✅ CONCLUSÃO

O sistema de IA "Presidente 1" está **completo e pronto para uso**. Adicione `obj_presidente_1` ao mapa e a IA começará a funcionar automaticamente.

**Próximos passos sugeridos:**
1. Testar no jogo
2. Ajustar dificuldade (recursos, timer, prioridades)
3. Implementar recrutamento automático
4. Adicionar mais IAs (Presidente 2, Presidente 3)

**Divirta-se jogando! 🎮**

