// ===============================================
// HEGEMONIA GLOBAL - AEROPORTO MILITAR
// Evento Mouse Left Pressed - Interação
// ===============================================

show_debug_message("=== AEROPORTO MOUSE_53 EXECUTADO ===");
show_debug_message("🎯 Aeroporto ID: " + string(id) + " | Posição: (" + string(x) + ", " + string(y) + ")");

// Verificar se pode interagir
if (!pode_interagir) {
    show_debug_message("❌ Aeroporto não pode interagir");
    exit;
}

show_debug_message("✅ Aeroporto pode interagir");

// CORREÇÃO: Usar função global para coordenadas consistentes
show_debug_message("🔍 Chamando global.scr_mouse_to_world()...");
var _coords = global.scr_mouse_to_world();
var _world_mouse_x = _coords[0];
var _world_mouse_y = _coords[1];
show_debug_message("📍 Coordenadas convertidas: (" + string(_world_mouse_x) + ", " + string(_world_mouse_y) + ")");

// Debug: Mostrar informações do clique
show_debug_message("=== DEBUG AEROPORTO CLIQUE ===");
show_debug_message("Mouse Mundo: (" + string(_world_mouse_x) + ", " + string(_world_mouse_y) + ")");
show_debug_message("Aeroporto Pos: (" + string(x) + ", " + string(y) + ")");
show_debug_message("Clique detectado: " + string(mouse_check_button_pressed(mb_left)));
show_debug_message("Position meeting: " + string(position_meeting(_world_mouse_x, _world_mouse_y, id)));

// Debug detalhado do sprite
show_debug_message("=== DEBUG DETALHADO AEROPORTO ===");
show_debug_message("Sprite: " + string(sprite_index));
show_debug_message("Sprite W: " + string(sprite_get_width(sprite_index)));
show_debug_message("Sprite H: " + string(sprite_get_height(sprite_index)));
show_debug_message("Origem X: " + string(sprite_get_xoffset(sprite_index)));
show_debug_message("Origem Y: " + string(sprite_get_yoffset(sprite_index)));

// ✅ CORREÇÃO BUG: Verificar se há unidade SOBRE o edifício (apenas se não for o próprio aeroporto)
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
        show_debug_message("⚠️ Unidade detectada sobre o edifício - ignorando clique no aeroporto");
        show_debug_message("   Unidade: " + object_get_name(_inst.object_index));
        break;
    }
}

// Se há unidade sobre o edifício, ignorar o clique no edifício
if (_tem_unidade_sobre) {
    exit; // Sair sem processar clique no edifício
}

// Verificar se o clique foi realmente no sprite do aeroporto
// Usar múltiplos métodos para detecção mais robusta
var _clique_detectado = false;

// Método 1: position_meeting com coordenadas corrigidas
if (position_meeting(_world_mouse_x, _world_mouse_y, id)) {
    _clique_detectado = true;
    show_debug_message("✅ Clique detectado via position_meeting");
}

// Método 2: collision_point como fallback
if (!_clique_detectado) {
    var _colisao = collision_point(_world_mouse_x, _world_mouse_y, obj_aeroporto_militar, false, true);
    if (_colisao == id) {
        _clique_detectado = true;
        show_debug_message("✅ Clique detectado via collision_point");
    }
}

// Método 3: Verificação manual com dimensões do sprite
if (!_clique_detectado) {
    var _sprite_w = sprite_get_width(sprite_index);
    var _sprite_h = sprite_get_height(sprite_index);
    var _origin_x = sprite_get_xoffset(sprite_index);
    var _origin_y = sprite_get_yoffset(sprite_index);
    
    var _left = x - _origin_x;
    var _right = x + (_sprite_w - _origin_x);
    var _top = y - _origin_y;
    var _bottom = y + (_sprite_h - _origin_y);
    
    show_debug_message("Área de clique: (" + string(_left) + ", " + string(_top) + ") a (" + string(_right) + ", " + string(_bottom) + ")");
    
    if (_world_mouse_x >= _left && _world_mouse_x <= _right && 
        _world_mouse_y >= _top && _world_mouse_y <= _bottom) {
        _clique_detectado = true;
        show_debug_message("✅ Clique detectado via verificação manual");
    }
}

if (mouse_check_button_pressed(mb_left) && _clique_detectado) {
    show_debug_message("✅ CLIQUE NO AEROPORTO DETECTADO!");
    
    // Verificar se o objeto do menu existe
    if (!object_exists(obj_menu_recrutamento_aereo)) {
        show_debug_message("❌ ERRO: obj_menu_recrutamento_aereo não existe!");
        exit;
    }
    
    // Verificar se pode abrir o menu (similar ao quartel)
    if (!global.modo_construcao && global.construindo_agora == noone) {
        // Criar menu de recrutamento aéreo
        var _menu = instance_create_layer(0, 0, "rm_mapa_principal", obj_menu_recrutamento_aereo);
        if (instance_exists(_menu)) {
            _menu.id_do_aeroporto = id;
            show_debug_message("📱 Menu de recrutamento aéreo aberto");
            show_debug_message("🔗 Conectado ao aeroporto ID: " + string(id));
            show_debug_message("📍 Posição do menu: (" + string(_menu.x) + ", " + string(_menu.y) + ")");
        } else {
            show_debug_message("❌ ERRO: Falha ao criar menu de recrutamento aéreo!");
        }
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
    show_debug_message("❌ Clique não detectado no aeroporto");
}