# 🧪 Guia de Teste - Sistema de Navio Transporte

## ✅ Checklist de Funcionalidades

### 1. 🎮 Controles Básicos

- [ ] **Movimento** - Clique direito no mapa para mover navio
  - [ ] Navio se move suavemente
  - [ ] Rotação é contínua
  - [ ] Para ao chegar no destino

- [ ] **Parar (L)** - Pressionar L
  - [ ] Navio para imediatamente
  - [ ] Embarque é cancelado
  - [ ] Combate é cancelado

- [ ] **Patrulha (K)** - Pressionar K
  - [ ] Modo patrulha ativado
  - [ ] Cliques múltiplos definem pontos
  - [ ] Visualização de rota aparece
  - [ ] Pressionar K novamente inicia patrulha
  - [ ] Navio segue rota em loop

### 2. 🚚 Embarque

- [ ] **Ativar Embarque (P)** - Pressionar P
  - [ ] Estado muda para "EMBARQUE_ATIVO"
  - [ ] Mensagem debug: "🚚 MODO EMBARQUE ATIVO"
  - [ ] Infantaria próxima fica invisível

- [ ] **Detecção Automática**
  - [ ] Infantaria a 80px é detectada
  - [ ] F-5 a 80px é detectada
  - [ ] Helicópteros a 80px são detectados
  - [ ] Tanques a 80px são detectados
  - [ ] Apenas unidades aliadas entram

- [ ] **Limite de Carga**
  - [ ] Máximo 50 soldados
  - [ ] Máximo 10 veículos
  - [ ] Máximo 10 aeronaves
  - [ ] Ao atingir máximo, embarque para

- [ ] **Menu de Carga (J)**
  - [ ] Menu abre ao pressionar J
  - [ ] Exibe corretamente: ✈️ Aeronaves, 🚛 Veículos, 👥 Soldados
  - [ ] Barra de carga visual funciona
  - [ ] Percentual é preciso
  - [ ] Menu fecha ao pressionar J novamente

### 3. 📦 Desembarque

- [ ] **Ativar Desembarque (P)**
  - [ ] Pressionar P novamente após embarque
  - [ ] Estado muda para "DESEMBARCANDO"
  - [ ] Unidades começam a aparecer

- [ ] **Desembarque Gradual**
  - [ ] Unidades desembarcam uma por uma
  - [ ] Intervalo de 2 segundos entre unidades
  - [ ] Prioridade: Soldados → Veículos → Aeronaves
  - [ ] Mensagens debug aparecem

- [ ] **Posicionamento Radial**
  - [ ] Soldados aparecem a 80px
  - [ ] Veículos aparecem a 90px
  - [ ] Aeronaves aparecem a 100px
  - [ ] Cada unidade tem ângulo diferente (30°)
  - [ ] Padrão radial é visível

### 4. ⚔️ Combate

- [ ] **Modo Ataque (O)**
  - [ ] Pressionar O alterna PASSIVO ↔️ ATAQUE
  - [ ] Círculo de radar muda de cinza para vermelho
  - [ ] Debug mostra alteração de modo

- [ ] **Detecção de Inimigos**
  - [ ] Submarinos são detectados
  - [ ] Navios inimigos são detectados
  - [ ] Aeronaves inimigas são detectadas
  - [ ] Infantaria inimiga é detectada
  - [ ] Detecção funciona até 1000px

- [ ] **Prioridade de Alvo**
  - [ ] Submarinos: prioridade MÁXIMA
  - [ ] Navios: prioridade alta
  - [ ] Aeronaves: prioridade média
  - [ ] Infantaria: prioridade baixa

- [ ] **Comportamento em Combate**
  - [ ] Navio persegue inimigos distantes
  - [ ] Navio orbita ao alcançar distância de tiro
  - [ ] Tiros são disparados a cada segundo
  - [ ] Alvo é destruído corretamente
  - [ ] Retorna ao estado anterior após combate

### 5. 🖥️ Interface Visual

- [ ] **Seleção do Navio**
  - [ ] Clique esquerdo seleciona
  - [ ] Círculo verde aparece ao redor
  - [ ] Informações são exibidas

- [ ] **Indicadores Visuais**
  - [ ] Status (PARADO, NAVEGANDO, etc) aparece
  - [ ] Modo de transporte é mostrado (EMBARQUE, etc)
  - [ ] Barra de carga visual funciona
  - [ ] Controles disponíveis são exibidos

- [ ] **Menu de Carga (J)**
  - [ ] Layout é limpo e legível
  - [ ] Cores: amarelo (título), branco (labels), ciano (valores)
  - [ ] Barra de progresso: verde → laranja → vermelho
  - [ ] Botões "DESEMBARCAR" e "FECHAR" são clicáveis

### 6. 📊 Estados e Transições

- [ ] **Estado Parado**
  - [ ] Navio não se move
  - [ ] Aceita comandos
  - [ ] Estado transporte = PARADO

- [ ] **Estado Navegando**
  - [ ] Navio se move suavemente
  - [ ] Estado transporte = NAVEGANDO
  - [ ] Pode receber novos comandos

- [ ] **Estado Patrulhando**
  - [ ] Navio segue rota definida
  - [ ] Estado transporte = PATRULHANDO
  - [ ] L cancela patrulha

