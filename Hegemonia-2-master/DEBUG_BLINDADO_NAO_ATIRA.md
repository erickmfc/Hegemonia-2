# DEBUG: Blindado Anti-Aéreo Não Atira

## 🚨 **PROBLEMA IDENTIFICADO:**
- **Sintoma**: Blindado anti-aéreo não atira
- **Necessidade**: Debug para identificar onde está o problema

## ✅ **DEBUG IMPLEMENTADO:**

### **1. Debug de Detecção de Alvos:**
```gml
// Buscar inimigos terrestres primeiro (obj_inimigo)
alvo = instance_nearest(x, y, obj_inimigo);
global.debug_log("Blindado Anti-Aéreo: Buscando alvo terrestre - Encontrado: " + string(alvo));

// Se não encontrou inimigo terrestre, buscar aéreos (se existirem)
if (alvo == noone) {
    global.debug_log("Blindado Anti-Aéreo: Nenhum alvo terrestre encontrado, buscando aéreos...");
    // Tentar buscar aviões se existirem
    if (object_exists(obj_aviao)) {
        alvo = instance_nearest(x, y, obj_aviao);
        global.debug_log("Blindado Anti-Aéreo: Buscando avião - Encontrado: " + string(alvo));
    }
    // Tentar buscar drones se existirem
    if (alvo == noone && object_exists(obj_drone)) {
        alvo = instance_nearest(x, y, obj_drone);
        global.debug_log("Blindado Anti-Aéreo: Buscando drone - Encontrado: " + string(alvo));
    }
}

if (alvo != noone && point_distance(x, y, alvo.x, alvo.y) <= alcance_visao) {
    estado = "atacando";
    global.debug_log("Blindado Anti-Aéreo detectou alvo! Distância: " + string(point_distance(x, y, alvo.x, alvo.y)));
} else {
    global.debug_log("Blindado Anti-Aéreo: Nenhum alvo no alcance. Alvo: " + string(alvo) + ", Alcance: " + string(alcance_visao));
}
```

### **2. Debug de Ataque:**
```gml
} else if (alvo != noone && instance_exists(alvo)) {
    var dist_alvo = point_distance(x, y, alvo.x, alvo.y);
    global.debug_log("Blindado Anti-Aéreo: Atacando alvo! Distância: " + string(dist_alvo) + ", Alcance tiro: " + string(alcance_tiro));
    
    if (dist_alvo <= alcance_tiro) {
        global.debug_log("Blindado Anti-Aéreo: Alvo no alcance de tiro!");
        // Atira se estiver no alcance
        global.debug_log("Blindado Anti-Aéreo: Cooldown atual: " + string(atq_cooldown));
        if (atq_cooldown <= 0) {
            global.debug_log("Blindado Anti-Aéreo: Iniciando disparo!");
```

## 🔍 **DIAGNÓSTICO IMPLEMENTADO:**

### **✅ Debug de Detecção:**
- Confirma se encontra alvos terrestres
- Verifica busca por alvos aéreos
- Mostra distância até o alvo
- Indica se alvo está no alcance de visão

### **✅ Debug de Ataque:**
- Confirma se está no estado "atacando"
- Mostra distância até o alvo
- Verifica se alvo está no alcance de tiro
- Mostra cooldown atual
- Confirma se disparo é iniciado

## 🧪 **COMO TESTAR:**
1. **Recrute** um Blindado Anti-Aéreo
2. **Posicione** próximo a inimigos
3. **Abra** o console de debug
4. **Observe** as mensagens de debug
5. **Identifique** onde o processo para

## 📋 **MENSAGENS DE DEBUG ESPERADAS:**
```
Blindado Anti-Aéreo: Buscando alvo terrestre - Encontrado: [ID]
Blindado Anti-Aéreo detectou alvo! Distância: 300
Blindado Anti-Aéreo: Atacando alvo! Distância: 300, Alcance tiro: 600
Blindado Anti-Aéreo: Alvo no alcance de tiro!
Blindado Anti-Aéreo: Cooldown atual: 0
Blindado Anti-Aéreo: Iniciando disparo!
Blindado Anti-Aéreo: Tiro específico criado!
```

## 🚨 **POSSÍVEIS PROBLEMAS:**
- **Nenhum alvo**: Não encontra inimigos
- **Alcance**: Alvo fora do alcance de visão
- **Cooldown**: Sempre em cooldown
- **Estado**: Não entra em estado "atacando"
- **Objeto**: `obj_anti` não existe

## 💡 **PRÓXIMOS PASSOS:**
1. **Testar** com debug ativo
2. **Verificar** mensagens no console
3. **Identificar** onde o processo para
4. **Corrigir** problema específico

---
**Data da implementação**: 2025-01-27  
**Status**: 🔍 **DEBUG IMPLEMENTADO**
