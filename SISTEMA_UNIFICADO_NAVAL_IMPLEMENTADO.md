# 🚀 SISTEMA UNIFICADO DE ATAQUE NAVAL - SPRITE "AIR"

## 📋 **IMPLEMENTAÇÃO COMPLETA**

Sistema unificado implementado usando apenas o `obj_tiro_simples` com sprite "air" para ambos os navios, com configurações diferenciadas por cor e tamanho.

---

## ✅ **SISTEMA IMPLEMENTADO**

### **1. Lancha Patrulha**
- **Sprite**: `air` (do obj_tiro_simples)
- **Cor**: Azul (`c_blue`)
- **Tamanho**: 2.5x escala
- **Velocidade**: 8 pixels/frame
- **Dano**: 30 pontos
- **Tempo de vida**: 90 frames (1.5 segundos)
- **Intervalo**: 120 frames (2 segundos)

### **2. Fragata**
- **Sprite**: `air` (do obj_tiro_simples)
- **Cor**: Vermelho (`c_red`)
- **Tamanho**: 3.0x escala
- **Velocidade**: 10 pixels/frame
- **Dano**: 40 pontos
- **Tempo de vida**: 120 frames (2 segundos)
- **Intervalo**: 180 frames (3 segundos)

---

## ⚙️ **CONFIGURAÇÕES DIFERENCIADAS**

### **🚢 Lancha Patrulha**
```gml
// Configurações básicas
radar_alcance = 400;           // Alcance de detecção
missil_alcance = 250;          // Alcance de ataque
intervalo_ataque = 120;        // 2 segundos entre ataques

// Configurações do míssil
_missil.dano = 30;             // Dano da lancha
_missil.speed = 8;             // Velocidade do míssil
_missil.timer_vida = 90;       // Tempo de vida (1.5 segundos)
_missil.image_xscale = 2.5;    // Míssil maior
_missil.image_blend = c_blue;  // Cor azul para lancha
```

### **🚢 Fragata**
```gml
// Configurações básicas
alcance = 400;                 // Alcance de detecção
alcance_tiro = 300;            // Alcance de ataque
atq_rate = 180;                // 3 segundos entre mísseis

// Configurações do míssil
_missil.dano = 40;             // Dano maior da fragata
_missil.speed = 10;            // Velocidade maior
_missil.timer_vida = 120;      // Tempo de vida maior (2 segundos)
_missil.image_xscale = 3.0;    // Míssil ainda maior
_missil.image_blend = c_red;   // Cor vermelha para fragata
```

---

## 🎯 **CARACTERÍSTICAS DO SISTEMA**

### **✅ Sprite Unificado**
- **Objeto único**: Ambos navios usam `obj_tiro_simples`
- **Sprite único**: Ambos usam sprite "air"
- **Sistema limpo**: Elimina problemas de objetos não encontrados

### **✅ Identificação Visual**
- **Lancha**: Mísseis azuis (2.5x tamanho)
- **Fragata**: Mísseis vermelhos (3.0x tamanho)
- **Fácil distinção**: Cores diferentes para cada navio

### **✅ Configurações Balanceadas**
- **Lancha**: Mais rápida, menor dano, menor alcance
- **Fragata**: Mais lenta, maior dano, maior alcance
- **Cooldowns**: Diferentes para balanceamento

---

## 🚀 **FUNCIONALIDADES IMPLEMENTADAS**

### **✅ Sistema de Detecção**
- **Múltiplos inimigos**: Detecta obj_inimigo, obj_infantaria, obj_tanque
- **Alcance configurável**: Diferentes alcances para cada navio
- **Seleção inteligente**: Escolhe inimigo mais próximo

### **✅ Sistema de Movimento**
- **Lancha**: Movimento simples com clique direito
- **Fragata**: Movimento para ataque + movimento básico
- **Orientação**: Navios se orientam na direção do movimento

### **✅ Sistema de Ataque**
- **Lancha**: Ataque automático a cada 2 segundos
- **Fragata**: Ataque com cooldown de 3 segundos
- **Rastreamento**: Mísseis seguem automaticamente o alvo

---

## 🔍 **MENSAGENS DE DEBUG**

### **Lancha Patrulha**
```
🚢 Lancha Patrulha criada - Sistema com sprite 'air' ativo
🎯 Mísseis: Azuis | Alcance: 250px
🚀 Lancha lançou míssil azul!
```

### **Fragata**
```
🚢 Fragata criada - Sistema com sprite 'air' ativo
🎯 Mísseis: Vermelhos | Alcance: 300px
🚀 Fragata lançou míssil vermelho!
```

---

## 🎮 **COMO FUNCIONA**

### **Lancha Patrulha**
1. **Detecção**: Procura inimigos no alcance de 400px
2. **Ataque**: Lança míssil azul a cada 2 segundos
3. **Movimento**: Míssil segue alvo automaticamente
4. **Dano**: 30 pontos aplicados no impacto

### **Fragata**
1. **Detecção**: Procura inimigos no alcance de 400px
2. **Movimento**: Move para o alvo se necessário
3. **Ataque**: Lança míssil vermelho a cada 3 segundos
4. **Dano**: 40 pontos aplicados no impacto

---

## 📝 **STATUS**

✅ **SISTEMA UNIFICADO COMPLETO**
- Lancha Patrulha reescrita
- Fragata reescrita
- Configurações otimizadas
- Sprite "air" implementado
- Cores diferenciadas
- Sem erros de linting
- Pronto para teste

---

**Data da Implementação**: Janeiro 2025  
**Desenvolvedor**: Assistente AI  
**Status**: ✅ CONCLUÍDO - SISTEMA UNIFICADO IMPLEMENTADO
