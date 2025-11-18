# 🎯 PLANO DE MELHORIA - IA PRESIDENTE 1

## 🔍 ANÁLISE DO PROBLEMA

### Problema Identificado
Soldados do presidente no mapa que não são comandados adequadamente.

### Causas Prováveis
1. **Unidades criadas mas não comandadas** — o presidente recruta mas não move/ataca
2. **Recrutamento apenas de unidades básicas** — não usa as melhores unidades
3. **Sistema de ataque fraco** — não forma esquadrões ou ataca de forma coordenada
4. **Falta de estratégia** — não adapta táticas ao exército do jogador

---

## 📋 PLANO DE MELHORIA

### **FASE 1: COMANDO CONTÍNUO DE UNIDADES** ⚡ PRIORIDADE MÁXIMA

#### Problema
Unidades são criadas mas ficam paradas, sem receber comandos.

#### Solução
Implementar sistema de comando periódico que:
- Verifica unidades órfãs (sem destino/alvo) a cada 3-5 segundos
- Comanda unidades para posições estratégicas
- Ativa modo de ataque quando encontra inimigos

#### Implementação
1. Criar `scr_ia_comandar_unidades_continuo` - verifica e comanda unidades periodicamente
2. Adicionar timer no `obj_presidente_1` para executar comando a cada 5 segundos
3. Sistema detecta unidades sem destino e as move para posições estratégicas

---

### **FASE 2: SELEÇÃO DE UNIDADES PREMIUM** ⭐ ALTA PRIORIDADE

#### Problema
IA recruta apenas unidades básicas (infantaria, tanque básico) mesmo tendo recursos.

#### Solução
Priorizar unidades premium quando recursos permitirem:
- **Terrestres**: M1A Abrams, Gepard Anti-Aéreo
- **Aéreas**: F-15 Eagle, SU-35 Flanker
- **Navais**: Independence, Ronald Reagan

#### Implementação
1. Modificar lógica de recrutamento em `obj_presidente_1/Step_0.gml`
2. Adicionar verificação de recursos antes de escolher unidade
3. Priorizar unidades premium quando `ia_dinheiro >= 1000` e `ia_minerio >= 500`

---

### **FASE 3: SISTEMA DE ESQUADRÕES/FORMAÇÕES** 🎖️ MÉDIA PRIORIDADE

#### Problema
Unidades atacam individualmente, sem coordenação.

#### Solução
Agrupar unidades em esquadrões táticos:
- **Esquadrão de Assalto**: 3-5 tanques + 5-10 infantaria
- **Esquadrão Anti-Aéreo**: 2-3 blindados anti-aéreos + 3-5 soldados anti-aéreos
- **Esquadrão Naval**: 2-3 navios em formação

#### Implementação
1. Criar `scr_ia_formar_esquadrao` - agrupa unidades em esquadrões
2. Cada esquadrão tem líder e unidades seguidoras
3. Comandos são dados ao líder, unidades seguem automaticamente

---

### **FASE 4: RECONHECIMENTO ATIVO** 🔍 MÉDIA PRIORIDADE

#### Problema
IA só ataca quando inimigos estão muito próximos.

#### Solução
Sistema de reconhecimento que:
- Envia unidades de reconhecimento para explorar o mapa
- Identifica posições do jogador
- Mapeia estruturas inimigas
- Atualiza mapa de ameaças

#### Implementação
1. Melhorar `scr_ia_reconhecimento` existente
2. Criar sistema de pontos de interesse (POIs) do jogador
3. Atualizar estratégia baseada em informações coletadas

---

### **FASE 5: ESTRATÉGIAS ADAPTATIVAS** 🧠 BAIXA PRIORIDADE

#### Problema
IA não adapta táticas ao exército do jogador.

#### Solução
Sistema de análise e adaptação:
- Analisar composição do exército do jogador
- Identificar fraquezas (ex: muitos tanques = usar anti-tanque)
- Adaptar recrutamento e táticas

#### Implementação
1. Melhorar `scr_ia_decisao_unidade_estrategica`
2. Criar sistema de contadores de unidades inimigas
3. Ajustar estratégia baseada em análise

---

## 🚀 IMPLEMENTAÇÃO PRIORITÁRIA

### **PASSO 1: Sistema de Comando Contínuo** (CRÍTICO)

Criar script que verifica e comanda unidades periodicamente.

### **PASSO 2: Melhorar Seleção de Unidades** (ALTA)

Modificar lógica de recrutamento para priorizar unidades premium.

### **PASSO 3: Sistema de Formações** (MÉDIA)

Implementar agrupamento de unidades em esquadrões.

---

## 📊 MÉTRICAS DE SUCESSO

- ✅ Unidades da IA se movem e atacam ativamente
- ✅ IA recruta unidades premium quando tem recursos
- ✅ Unidades atacam em formação coordenada
- ✅ IA explora mapa e encontra alvos proativamente
- ✅ IA adapta estratégia baseada no exército do jogador

---

## 🔧 ARQUIVOS A MODIFICAR

1. `objects/obj_presidente_1/Step_0.gml` - Adicionar comando contínuo
2. `objects/obj_presidente_1/Step_0.gml` - Melhorar seleção de unidades
3. `scripts/scr_ia_comandar_unidades_continuo/` - NOVO - Comando periódico
4. `scripts/scr_ia_formar_esquadrao/` - NOVO - Sistema de esquadrões
5. `scripts/scr_ia_reconhecimento/scr_ia_reconhecimento.gml` - Melhorar reconhecimento

