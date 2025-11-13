# 🗺️ **SISTEMA DE TERRENO E DESVIO — IMPLEMENTADO**

## ✅ **MODIFICAÇÕES REALIZADAS**

### **1. Scripts criados (2 novos)**

#### **`scr_unidade_pode_terreno.gml`**
- Verifica se uma unidade pode estar em um terreno específico
- Usa array `terrenos_permitidos` da unidade
- Fallback automático baseado no tipo de unidade:
  - **Navios/Submarinos**: Só `TERRAIN.AGUA`
  - **Tanques**: `TERRAIN.CAMPO` + `TERRAIN.DESERTO` (não floresta)
  - **Infantaria/Outros**: `TERRAIN.CAMPO` + `TERRAIN.FLORESTA` + `TERRAIN.DESERTO`

#### **`scr_visualizar_terreno_ahead.gml`** (opcional)
- Visualização antecipada de terreno à frente
- Retorna `{pode_passar: bool, terreno_ahead: enum, distancia_segura: real}`
- Verifica 5 pontos à frente

---

### **2. Variável adicionada a TODOS os objetos de unidade**

**`terrenos_permitidos`** no `Create_0.gml`:

```gml
// === TERRENOS PERMITIDOS ===
terrenos_permitidos = [TERRAIN.CAMPO, TERRAIN.FLORESTA, TERRAIN.DESERTO];
```

#### **Unidades modificadas:**
- ✅ `obj_infantaria` — `[CAMPO, FLORESTA, DESERTO]`
- ✅ `obj_tanque` — `[CAMPO, DESERTO]` (não floresta)
- ✅ `obj_lancha_patrulha` — `[AGUA]`
- ✅ `obj_submarino_base` — `[AGUA]`
- ✅ `obj_navio_base` — `[AGUA]`
- ✅ `obj_navio_transporte` — `[AGUA]`
- ✅ Todos herdam de navios (Constellation, Independence, RonaldReagan) — `[AGUA]`

---

## 📋 **PRÓXIMAS ETAPAS (Opcional)**

### **3. Modificar movimento nos objetos**

Para ativar a verificação de terreno, adicionar nos Step events:

#### **`obj_infantaria/Step_0.gml`** (no case "movendo")
```gml
// ✅ NOVO: Verificar terreno antes de mover
var _proxima_x = x + lengthdir_x(_vel_normalizada, _direcao_final);
var _proxima_y = y + lengthdir_y(_vel_normalizada, _direcao_final);

if (!scr_unidade_pode_terreno(id, _proxima_x, _proxima_y)) {
    // Terreno não permitido - parar ou desviar
    estado = "parado";
}
```

#### **`obj_tanque/Step_0.gml`**
Mesma lógica do infantaria

#### **`obj_lancha_patrulha/Step_0.gml`**
```gml
// Verificar se ainda está em água
if (!scr_unidade_pode_terreno(id, x, y)) {
    // Procurar água próxima
    destino_x = x + lengthdir_x(100, random(360));
    destino_y = y + lengthdir_y(100, random(360));
}
```

---

## 🎮 **COMO USAR**

### **Verificar se unidade pode estar em uma posição:**
```gml
if (scr_unidade_pode_terreno(unidade_id, pos_x, pos_y)) {
    // Pode estar aqui
}
```

### **Visualizar terreno à frente:**
```gml
var _viz = scr_visualizar_terreno_ahead(unidade_id, direcao, 100);
if (!_viz.pode_passar) {
    show_debug_message("Terreno impedindo: " + string(_viz.terreno_ahead));
}
```

### **Modificar terrenos permitidos de uma unidade:**
```gml
unidade.terrenos_permitidos = [TERRAIN.CAMPO]; // Só campo
```

---

## 📊 **RESUMO**

| Elemento | Status | Arquivo |
|----------|--------|---------|
| Sistema de verificação | ✅ Pronto | `scr_unidade_pode_terreno.gml` |
| Visualização antecipada | ✅ Pronto | `scr_visualizar_terreno_ahead.gml` |
| Infantaria | ✅ `[CAMPO, FLORESTA, DESERTO]` | `obj_infantaria/Create_0.gml` |
| Tanque | ✅ `[CAMPO, DESERTO]` | `obj_tanque/Create_0.gml` |
| Navios | ✅ `[AGUA]` | Todos os navios |
| Movimento com check | ⏳ Opcional | Step events |

---

## 🔧 **IMPLEMENTAÇÃO RÁPIDA**

Se quer ativar agora, adicione isto no movimento de cada unidade:

```gml
// Verificar terreno antes de mover
if (scr_unidade_pode_terreno(id, nova_pos_x, nova_pos_y)) {
    // Mover
    x = nova_pos_x;
    y = nova_pos_y;
} else {
    // Parar
    estado = "parado";
}
```

---

✨ **Sistema de terreno e desvio implementado com modificações mínimas!**

