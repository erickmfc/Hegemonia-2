// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO MODERNIZADO
// Sistema de Animações e Controles Avançados
// ===============================================

// Evento Step de obj_menu_recrutamento

// Reduzir o delay de abertura
if (delay_abertura > 0) {
    delay_abertura--;
}

// Reduzir o debounce de navegação
if (debounce_navegacao > 0) {
    debounce_navegacao--;
}

// === SISTEMA DE ANIMAÇÕES ===
animation_timer++;

// Animar overlay de fundo
overlay_alpha = lerp(overlay_alpha, overlay_alpha_target, overlay_alpha_speed);

// Animar menu principal
menu_alpha = lerp(menu_alpha, menu_alpha_target, menu_alpha_speed);
menu_scale = lerp(menu_scale, menu_scale_target, menu_scale_speed);

// Animar cabeçalho
header_glow_intensity = lerp(header_glow_intensity, header_glow_target, 0.08);
header_line_alpha = lerp(header_line_alpha, 1, 0.1);

// Animar painel lateral
info_panel_alpha = lerp(info_panel_alpha, info_panel_alpha_target, 0.08);
info_panel_offset_x = lerp(info_panel_offset_x, info_panel_offset_x_target, 0.1);

// Animar rodapé
footer_alpha = lerp(footer_alpha, footer_alpha_target, 0.08);

// === SISTEMA DE CONFIRMAÇÃO DE RECRUTAMENTO ===
if (recruitment_confirmation) {
    confirmation_timer--;
    if (confirmation_timer <= 0) {
        recruitment_confirmation = false;
        confirmation_timer = 0;
    }
}

// === SISTEMA DE FILA DE RECRUTAMENTO ===
queue_display_timer++;
if (queue_display_timer > 60) {
    queue_display_timer = 0;
}

// === SISTEMA DE FEEDBACK VISUAL ===
if (resource_update_flash) {
    resource_flash_timer--;
    if (resource_flash_timer <= 0) {
        resource_update_flash = false;
        resource_flash_timer = 0;
    }
}

// Animar cards individualmente
for (var i = 0; i < 4; i++) {
    var card = card_animations[i];
    var hover = card_hover_effects[i];
    
    // Incrementar timer do card
    card.timer++;
    
    // Iniciar animação após delay
    if (card.timer >= card.delay) {
        card.alpha = lerp(card.alpha, card.alpha_target, 0.12);
        card.scale = lerp(card.scale, card.scale_target, 0.08);
        card.offset_y = lerp(card.offset_y, card.offset_y_target, 0.1);
    }
    
    // Animar efeitos de hover
    hover.hover_alpha = lerp(hover.hover_alpha, 0, 0.15);
    hover.pulse_alpha = lerp(hover.pulse_alpha, 0, 0.1);
    hover.glow_intensity = lerp(hover.glow_intensity, 0, 0.12);
}

// === DETECÇÃO DE HOVER PARA CARDS ===
var _mw = 1430;
var _mh = 786;
var _mx = (display_get_gui_width() - _mw) / 2;
var _my = (display_get_gui_height() - _mh) / 2;

var _header_h = 90;
var _info_w = 358;
var _grid_x = _mx + 20; // Centralizado para novo layout
var _grid_y = _my + _header_h + 30;

var _card_w = 300; // Cards reorganizados
var _card_h = 200; // Altura ajustada
var card_spacing_x = 40; // Espaçamento horizontal
var card_spacing_y = 30; // Espaçamento vertical

// Obter unidades disponíveis
var _unidades = [];
if (instance_exists(id_do_quartel)) {
    _unidades = id_do_quartel.unidades_disponiveis;
}

// Verificar hover em cada card
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

for (var i = 0; i < min(4, ds_list_size(_unidades)); i++) {
    var _unidade = ds_list_find_value(_unidades, i);
    var _row = i div 2;
    var _col = i mod 2;
    
    var _card_x = _grid_x + _col * (_card_w + card_spacing_x);
    var _card_y = _grid_y + _row * (_card_h + card_spacing_y);
    
    // Aplicar offsets de animação
    _card_y += _card_h * 0.35;
    if (_unidade.nome == "Infantaria" || _unidade.nome == "Soldado Antiaéreo") {
        _card_y -= _card_h * 0.25;
    }
    
    // Verificar se mouse está sobre o card
    var _mouse_over_card = (_mouse_gui_x >= _card_x && _mouse_gui_x <= _card_x + _card_w && 
                           _mouse_gui_y >= _card_y && _mouse_gui_y <= _card_y + _card_h);
    
    var hover = card_hover_effects[i];
    
    if (_mouse_over_card) {
        hover.hover_alpha = lerp(hover.hover_alpha, 1, 0.2);
        
        // Verificar se unidade está disponível para pulse effect
        var _can_afford = (global.dinheiro >= _unidade.custo_dinheiro && global.populacao >= _unidade.custo_populacao);
        var _quartel_livre = (!instance_exists(id_do_quartel) || !id_do_quartel.esta_treinando);
        var _disponivel = _can_afford && _quartel_livre;
        
        if (_disponivel) {
            hover.pulse_alpha = 0.3 + 0.2 * sin(animation_timer * 0.2);
            hover.glow_intensity = 0.5 + 0.3 * sin(animation_timer * 0.15);
        }
    }
}
