# CORREÇÃO: LANCHA PATRULHA v5.0 - SISTEMA SIMPLES COMO F-5

## ✅ **SISTEMA SIMPLIFICADO IMPLEMENTADO CONFORME SOLICITADO**

### 🎯 **O QUE FOI REMOVIDO:**
- ❌ Sistema de combustível
- ❌ Sistema de munição complexo
- ❌ Sistema de dano estrutural
- ❌ Alertas de recursos
- ❌ Interface complexa de recursos

### ✅ **O QUE FOI MANTIDO (CONFORME PEDIDO):**
- ✅ **Círculo verde de seleção** (como F-5)
- ✅ **Sistema de patrulha funcional** (tecla K)
- ✅ **Status básico** (Estado, Modo, HP)
- ✅ **Controles simples** (P, O, K, L)
- ✅ **Visual como F-5**

### 🚀 **SISTEMA ATUAL v5.0:**

#### **1. VISUAL COMO F-5:**
- **Círculo verde** quando selecionada
- **Cor amarela** quando selecionada
- **Círculo de radar** (vermelho/cinza)
- **Linhas de movimento** e patrulha

#### **2. SISTEMA DE PATRULHA:**
- **Tecla "K"** para modo patrulha
- **Clique esquerdo** para adicionar pontos
- **Clique direito** para confirmar patrulha
- **Patrulha contínua** entre pontos

#### **3. CONTROLES SIMPLES:**
- **P** = Modo passivo
- **O** = Modo ataque
- **K** = Modo patrulha
- **L** = Parar movimento

#### **4. STATUS BÁSICO:**
- **Estado**: Parado, Movendo, Atacando, Patrulhando
- **Modo**: Ataque (vermelho) ou Passivo (cinza)
- **HP**: Vida atual/máxima
- **Patrulha**: Ponto atual/total (quando patrulhando)

### 🎮 **COMO USAR:**

#### **TESTE 1 - SELEÇÃO:**
1. **Clique esquerdo** na lancha
2. **Resultado**: Lancha fica amarela com círculo verde

#### **TESTE 2 - MOVIMENTO:**
1. **Com lancha selecionada**, clique direito em outro lugar
2. **Resultado**: Lancha se move com linha amarela

#### **TESTE 3 - PATRULHA:**
1. **Com lancha selecionada**, pressione **"K"**
2. **Clique esquerdo** em vários pontos → Linha amarela
3. **Clique direito** → Inicia patrulha com linha azul
4. **Lancha patrulha** automaticamente entre os pontos

### 📋 **ARQUIVOS ATUALIZADOS:**

#### **1. `Create_0.gml` - Sistema Básico:**
```gml
// === SISTEMA DE PATRULHA (COMO F-5) ===
modo_definicao_patrulha = false;
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;

// === SISTEMA DE SELEÇÃO ===
selecionado = false;
image_blend = make_color_rgb(100, 150, 255);  // Cor normal azul
```

#### **2. `Step_0.gml` - Sistema de Patrulha:**
```gml
// ✅ SISTEMA DE PATRULHA COMO F-5
if (keyboard_check_pressed(ord("K"))) {
    modo_definicao_patrulha = !modo_definicao_patrulha;
    if (modo_definicao_patrulha) {
        ds_list_clear(pontos_patrulha);
        show_debug_message("🎯 Lancha - Modo PATRULHA: Clique esquerdo para adicionar pontos, direito para confirmar");
    }
}

// ✅ ADICIONAR PONTOS DE PATRULHA
if (modo_definicao_patrulha && mouse_check_button_pressed(mb_left)) {
    var _coords = global.scr_mouse_to_world();
    ds_list_add(pontos_patrulha, [_coords[0], _coords[1]]);
    show_debug_message("📍 Ponto de patrulha adicionado: (" + string(_coords[0]) + ", " + string(_coords[1]) + ")");
}

// ✅ CONFIRMAR PATRULHA
if (modo_definicao_patrulha && mouse_check_button_pressed(mb_right)) {
    modo_definicao_patrulha = false;
    if (ds_list_size(pontos_patrulha) > 1) {
        estado = "patrulhando";
        indice_patrulha_atual = 0;
        show_debug_message("🔄 Patrulha iniciada com " + string(ds_list_size(pontos_patrulha)) + " pontos!");
    }
}
```

#### **3. `Draw_GUI_0.gml` - Interface Simples:**
```gml
draw_text(_box_x + 15, y_pos, "🚢 LANCHA PATRULHA v5.0");
y_pos += _line_height;
draw_text(_box_x + 15, y_pos, "Estado: " + _estado_texto);
y_pos += _line_height;
draw_text(_box_x + 15, y_pos, "Modo: " + _modo_texto);
y_pos += _line_height;
draw_text(_box_x + 15, y_pos, "HP: " + _hp_texto);
if (_patrulha_texto != "") {
    y_pos += _line_height;
    draw_text(_box_x + 15, y_pos, _patrulha_texto);
}
```

### 🎯 **RESULTADO FINAL:**

#### **ANTES (v6.0 com recursos):**
- ❌ Sistema complexo de combustível
- ❌ Sistema complexo de munição
- ❌ Alertas desnecessários
- ❌ Interface confusa

#### **DEPOIS (v5.0 simplificado):**
- ✅ **Sistema simples** como F-5
- ✅ **Patrulha funcional** com tecla K
- ✅ **Círculo verde** de seleção
- ✅ **Status básico** claro
- ✅ **Controles simples** e intuitivos
- ✅ **Visual limpo** e funcional

### 🧪 **TESTE COMPLETO:**

1. **Execute o jogo**
2. **Clique esquerdo** na lancha → Deve ficar amarela com círculo verde
3. **Pressione "K"** → Console deve mostrar "Modo PATRULHA"
4. **Clique esquerdo** em vários pontos → Deve desenhar linha amarela
5. **Clique direito** → Deve iniciar patrulha com linha azul
6. **Lancha patrulha** automaticamente entre os pontos

**A lancha agora funciona exatamente como você pediu - sistema simples com patrulha funcional como o F-5!** 🎉

---
*Sistema v5.0 simplificado conforme solicitado*
*Sem combustível, sem recursos complexos - apenas o essencial*
