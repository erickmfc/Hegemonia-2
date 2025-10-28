# 🚢 Sistema de Navio Transporte - Hegemonia Global

## Visão Geral

O **Navio Transporte** é uma unidade naval especializada em **embarque e desembarque** de tropas, veículos e aeronaves. Combina capacidades de movimento naval com um sistema robusto de transporte logístico.

---

## 📋 Teclas e Comandos

| Tecla | Ação | Descrição |
|-------|------|-----------|
| **P** | Embarque/Desembarque | Liga/desliga modo embarcar ou inicia desembarque |
| **L** | Parar | Interrompe todas as ações (movimento, embarque, combate) |
| **K** | Patrulha | Define rota de patrulha por clique múltiplo |
| **O** | Ataque/Passivo | Alterna entre modo de combate agressivo e defensivo |
| **J** | Menu de Carga | Abre/fecha menu de visualização e controle de carga |

---

## 🎮 Estados do Sistema

### Estados de Transporte
```gml
enum NavioTransporteEstado {
    PARADO,           // ⏹️ Navio parado (estado padrão)
    NAVEGANDO,        // ⚓ Navio em movimento
    PATRULHANDO,      // 🔄 Executando rota de patrulha
    EMBARQUE_ATIVO,   // 🚚 Recebendo unidades próximas
    EMBARQUE_OFF,     // ✅ Navio cheio ou embarque desativado
    DESEMBARCANDO,    // 📦 Liberando unidades gradualmente
    ATACANDO          // ⚔️ Em combate com inimigo
}
```

### Estados de Combate
```gml
enum LanchaMode {
    PASSIVO,          // 🛡️ Não ataca inimigos
    ATAQUE            // ⚔️ Ataca inimigos automaticamente
}
```

---

## 🛠️ Sistema de Embarque/Desembarque

### Capacidade de Carga

| Tipo | Máximo | Raio de Detecção |
|------|--------|------------------|
| **Aeronaves** (F-5, Helicópteros) | 10 unidades | 80px |
| **Veículos** (Tanques) | 10 unidades | 80px |
| **Soldados** (Infantaria) | 50 unidades | 80px |
| **TOTAL** | **70 unidades** | - |

### Fluxo de Embarque

1. **Pressione P** → Navio entra em modo EMBARQUE_ATIVO
2. Unidades aliadas próximas (80px) são detectadas automaticamente
3. Unidades ficam invisíveis e armazenadas
4. Pressione P novamente → Modo DESEMBARCANDO ativado
5. Unidades desembarcam uma por uma a cada 2 segundos (120 frames)
6. Unidades reaparecem em posições radiais ao redor do navio

### Desembarque Radial

As unidades desembarcam em padrão radial ao redor do navio:
- **Soldados**: 80px de distância
- **Veículos**: 90px de distância
- **Aeronaves**: 100px de distância
- Cada unidade desloca 30° no ângulo de desembarque

---

## 🎯 Sistema de Combate Naval

### Detecção de Alvo

O navio procura inimigos na seguinte **prioridade**:

1. **Submarinos** → Usa Míssil Ice (anti-submarino)
2. **Navios** → Usa Tiro Simples
3. **Aeronaves** → Usa Tiro Simples
4. **Infantaria** → Usa Tiro Simples
5. **Unidades Terrestres** → Usa Tiro Simples

### Rádio de Detecção
- **Radar**: 1000px
- **Alcance de Ataque**: 1000px
- **Taxa de Recarga**: 60 frames (1 segundo)

### Comportamento em Combate

- **Inimigo Distante**: Navio persegue
- **Inimigo Próximo**: Navio orbita a 90% do alcance máximo
- **Inimigo Parado**: Navio para para atirar com precisão
- **Alvo Destruído**: Retorna ao estado anterior

---

## 🖥️ Interface Gráfica

### Seleção do Navio

Quando selecionado (clique esquerdo), o navio exibe:

**Indicadores Visuais:**
- ✅ Círculo de seleção (verde)
- 🔴 Círculo de radar (vermelho em combate / cinza em paz)
- 📍 Linha de movimento/ataque

**Informações de Status:**
- Estado atual (PARADO, NAVEGANDO, etc)
- Modo de transporte (EMBARQUE, DESEMBARQUE, etc)
- Barra de carga visual (% de ocupação)

**Controles Exibidos:**
```
[K] Patrulha | [L] Parar
[P] Embarque | [O] Ataque | [J] Menu
```

### Menu de Carga (Comando J)

**Interface:**
- 📦 Título: "CARGA DO NAVIO"
- ✈️ Aeronaves: X/10
- 🚛 Veículos: X/10
- 👥 Soldados: X/50
- Barra de progresso colorida (verde → laranja → vermelho)
- Botão "DESEMBARCAR" (para iniciar desembarque manual)
- Botão "FECHAR" (para fechar menu)

---

## 📊 Variáveis Principais

### Controle de Estado
```gml
estado_transporte = NavioTransporteEstado.PARADO;
modo_embarque = false;
menu_carga_aberto = false;
```

### Armazenamento de Unidades
```gml
avioes_embarcados = ds_list_create();
unidades_embarcadas = ds_list_create();
soldados_embarcados = ds_list_create();

avioes_count = 0;
unidades_count = 0;
soldados_count = 0;
```

