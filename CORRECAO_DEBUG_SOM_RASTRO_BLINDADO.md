# CORREÇÃO: Debug para Som e Rastro do Blindado Anti-Aéreo

## 🚨 **PROBLEMA IDENTIFICADO:**
- **Sintoma**: Blindado atira do mesmo jeito que antes
- **Possível causa**: Som e rastro não estão sendo executados
- **Necessidade**: Debug para identificar o problema

## ✅ **CORREÇÕES IMPLEMENTADAS:**

### **1. Create_0.gml - Simplificação da referência do som:**
```gml
// === OBJETOS ESPECÍFICOS DO BLINDADO ===
obj_rastro = obj_rastro_missil_1; // Rastro específico do blindado
// som_impacto será usado diretamente como som_anti
```

### **2. Step_0.gml - Debug detalhado adicionado:**
```gml
// Debug de disparo
global.debug_log("Blindado Anti-Aéreo: Iniciando disparo!");
global.debug_log("Blindado Anti-Aéreo: Tiro criado!");

// Debug de som
if (volume_som > 0.1) {
    audio_play_sound(som_anti, volume_som, false, false);
    global.debug_log("[SOM] Blindado Anti-Aéreo disparou - Volume: " + string(volume_som) + " | Distância: " + string(dist_camera));
} else {
    global.debug_log("[SOM] Blindado Anti-Aéreo: Volume muito baixo (" + string(volume_som) + ") - Som não tocado");
}

// Debug de rastro
var rastro = instance_create_layer(x, y, layer, obj_rastro);
if (instance_exists(rastro)) {
    rastro.direction = b.direction;
    rastro.image_angle = b.direction;
    rastro.image_alpha = 0.6;
    rastro.image_scale = 1.2;
    global.debug_log("[RASTRO] Blindado Anti-Aéreo: Rastro criado!");
} else {
    global.debug_log("[RASTRO] Blindado Anti-Aéreo: ERRO - Rastro não foi criado!");
}
```

## 🔍 **DIAGNÓSTICO IMPLEMENTADO:**

### **✅ Debug de Disparo:**
- Confirma se o código de disparo está sendo executado
- Verifica se o tiro está sendo criado

### **✅ Debug de Som:**
- Mostra volume calculado
- Mostra distância da câmera
- Indica se som foi tocado ou não

### **✅ Debug de Rastro:**
- Confirma se rastro foi criado
- Indica erro se rastro não foi criado

## 🧪 **COMO TESTAR:**
1. **Recrute** um Blindado Anti-Aéreo
2. **Posicione** próximo a inimigos
3. **Abra** o console de debug
4. **Observe** as mensagens de debug
5. **Verifique** se som e rastro estão funcionando

## 📋 **MENSAGENS DE DEBUG ESPERADAS:**
```
Blindado Anti-Aéreo: Iniciando disparo!
Blindado Anti-Aéreo: Tiro criado!
[SOM] Blindado Anti-Aéreo disparou - Volume: 0.8 | Distância: 200
[RASTRO] Blindado Anti-Aéreo: Rastro criado!
```

## 🚨 **POSSÍVEIS PROBLEMAS:**
- **Som não toca**: Volume muito baixo ou som não existe
- **Rastro não aparece**: Objeto `obj_rastro_missil_1` não existe
- **Debug não aparece**: Código não está sendo executado

## 💡 **PRÓXIMOS PASSOS:**
1. **Testar** com debug ativo
2. **Verificar** mensagens no console
3. **Identificar** qual elemento não funciona
4. **Corrigir** problema específico

---
**Data da correção**: 2025-01-27  
**Status**: 🔍 **DEBUG IMPLEMENTADO**
