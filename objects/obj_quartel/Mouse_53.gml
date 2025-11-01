// ===============================================
// HEGEMONIA GLOBAL - QUARTEL: MENU DE RECRUTAMENTO
// Sistema Original com Menu
// ===============================================

// Evento Left Pressed de obj_quartel
// CORREÇÃO: Usar a função scr_mouse_to_world para coordenadas consistentes
var _coords = scr_mouse_to_world();
var _world_mouse_x = _coords[0];
var _world_mouse_y = _coords[1];

// ✅ REMOVIDO: Debug excessivo que causava lentidão
// Debug removido para melhorar performance na room teste

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
        // ✅ REMOVIDO: Debug removido para performance
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
}

// Método 2: collision_point como fallback
if (!_clique_detectado) {
    var _colisao = collision_point(_world_mouse_x, _world_mouse_y, obj_quartel, false, true);
    if (_colisao == id) {
        _clique_detectado = true;
    }
}

if (mouse_check_button_pressed(mb_left) && _clique_detectado) {
    // ✅ REDUZIDO: Debug apenas se debug_enabled
    if (global.debug_enabled) show_debug_message("✅ CLIQUE NO QUARTEL DETECTADO!");
    
    // === CORREÇÃO: FECHAR MENUS EXISTENTES PRIMEIRO ===
    // Garantir que não há menus órfãos antes de criar um novo
    if (global.menu_recrutamento_aberto) {
        scr_limpar_menus_recrutamento();
    }
    
    // === VERIFICAÇÃO DE CONDIÇÕES ===
    if (!global.modo_construcao && global.construindo_agora == noone) {
        // Verificar se o quartel está completamente construído antes de abrir o menu
        // Como o quartel já foi criado como instância, ele está completo
        var _menu_recrutamento = instance_create_layer(x, y + 64, "Instances", obj_menu_recrutamento);
        _menu_recrutamento.id_do_quartel = id; // Informa ao menu qual quartel o criou
        global.menu_recrutamento_aberto = true;
    }
}
