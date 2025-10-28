// ===============================================
// HEGEMONIA GLOBAL - QUARTEL: MENU DE RECRUTAMENTO
// Sistema Original com Menu
// ===============================================

// Evento Left Pressed de obj_quartel
// CORREÇÃO: Usar a função global scr_mouse_to_world para coordenadas consistentes
var _coords = global.scr_mouse_to_world();
var _world_mouse_x = _coords[0];
var _world_mouse_y = _coords[1];

// Debug: Mostrar informações do clique
show_debug_message("=== DEBUG QUARTEL CLIQUE ===");
show_debug_message("Mouse Mundo: (" + string(_world_mouse_x) + ", " + string(_world_mouse_y) + ")");
show_debug_message("Quartel Pos: (" + string(x) + ", " + string(y) + ")");
show_debug_message("Clique detectado: " + string(mouse_check_button_pressed(mb_left)));
show_debug_message("Position meeting: " + string(position_meeting(_world_mouse_x, _world_mouse_y, id)));

// ✅ CORREÇÃO BUG: Verificar se há unidade SOBRE o edifício (apenas se não for o próprio quartel)
// Primeiro verificar se há uma UNIDADE sobre o edifício (não o próprio edifício)
var _tem_unidade_sobre = false;
var _tipos_unidades = [
    obj_infantaria, obj_tanque, obj_soldado_antiaereo, obj_blindado_antiaereo,
    obj_caca_f5, obj_helicoptero_militar, obj_f15, obj_f6, obj_c100
];

for (var i = 0; i < array_length(_tipos_unidades); i++) {
    var _inst = instance_position(_world_mouse_x, _world_mouse_y, _tipos_unidades[i]);
    if (_inst != noone && instance_exists(_inst)) {
        _tem_unidade_sobre = true;
        show_debug_message("⚠️ Unidade detectada sobre o edifício - ignorando clique no quartel");
        show_debug_message("   Unidade: " + object_get_name(_inst.object_index));
        break;
    }
}

// Se há unidade sobre o edifício, ignorar o clique no edifício
if (_tem_unidade_sobre) {
    exit; // Sair sem processar clique no edifício
}

// Verificar se o clique foi realmente no sprite do quartel
// Usar collision_point como método alternativo mais confiável
var _clique_detectado = false;

// Método 1: position_meeting com coordenadas corrigidas
if (position_meeting(_world_mouse_x, _world_mouse_y, id)) {
    _clique_detectado = true;
    show_debug_message("✅ Clique detectado via position_meeting");
}

// Método 2: collision_point como fallback
if (!_clique_detectado) {
    var _colisao = collision_point(_world_mouse_x, _world_mouse_y, obj_quartel, false, true);
    if (_colisao == id) {
        _clique_detectado = true;
        show_debug_message("✅ Clique detectado via collision_point");
    }
}

if (mouse_check_button_pressed(mb_left) && _clique_detectado) {
    show_debug_message("✅ CLIQUE NO QUARTEL DETECTADO!");
    
    // === CORREÇÃO: FECHAR MENUS EXISTENTES PRIMEIRO ===
    // Garantir que não há menus órfãos antes de criar um novo
    if (global.menu_recrutamento_aberto) {
        show_debug_message("🔄 Fechando menus existentes antes de abrir novo...");
        scr_limpar_menus_recrutamento();
    }
    
    // === VERIFICAÇÃO DE CONDIÇÕES ===
    if (!global.modo_construcao && global.construindo_agora == noone) {
        // Verificar se o quartel está completamente construído antes de abrir o menu
        // Como o quartel já foi criado como instância, ele está completo
        var _menu_recrutamento = instance_create_layer(x, y + 64, "Instances", obj_menu_recrutamento);
        _menu_recrutamento.id_do_quartel = id; // Informa ao menu qual quartel o criou
        global.menu_recrutamento_aberto = true;
        
        show_debug_message("=== MENU DE RECRUTAMENTO CRIADO ===");
        show_debug_message("Menu ID: " + string(_menu_recrutamento));
        show_debug_message("Quartel ID: " + string(id));
        show_debug_message("Posição do menu: (" + string(_menu_recrutamento.x) + ", " + string(_menu_recrutamento.y) + ")");
        show_debug_message("Estado global: " + string(global.menu_recrutamento_aberto));
    } else {
        show_debug_message("❌ NÃO FOI POSSÍVEL ABRIR MENU:");
        if (global.modo_construcao) {
            show_debug_message("- Modo construção ativo: " + string(global.modo_construcao));
        } else if (global.construindo_agora != noone) {
            show_debug_message("- Construindo agora: " + string(global.construindo_agora));
        } else {
            show_debug_message("- Razão desconhecida!");
        }
    }
} else {
    show_debug_message("❌ Clique não detectado no quartel");
}
