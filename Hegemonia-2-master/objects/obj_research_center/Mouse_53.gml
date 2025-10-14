// ===============================================
// HEGEMONIA GLOBAL - RESEARCH CENTER
// Sistema Unificado de Clique - IMPLEMENTAÇÃO INLINE
// ===============================================

// === PASSO 1: DESSELECIONAR UNIDADES ===
// Desselecionar todas as unidades quando clica em qualquer edifício
with (obj_infantaria) { selecionado = false; }
with (obj_soldado_antiaereo) { selecionado = false; }
with (obj_tanque) { selecionado = false; }
with (obj_blindado_antiaereo) { selecionado = false; }
with (obj_lancha_patrulha) { selecionado = false; }
with (obj_caca_f5) { selecionado = false; }
with (obj_helicoptero_militar) { selecionado = false; }

// Limpar unidade selecionada global
global.unidade_selecionada = noone;

show_debug_message("🔄 Unidades desselecionadas por clique em edifício");

// === PASSO 2: DETECÇÃO DE CLIQUE ===
// Usar função global para coordenadas consistentes
var _coords = global.scr_mouse_to_world();
var _world_mouse_x = _coords[0];
var _world_mouse_y = _coords[1];

// Debug: Mostrar informações do clique
show_debug_message("=== DEBUG EDIFÍCIO CLIQUE ===");
show_debug_message("Mouse Mundo: (" + string(_world_mouse_x) + ", " + string(_world_mouse_y) + ")");
show_debug_message("Edifício Pos: (" + string(x) + ", " + string(y) + ")");
show_debug_message("Clique detectado: " + string(mouse_check_button_pressed(mb_left)));
show_debug_message("Position meeting: " + string(position_meeting(_world_mouse_x, _world_mouse_y, id)));

// === PASSO 3: VERIFICAÇÃO DE CLIQUE ===
// Usar múltiplos métodos para detecção mais robusta
var _clique_detectado = false;

// Método 1: position_meeting com coordenadas corrigidas
if (position_meeting(_world_mouse_x, _world_mouse_y, id)) {
    _clique_detectado = true;
    show_debug_message("✅ Clique detectado via position_meeting");
}

// Método 2: collision_point como fallback
if (!_clique_detectado) {
    var _colisao = collision_point(_world_mouse_x, _world_mouse_y, object_index, false, true);
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

// === PASSO 4: LÓGICA ESPECÍFICA DO EDIFÍCIO ===
if (mouse_check_button_pressed(mb_left) && _clique_detectado) {
    show_debug_message("✅ CLIQUE NO RESEARCH CENTER DETECTADO!");
    
    // Verificar se pode abrir o menu de pesquisa
    if (!global.modo_construcao && global.construindo_agora == noone) {
        // Abrir menu de pesquisa
        global.menu_pesquisa_aberto = true;
        show_debug_message("🔬 Menu de pesquisa aberto");
        show_debug_message("📍 Research Center ID: " + string(id));
        
        // TODO: Implementar funcionalidade específica do research center
        // Por exemplo: mostrar tecnologias disponíveis, progresso de pesquisa, etc.
        
    } else {
        show_debug_message("❌ NÃO FOI POSSÍVEL ABRIR MENU DE PESQUISA:");
        if (global.modo_construcao) {
            show_debug_message("- Modo construção ativo: " + string(global.modo_construcao));
        } else if (global.construindo_agora != noone) {
            show_debug_message("- Construindo agora: " + string(global.construindo_agora));
        } else {
            show_debug_message("- Razão desconhecida!");
        }
    }
}