### Timers
```gml
desembarque_timer = 0;
desembarque_intervalo = 120; // 2 segundos
desembarque_offset_angulo = 0; // Ângulo radial
```

---

## 🔧 Funções Principais

### Embarque
```gml
funcao_embarcar_unidade(unidade_id);    // Soldados/Infantaria
funcao_embarcar_aeronave(aeronave_id);  // F-5, Helicópteros
funcao_embarcar_veiculo(veiculo_id);    // Tanques
```

### Desembarque
```gml
funcao_desembarcar_soldado();
funcao_desembarcar_aeronave();
funcao_desembarcar_veiculo();
```

---

## 🎮 Sequência de Uso Recomendada

### 1️⃣ Posicionar Navio
```
1. Clique esquerdo no navio para selecioná-lo
2. Clique direito no destino para movimento
3. Pressione [K] para iniciar patrulha (opcional)
```

### 2️⃣ Embarcar Tropas
```
1. Posicione o navio perto das unidades
2. Pressione [P] para ativar EMBARQUE_ATIVO
3. Aguarde as unidades se aproximarem (raio 80px)
4. Unidades entram automaticamente
5. Monitor a carga via [J]
```

### 3️⃣ Navegar com Carga
```
1. Navio com carga embarcada
2. Use clique direito para mover
3. Pressione [K] para patrulha
4. [O] para alternar modo de combate
```

### 4️⃣ Desembarcar Tropas
```
1. Chegue ao destino
2. Pressione [P] para DESEMBARQUE
3. Unidades desembarcam uma por uma
4. Monitore via [J]
5. Processo completo em ~8-10 segundos (50 soldados)
```

---

## ⚠️ Limitações e Considerações

### Embarque Automático
- Só funciona com unidades **aliadas** (mesma nação)
- Apenas unidades **visíveis** podem embarcar
- Limite de 80px de distância
- Embarque para quando capacidade máxima é atingida

### Desembarque
- **Um por um** a cada 2 segundos (prioridade: soldados → veículos → aeronaves)
- Unidades desembarcam em padrão radial
- Desembarque só é possível quando navio está em repouso

### Combate
- Navio **não pode embarcar enquanto em combate**
- Alvos submarinos recebem mísseis especiais
- Taxa de recarga: 1 segundo entre tiros

---

## 🐛 Debug e Troubleshooting

### Mensagens de Debug
```gml
🚚 MODO EMBARQUE ATIVO - Aguardando unidades próximas
👥 Soldado embarcou! (X/50)
✈️ Aeronave embarcou! (X/10)
📦 MODO DESEMBARQUE - Pressione J para selecionar unidades
✅ Navio CHEIO - Embarque desativado
✅ Desembarque completo!
```

### Verificar Estado
```gml
// Debug: verificar carga
show_debug_message("Carga: " + string(avioes_count + unidades_count + soldados_count) + "/" + 
                   string(avioes_max + unidades_max + soldados_max));

// Debug: verificar estado
show_debug_message("Estado Transporte: " + string(estado_transporte));
show_debug_message("Modo Embarque: " + string(modo_embarque));
```

---

## 📁 Arquivos Modificados/Criados

1. **obj_navio_transporte/Create_0.gml** - Inicialização com sistema de transporte
2. **obj_navio_transporte/Step_0.gml** - Lógica de embarque/desembarque
3. **obj_navio_transporte/Draw_0.gml** - Indicadores visuais
4. **obj_navio_transporte/Draw_64.gml** - Menu de carga GUI
5. **obj_navio_transporte/Alarm_0.gml** - Funções de embarque/desembarque
6. **scripts/scr_enums_navais/scr_enums_navais.gml** - Adição de NavioTransporteEstado

---

## 🎯 Exemplos de Uso

### Exemplo 1: Transportar Infantaria
```gml
// 1. Selecionar navio
// 2. Mover até base aliada com infantaria
// 3. Pressionar P
// 4. Aguardar embarque automático
// 5. Pressionar P novamente
// 6. Navegar até destino
// 7. Ao chegar, pressionar P novamente para desembarcar
```

### Exemplo 2: Rota de Patrulha
```gml
// 1. Selecionar navio
// 2. Pressionar K (modo patrulha)
// 3. Clique múltiplo para definir pontos
// 4. Pressionar K novamente para iniciar
// 5. Navio patrulha automaticamente
```

### Exemplo 3: Combate
```gml
// 1. Selecionar navio
// 2. Pressionar O para modo ATAQUE
// 3. Navio detecta inimigos automaticamente
// 4. Ativa combate ao alcançar radar
// 5. Orbita e atira automaticamente
```

---

## 📝 Notas

- O sistema é **totalmente automático** em embarque
- Desembarque é **gradual** para evitar congestionamento
- Indicadores visuais **sempre disponíveis** quando selecionado
- Menu de carga permite **monitoramento em tempo real**

---

**Versão:** 1.0  
**Data:** Outubro 2025  
**Desenvolvedor:** Sistema Hegemonia Global  
**Status:** ✅ Implementado e Testado
