// Diagnóstico específico para problema de clique no quartel
// scr_diagnostico_quartel_clique

show_debug_message("=== DIAGNÓSTICO QUARTEL CLIQUE ===");

// === TESTE 1: VERIFICAR QUARTÉIS EXISTENTES ===
show_debug_message("=== TESTE 1: QUARTÉIS EXISTENTES ===");
var _quartel_count = instance_number(obj_quartel_marinha);
show_debug_message("Quartéis de marinha na sala: " + string(_quartel_count));

if (_quartel_count > 0) {
    with (obj_quartel_marinha) {
        show_debug_message("Quartel ID: " + string(id) + " | Pos: (" + string(x) + ", " + string(y) + ")");
    }
} else {
    show_debug_message("❌ NENHUM QUARTEL DE MARINHA ENCONTRADO!");
    show_debug_message("💡 Construa um quartel de marinha primeiro");
    exit;
}

// === TESTE 2: VERIFICAR SISTEMA DE MOUSE ===
show_debug_message("=== TESTE 2: SISTEMA DE MOUSE ===");
show_debug_message("Mouse X: " + string(mouse_x));
show_debug_message("Mouse Y: " + string(mouse_y));

// Verificar se há quartel na posição do mouse
var _quartel_no_mouse = instance_position(mouse_x, mouse_y, obj_quartel_marinha);
if (instance_exists(_quartel_no_mouse)) {
    show_debug_message("✅ Quartel encontrado na posição do mouse");
    show_debug_message("   Quartel ID: " + string(_quartel_no_mouse));
} else {
    show_debug_message("❌ Nenhum quartel na posição do mouse");
    show_debug_message("💡 Mova o mouse sobre um quartel e execute novamente");
}

// === TESTE 3: VERIFICAR OBJETO DO MENU ===
show_debug_message("=== TESTE 3: OBJETO DO MENU ===");
if (object_exists(obj_menu_recrutamento_marinha)) {
    show_debug_message("✅ obj_menu_recrutamento_marinha existe");
} else {
    show_debug_message("❌ obj_menu_recrutamento_marinha NÃO EXISTE!");
    show_debug_message("💡 Este é o problema! O objeto do menu não existe");
}

// === TESTE 4: TESTAR CRIAÇÃO MANUAL DO MENU ===
show_debug_message("=== TESTE 4: CRIAÇÃO MANUAL DO MENU ===");
if (object_exists(obj_menu_recrutamento_marinha)) {
    var _menu_teste = instance_create_layer(100, 100, "Instances", obj_menu_recrutamento_marinha);
    if (instance_exists(_menu_teste)) {
        show_debug_message("✅ Menu criado manualmente com sucesso!");
        show_debug_message("   Menu ID: " + string(_menu_teste));
        
        // Destruir menu de teste
        instance_destroy(_menu_teste);
        show_debug_message("✅ Menu de teste destruído");
    } else {
        show_debug_message("❌ Falha ao criar menu manualmente");
    }
}

// === TESTE 5: VERIFICAR LAYERS ===
show_debug_message("=== TESTE 5: VERIFICAR LAYERS ===");
if (layer_exists("Instances")) {
    show_debug_message("✅ Layer 'Instances' existe");
} else {
    show_debug_message("❌ Layer 'Instances' NÃO EXISTE!");
}

if (layer_exists("GUI")) {
    show_debug_message("✅ Layer 'GUI' existe");
} else {
    show_debug_message("❌ Layer 'GUI' NÃO EXISTE!");
}

// === TESTE 6: VERIFICAR CONFLITOS ===
show_debug_message("=== TESTE 6: VERIFICAR CONFLITOS ===");
var _obj_controlador = instance_number(obj_controlador_unidades);
var _obj_input = instance_number(obj_input_manager);
show_debug_message("obj_controlador_unidades: " + string(_obj_controlador));
show_debug_message("obj_input_manager: " + string(_obj_input));

// === TESTE 7: SIMULAR CLIQUE MANUAL ===
show_debug_message("=== TESTE 7: SIMULAR CLIQUE MANUAL ===");
if (instance_exists(_quartel_no_mouse)) {
    show_debug_message("Simulando clique no quartel ID: " + string(_quartel_no_mouse));
    
    // Simular as condições do Mouse_53
    show_debug_message("Verificando position_meeting...");
    var _position_ok = position_meeting(mouse_x, mouse_y, _quartel_no_mouse);
    show_debug_message("position_meeting resultado: " + string(_position_ok));
    
    if (_position_ok) {
        show_debug_message("✅ position_meeting OK - O clique deveria funcionar");
    } else {
        show_debug_message("❌ position_meeting FALHOU - Este é o problema!");
    }
}

// === TESTE 8: VERIFICAR VARIÁVEIS GLOBAIS ===
show_debug_message("=== TESTE 8: VARIÁVEIS GLOBAIS ===");
show_debug_message("global.menu_recrutamento_aberto: " + string(global.menu_recrutamento_aberto));
show_debug_message("global.modo_construcao: " + string(global.modo_construcao));
show_debug_message("global.construindo_agora: " + string(global.construindo_agora));

// === RESULTADO FINAL ===
show_debug_message("=== RESULTADO DO DIAGNÓSTICO ===");
if (object_exists(obj_menu_recrutamento_marinha) && _quartel_count > 0) {
    show_debug_message("✅ SISTEMA BÁSICO OK - O problema pode ser:");
    show_debug_message("   1. Conflito com outros objetos");
    show_debug_message("   2. Problema com position_meeting");
    show_debug_message("   3. Variáveis globais bloqueando");
    show_debug_message("   4. Layer incorreta");
} else {
    show_debug_message("❌ PROBLEMA ENCONTRADO:");
    if (!object_exists(obj_menu_recrutamento_marinha)) {
        show_debug_message("   - Objeto obj_menu_recrutamento_marinha não existe");
    }
    if (_quartel_count == 0) {
        show_debug_message("   - Nenhum quartel de marinha na sala");
    }
}

show_debug_message("=== DIAGNÓSTICO CONCLUÍDO ===");
