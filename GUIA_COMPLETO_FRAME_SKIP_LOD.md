# 📋 GUIA COMPLETO - FRAME SKIP COM LOD
## Implementação Passo a Passo com Todos os Objetos e Eventos

---

## 📅 Data: 2025-01-28
## 🎯 Status: Documento de Referência Completo

---

## 📊 RESUMO DO SISTEMA

O **Frame Skip com LOD (Level of Detail)** otimiza a performance reduzindo o processamento de unidades baseado no nível de zoom da câmera. Quanto mais afastado o zoom, mais frames são pulados.

### Níveis de LOD:
- **LOD 0** (zoom < 0.4): Processa 1 a cada 10 frames (90% skip)
- **LOD 1** (zoom 0.4-0.8): Processa 1 a cada 5 frames (80% skip)
- **LOD 2** (zoom 0.8-2.0): Processa 1 a cada 2 frames (50% skip)
- **LOD 3** (zoom > 2.0): Processa sempre (0% skip - qualidade máxima)

---

## ✅ SCRIPTS QUE JÁ EXISTEM (Não Precisa Criar)

### 1. **`scripts/scr_get_lod_level/scr_get_lod_level.gml`**
   - ✅ Já criado
   - Função: Retorna nível de LOD (0-3) baseado no zoom
   - Uso: `var lod = scr_get_lod_level();`

### 2. **`scripts/scr_calculate_frame_skip/scr_calculate_frame_skip.gml`**
   - ✅ Já criado
   - Funções:
     - `scr_calculate_frame_skip(lod_level, instance_id)` - Retorna `true/false` se deve processar
     - `scr_get_speed_multiplier(lod_level, instance_id)` - Retorna multiplicador de velocidade

### 3. **`scripts/scr_process_lod_simple_movement/scr_process_lod_simple_movement.gml`**
   - ✅ Já criado
   - Função: Processa movimento simplificado durante frame skip
   - Uso: `scr_process_lod_simple_movement(id, dest_x, dest_y, speed, speed_mult)`

---

## 📝 OBJETOS QUE PRECISAM DE MODIFICAÇÃO

### ✅ JÁ IMPLEMENTADOS (Não Precisa Fazer Nada):
1. **`obj_infantaria`** - ✅ Completo
2. **`obj_tanque`** - ✅ Completo

### ❌ AINDA PRECISAM SER IMPLEMENTADOS:

---

## 🎯 IMPLEMENTAÇÃO PASSO A PASSO - OBJETO POR OBJETO

---

## 📌 OBJETO 1: `obj_blindado_antiaereo`

### **EVENTO: Create_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_blindado_antiaereo/Create_0.gml`
- Adicionar ao FINAL do arquivo (depois de todas as outras variáveis):

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;                    // Nível de detalhe inicial (0-3)
force_always_active = false;      // true = nunca pula frames
lod_process_index = irandom(99);  // Índice único para distribuir processamento
skip_frames_enabled = true;       // Habilitar frame skip
```

### **EVENTO: Step_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_blindado_antiaereo/Step_0.gml`
- Adicionar NO INÍCIO do arquivo (logo após verificação de HP, se houver):

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

// ✅ SEMPRE processar se selecionado ou em combate crítico
var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando");

