# IMPLEMENTAÇÃO: Blindado Anti-Aéreo com Objetos Específicos

## 🎯 **OBJETIVO:**
Implementar o blindado anti-aéreo usando objetos específicos (`obj_anti` e `obj_rastro_missil_1`) e torná-lo um bom atirador contra alvos terrestres e aéreos.

## ✅ **IMPLEMENTAÇÕES REALIZADAS:**

### **1. Create_0.gml - Objetos específicos:**
```gml
// === OBJETOS ESPECÍFICOS DO BLINDADO ===
obj_tiro_especifico = obj_anti; // Tiro específico do blindado
obj_rastro = obj_rastro_missil_1; // Rastro específico do blindado
```

### **2. Step_0.gml - Detecção melhorada de alvos:**
```gml
// =======================
// DETECÇÃO DE INIMIGOS (TERRESTRES E AÉREOS)
// =======================
// Buscar inimigos terrestres primeiro (obj_inimigo)
alvo = instance_nearest(x, y, obj_inimigo);

// Se não encontrou inimigo terrestre, buscar aéreos (se existirem)
if (alvo == noone) {
    // Tentar buscar aviões se existirem
    if (object_exists(obj_aviao)) {
        alvo = instance_nearest(x, y, obj_aviao);
    }
    // Tentar buscar drones se existirem
    if (alvo == noone && object_exists(obj_drone)) {
        alvo = instance_nearest(x, y, obj_drone);
    }
}
```

### **3. Step_0.gml - Sistema de tiro específico:**
```gml
// Atira se estiver no alcance
if (atq_cooldown <= 0) {
    var b = instance_create_layer(x, y, layer, obj_tiro_especifico);
    b.direction = point_direction(x, y, alvo.x, alvo.y);
    b.speed = 15;      // mais rápido que infantaria
    b.dano = dano;       // Usar dano definido (60)
    b.alvo = alvo;     // manter alvo
    b.image_blend = c_yellow; // cor amarela para diferenciar
}
```

### **4. Step_0.gml - Patrulha com detecção aérea:**
```gml
case "patrulhando":
    // Verificar se há inimigo próximo durante a patrulha (terrestres e aéreos)
    var inimigo_proximo = instance_nearest(x, y, obj_inimigo);
    
    // Se não encontrou inimigo terrestre, buscar aéreos
    if (inimigo_proximo == noone) {
        if (object_exists(obj_aviao)) {
            inimigo_proximo = instance_nearest(x, y, obj_aviao);
        }
        if (inimigo_proximo == noone && object_exists(obj_drone)) {
            inimigo_proximo = instance_nearest(x, y, obj_drone);
        }
    }
```

## 📊 **CARACTERÍSTICAS IMPLEMENTADAS:**

| Atributo | Valor | Descrição |
|----------|-------|-----------|
| **Projétil** | `obj_anti` | Tiro específico do blindado |
| **Rastro** | `obj_rastro_missil_1` | Rastro específico do blindado |
| **Dano** | 60 | 20% maior que soldado |
| **Velocidade do tiro** | 15 | Mais rápido que infantaria |
| **Alcance** | 600 | Alcance longo |
| **Alvos** | Terrestres + Aéreos | obj_inimigo, obj_aviao, obj_drone |

## 🎮 **FUNCIONALIDADES:**

### **✅ Detecção Inteligente:**
- **Prioridade**: Inimigos terrestres primeiro
- **Secundário**: Alvos aéreos se não houver terrestres
- **Alcance**: 700 pixels de detecção
- **Patrulha**: Detecta alvos durante patrulha

### **✅ Sistema de Tiro Específico:**
- **Projétil**: `obj_anti` exclusivo
- **Rastro**: `obj_rastro_missil_1` exclusivo
- **Som**: `som_anti` com controle de distância
- **Velocidade**: 15 (mais rápido)

### **✅ Combate Dual:**
- **Terrestres**: obj_inimigo (prioridade)
- **Aéreos**: obj_aviao, obj_drone
- **Versatilidade**: Ataca qualquer tipo de alvo

## 🧪 **COMO TESTAR:**
1. **Recrute** um Blindado Anti-Aéreo
2. **Posicione** próximo a inimigos terrestres
3. **Observe** o tiro específico (`obj_anti`)
4. **Verifique** o rastro específico (`obj_rastro_missil_1`)
5. **Teste** contra alvos aéreos (se existirem)

## 💡 **VANTAGENS:**
- **Objetos específicos**: `obj_anti` e `obj_rastro_missil_1`
- **Detecção dual**: Terrestres e aéreos
- **Bom atirador**: Velocidade e dano superiores
- **Versatilidade**: Ataca qualquer alvo

## 🔧 **DETALHES TÉCNICOS:**
- **`obj_anti`**: Projétil específico criado pelo usuário
- **`obj_rastro_missil_1`**: Rastro específico criado pelo usuário
- **Detecção**: Prioriza terrestres, depois aéreos
- **Performance**: Tiro mais rápido (speed = 15)

---
**Data da implementação**: 2025-01-27  
**Status**: ✅ **IMPLEMENTADO**
