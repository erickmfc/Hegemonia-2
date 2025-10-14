// ===============================================
// HEGEMONIA GLOBAL - AEROPORTO MILITAR
// Evento Mouse Left Pressed - Interação com Diagnóstico
// ===============================================

show_debug_message("=== AEROPORTO MOUSE_53 EXECUTADO ===");

// Verificar se pode interagir
if (!pode_interagir) {
    show_debug_message("❌ Aeroporto não pode interagir");
    exit;
}

show_debug_message("✅ Aeroporto pode interagir");

// Usar função global para coordenadas consistentes
var _coords = global.scr_mouse_to_world();
var _world_mouse_x = _coords[0];
var _world_mouse_y = _coords[1];

// ... (várias verificações de clique, como position_meeting, etc.) ...
var _clique_detectado = position_meeting(_world_mouse_x, _world_mouse_y, id);

if (mouse_check_button_pressed(mb_left) && _clique_detectado) {
    show_debug_message("✅ CLIQUE NO AEROPORTO DETECTADO!");
    
    // Verificar se pode abrir o menu
    if (!global.modo_construcao && global.construindo_agora == noone) {
        
        // Criar menu de recrutamento aéreo
        var _menu = instance_create_layer(0, 0, "Instances", obj_menu_recrutamento_aereo);
        if (instance_exists(_menu)) {
            _menu.id_do_aeroporto = id;
            show_debug_message("📱 Menu de recrutamento aéreo aberto");
        } else {
            show_debug_message("❌ ERRO: Falha ao criar menu de recrutamento aéreo!");
        }
    } else {
        show_debug_message("❌ NÃO FOI POSSÍVEL ABRIR MENU (Modo construção ativo)");
    }
} else {
    show_debug_message("❌ Clique não detectado no aeroporto");
}