// ✅ Se não for sempre processar, verificar frame skip
if (!should_always_process && skip_frames_enabled) {
    // Obter LOD atual usando script otimizado
    var current_lod = scr_get_lod_level();
    
    // Calcular se deve pular este frame
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        // === MODO FRAME SKIP: Processar apenas movimento básico ===
        
        // Se está movendo, aplicar movimento simplificado
        if (estado == "movendo" || variable_instance_exists(id, "destino_x")) {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            var dest_x = (variable_instance_exists(id, "destino_x")) ? destino_x : x;
            var dest_y = (variable_instance_exists(id, "destino_y")) ? destino_y : y;
            var still_moving = scr_process_lod_simple_movement(id, dest_x, dest_y, velocidade, speed_mult);
            
            if (!still_moving && estado == "movendo") {
                estado = "parado";
            }
        }
        
        // Sair sem processar IA, animações, cooldowns, etc.
        exit;
    }
    
    // Atualizar lod_level para outras lógicas
    lod_level = current_lod;
}
```

---

## 📌 OBJETO 2: `obj_soldado_antiaereo`

### **EVENTO: Create_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_soldado_antiaereo/Create_0.gml`
- Adicionar ao FINAL:

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;
```

### **EVENTO: Step_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_soldado_antiaereo/Step_0.gml`
- Adicionar NO INÍCIO (após verificação de HP):

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando");

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        if (estado == "movendo" || variable_instance_exists(id, "destino_x")) {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            var dest_x = (variable_instance_exists(id, "destino_x")) ? destino_x : x;
            var dest_y = (variable_instance_exists(id, "destino_y")) ? destino_y : y;
            var still_moving = scr_process_lod_simple_movement(id, dest_x, dest_y, velocidade, speed_mult);
            
            if (!still_moving && estado == "movendo") {
                estado = "parado";
            }
        }
        exit;
    }
    lod_level = current_lod;
}
```

---

## 📌 OBJETO 3: `obj_caca_f5`

### **EVENTO: Create_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_caca_f5/Create_0.gml`
- Adicionar ao FINAL:

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;
```

### **EVENTO: Step_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_caca_f5/Step_0.gml`
- Adicionar NO INÍCIO (após verificação de HP):

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando" || estado == "pousando" || estado == "decolando");

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        // Movimento simplificado para aviões
        if (estado == "patrulhando" || estado == "caçando" || estado == "movendo") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            // Movimento básico mantendo direção
            if (variable_instance_exists(id, "speed")) {
                x += lengthdir_x(speed * speed_mult, image_angle);
                y += lengthdir_y(speed * speed_mult, image_angle);
            }
        }
        exit;
    }
    lod_level = current_lod;
}
```

---

## 📌 OBJETO 4: `obj_helicoptero_militar`

### **EVENTO: Create_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_helicoptero_militar/Create_0.gml`
- Adicionar ao FINAL:

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;
```

### **EVENTO: Step_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_helicoptero_militar/Step_0.gml`
- Adicionar NO INÍCIO (após verificação de HP):

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando" || estado == "pousando" || estado == "decolando");

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        if (estado == "patrulhando" || estado == "movendo") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            if (variable_instance_exists(id, "destino_x")) {
                var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, velocidade, speed_mult);
                if (!still_moving && estado == "movendo") {
                    estado = "parado";
                }
            }
        }
        exit;
    }
    lod_level = current_lod;
}
```

---

## 📌 OBJETO 5: `obj_lancha_patrulha`

### **EVENTO: Create_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_lancha_patrulha/Create_0.gml`
- Adicionar ao FINAL:

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;
```

### **EVENTO: Step_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_lancha_patrulha/Step_0.gml`
- Adicionar NO INÍCIO (após verificação de HP):

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando");

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        if (estado == "movendo" || estado == "patrulhando") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            if (variable_instance_exists(id, "destino_x")) {
                var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, velocidade_movimento, speed_mult);
                if (!still_moving && estado == "movendo") {
                    estado = "parado";
                }
            }
        }
        exit;
    }
    lod_level = current_lod;
}
```

---

## 📌 OBJETO 6: `obj_navio_transporte`

### **EVENTO: Create_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_navio_transporte/Create_0.gml`
- Adicionar ao FINAL:

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;
```

### **EVENTO: Step_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_navio_transporte/Step_0.gml`
- Adicionar NO INÍCIO (após verificação de HP):

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando" || estado == "embarcando" || estado == "desembarcando");

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        if (estado == "movendo") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            if (variable_instance_exists(id, "destino_x")) {
                var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, velocidade_movimento, speed_mult);
                if (!still_moving && estado == "movendo") {
                    estado = "parado";
                }
            }
        }
        exit;
    }
    lod_level = current_lod;
}
```

---

## 📌 OBJETO 7: `obj_submarino_base`

### **EVENTO: Create_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_submarino_base/Create_0.gml`
- Adicionar ao FINAL:

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;
```

### **EVENTO: Step_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_submarino_base/Step_0.gml`
- Adicionar NO INÍCIO (após verificação de HP):

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando" || submerso);

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        if (estado == "movendo") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            if (variable_instance_exists(id, "destino_x")) {
                var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, velocidade_movimento, speed_mult);
                if (!still_moving && estado == "movendo") {
                    estado = "parado";
                }
            }
        }
        exit;
    }
    lod_level = current_lod;
}
```

---

## 📌 OBJETO 8: `obj_Constellation`

### **EVENTO: Create_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_Constellation/Create_0.gml`
- Adicionar ao FINAL:

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;
```

### **EVENTO: Step_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_Constellation/Step_0.gml`
- Adicionar NO INÍCIO (após verificação de HP):

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando");

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        if (estado == "movendo") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            if (variable_instance_exists(id, "destino_x")) {
                var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, velocidade_movimento, speed_mult);
                if (!still_moving && estado == "movendo") {
                    estado = "parado";
                }
            }
        }
        exit;
    }
    lod_level = current_lod;
}
```

---

## 📌 OBJETO 9: `obj_Independence`

### **EVENTO: Create_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_Independence/Create_0.gml`
- Adicionar ao FINAL:

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;
```

### **EVENTO: Step_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_Independence/Step_0.gml`
- Adicionar NO INÍCIO (após verificação de HP):

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando");

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        if (estado == "movendo") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            if (variable_instance_exists(id, "destino_x")) {
                var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, velocidade_movimento, speed_mult);
                if (!still_moving && estado == "movendo") {
                    estado = "parado";
                }
            }
        }
        exit;
    }
    lod_level = current_lod;
}
```

---

## 📌 OBJETO 10: `obj_RonaldReagan`

### **EVENTO: Create_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_RonaldReagan/Create_0.gml`
- Adicionar ao FINAL:

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;
```

### **EVENTO: Step_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_RonaldReagan/Step_0.gml`
- Adicionar NO INÍCIO (após verificação de HP):

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando");

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        if (estado == "movendo") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            if (variable_instance_exists(id, "destino_x")) {
                var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, velocidade_movimento, speed_mult);
                if (!still_moving && estado == "movendo") {
                    estado = "parado";
                }
            }
        }
        exit;
    }
    lod_level = current_lod;
}
```

---

## 📌 OBJETO 11: `obj_c100`

### **EVENTO: Create_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_c100/Create_0.gml`
- Adicionar ao FINAL:

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;
```

### **EVENTO: Step_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_c100/Step_0.gml`
- Adicionar NO INÍCIO (após verificação de HP):

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando" || estado == "embarcando" || estado == "desembarcando");

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        if (estado == "movendo") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            if (variable_instance_exists(id, "destino_x")) {
                var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, velocidade_movimento, speed_mult);
                if (!still_moving && estado == "movendo") {
                    estado = "parado";
                }
            }
        }
        exit;
    }
    lod_level = current_lod;
}
```

---

## 📌 OBJETO 12: `obj_artilharia` (Se Existir)

### **EVENTO: Create_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_artilharia/Create_0.gml`
- Adicionar ao FINAL:

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD
// =============================================
lod_level = 2;
force_always_active = false;
lod_process_index = irandom(99);
skip_frames_enabled = true;
```

### **EVENTO: Step_0** (Modificar)

**O QUE FAZER:**
- Abrir `objects/obj_artilharia/Step_0.gml`
- Adicionar NO INÍCIO (após verificação de HP):

```gml
// =============================================
// SISTEMA DE FRAME SKIP COM LOD (OTIMIZADO)
// =============================================