- [ ] **Estado Embarque**
  - [ ] Estado transporte = EMBARQUE_ATIVO
  - [ ] Unidades são detectadas e armazenadas
  - [ ] Muda para EMBARQUE_OFF quando cheio

- [ ] **Estado Desembarque**
  - [ ] Estado transporte = DESEMBARCANDO
  - [ ] Unidades aparecem uma por uma
  - [ ] Volta a PARADO ao terminar

- [ ] **Estado Combate**
  - [ ] Estado transporte = ATACANDO
  - [ ] Navio orbita inimigo
  - [ ] Mísseis são disparados

---

## 🧪 Cenários de Teste Detalhados

### Cenário 1: Transporte Simples de Infantaria

```
1. Criar navio transporte perto da base
2. Criar 5 infantaria próxima
3. Pressionar P (embarque)
4. Verificar se infantaria desaparece
5. Pressionar J para verificar menu (5/50)
6. Mover navio para novo local
7. Pressionar P (desembarque)
8. Verificar infantaria reaparece uma por vez
```

**Resultado Esperado:** ✅ Todas as 5 unidades embarcam e desembarcam corretamente

### Cenário 2: Carga Mista

```
1. Criar 20 infantaria perto do navio
2. Criar 3 tanques perto do navio
3. Criar 2 F-5 perto do navio
4. Pressionar P (embarque ativo)
5. Aguardar todos embarcarem
6. Pressionar J para verificar
```

**Resultado Esperado:** 
- ✅ 20 infantaria embarcadas
- ✅ 3 tanques embarcados
- ✅ 2 F-5 embarcadas
- ✅ Menu mostra: ✈️ 2/10, 🚛 3/10, 👥 20/50

### Cenário 3: Capacidade Máxima

```
1. Criar 50 infantaria perto do navio
2. Criar 10 tanques perto do navio
3. Criar 10 F-5 perto do navio
4. Pressionar P
5. Aguardar embarque completar
6. Verificar se para automaticamente
```

**Resultado Esperado:**
- ✅ Mensagem: "✅ Navio CHEIO"
- ✅ Estado: EMBARQUE_OFF
- ✅ Todas 70 unidades embarcadas
- ✅ Menu mostra 100%

### Cenário 4: Combate com Carga

```
1. Embarcar 30 soldados e 5 tanques
2. Navegar com carga
3. Encontrar navio inimigo
4. Pressionar O (combate)
5. Navio deve orbitar e disparar
```

**Resultado Esperado:**
- ✅ Navio não desembarque durante combate
- ✅ Combate funciona normalmente
- ✅ Ao destruir inimigo, volta ao movimento

### Cenário 5: Patrulha com Embarque

```
1. Definir rota de patrulha (K)
2. Iniciar patrulha (K novamente)
3. Embarcar unidades (P)
4. Navio patrulha com carga
5. Ao detectar inimigo, atacar (O = ATAQUE)
```

**Resultado Esperado:**
- ✅ Patrulha continua com embarque ativo
- ✅ Combate interrompe patrulha
- ✅ Retorna à patrulha após combate

### Cenário 6: Desembarque Progressivo

```
1. Embarcar 50 soldados, 10 tanques, 10 F-5
2. Pressionar P (desembarque)
3. Observar por 30 segundos
4. Verificar ordem: soldados → tanques → F-5
```

**Resultado Esperado:**
- ✅ Desembarque em ordem correta
- ✅ ~1 unidade por 2 segundos
- ✅ Todas 70 unidades desembarcam em ~140 segundos

---

## 🐛 Testes de Robustez

### Teste: Embarque Cancelado

```gml
1. P (embarque ativo)
2. L (parar)
3. Verificar se embarque foi cancelado
```

**Esperado:** Modo embarque desativado, unidades continuam embarcadas

### Teste: Velocidade em Combate

```gml
1. Mover navio
2. Detectar inimigo
3. Verificar velocidade de orbita
4. Velocidade não deve ser muito rápida
```

**Esperado:** Orbita suave e realista

### Teste: Limite de Distância

```gml
1. Criar unidade a 79px
2. Embarque deve funcionar
3. Criar unidade a 81px
4. Embarque NÃO deve funcionar
```

**Esperado:** Limite rigoroso de 80px

### Teste: Memória DS_LIST

```gml
1. Embarcar/desembarcar 100 vezes
2. Verificar console for vazamento de memória
3. Verificar performance
```

**Esperado:** Sem crash, performance estável

---

## 📋 Checklist Final

- [ ] Todos os controles respondem
- [ ] Embarque automático funciona
- [ ] Desembarque progressivo funciona
- [ ] Combate é eficaz
- [ ] Interface é clara
- [ ] Mensagens debug aparecem
- [ ] Sem crashes ou erros
- [ ] Performance é boa
- [ ] Patrulha funciona com carga
- [ ] Estados transitam corretamente

---

## 🎯 Notas de Teste

- Usar Console Debug para monitorar mensagens
- Testar cada funcionalidade isoladamente
- Testar combinações de funcionalidades
- Testar limites e bordas (capacidade máxima, distância máxima)
- Verificar performance com carga alta (70 unidades)

---

**Teste por:** [Seu Nome]  
**Data:** [Data do Teste]  
**Status:** ⏳ Pendente / 🔄 Em Andamento / ✅ Completo
