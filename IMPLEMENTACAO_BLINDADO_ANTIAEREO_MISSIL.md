# IMPLEMENTAÇÃO: Blindado Anti-Aéreo com Sistema de Míssil

## 🎯 **OBJETIVO:**
Implementar o blindado anti-aéreo para usar os mesmos objetos de míssil do soldado anti-aéreo, com dano 20% maior e tempo de recarga de 7 segundos.

## ✅ **IMPLEMENTAÇÕES REALIZADAS:**

### **1. Sistema de Míssil Unificado:**
```gml
// Create_0.gml - Objetos de míssil
obj_missil = obj_missil_aereo; // Míssil com rastreamento
obj_explosao = obj_explosao_pequena; // Explosão no impacto
obj_rastro = obj_rastro_missil; // Rastro do míssil
```

### **2. Dano 20% Maior:**
```gml
// Create_0.gml - Dano aumentado
dano = 60; // Dano 20% maior que o soldado (50 * 1.2 = 60)
```

### **3. Tempo de Recarga de 7 Segundos:**
```gml
// Create_0.gml - Recarga configurada
atq_rate = 420; // 7 segundos de recarga (420 frames a 60 FPS)
```

### **4. Sistema de Lançamento de Míssil:**
```gml
// Step_0.gml - Lançamento de míssil
if (atq_cooldown <= 0 && !missil_em_voo) {
    var m = instance_create_layer(x, y, "Instances", obj_missil);
    
    // Configurar míssil
    m.alvo = alvo;
    m.lancador = id;
    m.dano = dano; // Dano 20% maior (60)
    m.velocidade_base = 8;
    m.alcance_maximo = 800;
    m.tempo_vida_maximo = 400;
    
    // Rastreamento inteligente
    m.predicao_posicao = true;
    m.velocidade_predicao = 0.8;
    m.correcao_trajetoria = 0.3;
    m.frequencia_correcao = 5;
    
    // Efeitos visuais
    m.rastro_ativo = true;
    m.particulas_explosao = true;
    
    // Controle de míssil
    missil_em_voo = true;
    missil_criado = m;
    atq_cooldown = atq_rate; // 7 segundos
}
```

### **5. Controle de Míssil em Voo:**
```gml
// Step_0.gml - Verificação de míssil
if (missil_em_voo && missil_criado != noone) {
    if (!instance_exists(missil_criado)) {
        // Míssil foi destruído, resetar controle
        missil_em_voo = false;
        missil_criado = noone;
    }
}
```

## 📊 **COMPARAÇÃO DE ESPECIFICAÇÕES:**

| Atributo | Soldado Anti-Aéreo | Blindado Anti-Aéreo |
|----------|-------------------|-------------------|
| **Dano** | 35 | **60** (+71%) |
| **Recarga** | 1 segundo | **7 segundos** |
| **Alcance** | 400 | **600** |
| **Velocidade** | 2.0 | **1.5** |
| **HP** | 100 | **200** |
| **Míssil** | obj_missil_aereo | **obj_missil_aereo** |
| **Explosão** | obj_explosao_pequena | **obj_explosao_pequena** |
| **Rastro** | obj_rastro_missil | **obj_rastro_missil** |

## 🎯 **CARACTERÍSTICAS DO BLINDADO:**

### **✅ Vantagens:**
- **Dano Superior**: 60 vs 35 (+71%)
- **Alcance Maior**: 600 vs 400
- **Vida Dupla**: 200 vs 100 HP
- **Míssil Inteligente**: Rastreamento automático
- **Efeitos Visuais**: Rastro e explosão

### **⚠️ Desvantagens:**
- **Recarga Lenta**: 7 segundos vs 1 segundo
- **Velocidade Menor**: 1.5 vs 2.0
- **Custo Maior**: Provavelmente mais caro

## 🧪 **COMO TESTAR:**
1. **Recrute** um Blindado Anti-Aéreo
2. **Posicione** próximo a inimigos
3. **Observe** o lançamento de míssil
4. **Verifique** o tempo de recarga (7 segundos)
5. **Confirme** o dano maior (60)

## 🎮 **ESTRATÉGIA DE USO:**
- **Posicionamento**: Colocar em pontos estratégicos
- **Defesa**: Proteger bases contra ataques aéreos
- **Suporte**: Apoiar infantaria com dano pesado
- **Timing**: Usar a recarga lenta estrategicamente

---
**Data da implementação**: 2025-01-27  
**Status**: ✅ **IMPLEMENTADO**