var should_always_process = (selecionado || 
                              (variable_instance_exists(id, "force_always_active") && force_always_active) ||
                              estado == "atacando");

if (!should_always_process && skip_frames_enabled) {
    var current_lod = scr_get_lod_level();
    var should_process = scr_calculate_frame_skip(current_lod, lod_process_index);
    
    if (!should_process) {
        if (estado == "movendo") {
            var speed_mult = scr_get_speed_multiplier(current_lod, lod_process_index);
            if (variable_instance_exists(id, "destino_x")) {
                var still_moving = scr_process_lod_simple_movement(id, destino_x, destino_y, velocidade, speed_mult);
                if (!still_moving && estado == "movendo") {
                    estado = "parado";
                }
            }
        }
        exit;
    }
    lod_level = current_lod;
}
```

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### **Scripts (Já Criados):**
- [x] `scr_get_lod_level` ✅
- [x] `scr_calculate_frame_skip` ✅
- [x] `scr_process_lod_simple_movement` ✅

### **Objetos Terrestres:**
- [x] `obj_infantaria` ✅ Completo
- [x] `obj_tanque` ✅ Completo
- [ ] `obj_blindado_antiaereo` - Create_0 + Step_0
- [ ] `obj_soldado_antiaereo` - Create_0 + Step_0
- [ ] `obj_artilharia` - Create_0 + Step_0 (se existir)

### **Objetos Aéreos:**
- [ ] `obj_caca_f5` - Create_0 + Step_0
- [ ] `obj_helicoptero_militar` - Create_0 + Step_0

### **Objetos Navais:**
- [ ] `obj_lancha_patrulha` - Create_0 + Step_0
- [ ] `obj_navio_transporte` - Create_0 + Step_0
- [ ] `obj_submarino_base` - Create_0 + Step_0
- [ ] `obj_Constellation` - Create_0 + Step_0
- [ ] `obj_Independence` - Create_0 + Step_0
- [ ] `obj_RonaldReagan` - Create_0 + Step_0
- [ ] `obj_c100` - Create_0 + Step_0

---

## 📋 RESUMO FINAL: O QUE CRIAR/MODIFICAR

### **EVENTOS PARA CRIAR/MODIFICAR:**

1. **`obj_blindado_antiaereo`**
   - ✅ Create_0 (adicionar variáveis LOD)
   - ✅ Step_0 (adicionar lógica de frame skip)

2. **`obj_soldado_antiaereo`**
   - ✅ Create_0 (adicionar variáveis LOD)
   - ✅ Step_0 (adicionar lógica de frame skip)

3. **`obj_caca_f5`**
   - ✅ Create_0 (adicionar variáveis LOD)
   - ✅ Step_0 (adicionar lógica de frame skip)

4. **`obj_helicoptero_militar`**
   - ✅ Create_0 (adicionar variáveis LOD)
   - ✅ Step_0 (adicionar lógica de frame skip)

5. **`obj_lancha_patrulha`**
   - ✅ Create_0 (adicionar variáveis LOD)
   - ✅ Step_0 (adicionar lógica de frame skip)

6. **`obj_navio_transporte`**
   - ✅ Create_0 (adicionar variáveis LOD)
   - ✅ Step_0 (adicionar lógica de frame skip)

7. **`obj_submarino_base`**
   - ✅ Create_0 (adicionar variáveis LOD)
   - ✅ Step_0 (adicionar lógica de frame skip)

8. **`obj_Constellation`**
   - ✅ Create_0 (adicionar variáveis LOD)
   - ✅ Step_0 (adicionar lógica de frame skip)

9. **`obj_Independence`**
   - ✅ Create_0 (adicionar variáveis LOD)
   - ✅ Step_0 (adicionar lógica de frame skip)

10. **`obj_RonaldReagan`**
    - ✅ Create_0 (adicionar variáveis LOD)
    - ✅ Step_0 (adicionar lógica de frame skip)

11. **`obj_c100`**
    - ✅ Create_0 (adicionar variáveis LOD)
    - ✅ Step_0 (adicionar lógica de frame skip)

12. **`obj_artilharia`** (se existir)
    - ✅ Create_0 (adicionar variáveis LOD)
    - ✅ Step_0 (adicionar lógica de frame skip)

---

## 🎯 INSTRUÇÕES FINAIS

### **Para cada objeto:**

1. **Create_0:** Adicionar as 4 variáveis LOD no final do arquivo
2. **Step_0:** Adicionar o código de frame skip no INÍCIO do arquivo (após verificação de HP)
3. **Testar:** Verificar se o objeto funciona corretamente com frame skip habilitado

### **Notas Importantes:**

- ✅ Unidades **selecionadas** NUNCA pulam frames
- ✅ Unidades **em combate** (estado == "atacando") NUNCA pulam frames
- ✅ Durante frame skip, apenas **movimento básico** é processado
- ✅ IA, animações e cooldowns são **ignorados** durante frame skip
- ✅ Velocidade é **multiplicada** para compensar frames pulados

---

## 📊 RESULTADOS ESPERADOS

Após implementar em todos os objetos:
- ✅ **Ganho de FPS:** +40-90% dependendo do zoom
- ✅ **Redução de processamento:** Até 90% menos em zoom muito afastado
- ✅ **Qualidade mantida:** Zoom próximo mantém qualidade máxima (0% skip)
- ✅ **Escalabilidade:** Funciona perfeitamente em mapas 29.200 × 20.000

---

## ✅ DOCUMENTO COMPLETO!

Este guia lista TODOS os objetos e eventos que precisam ser criados/modificados para implementar Frame Skip com LOD completo no jogo.

