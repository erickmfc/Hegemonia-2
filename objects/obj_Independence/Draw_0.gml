/// @description Draw Event da Independence
// ===============================================
// HEGEMONIA GLOBAL - INDEPENDENCE (HERDA DE NAVIO_BASE)
// Draw Event - Indicadores específicos
// ===============================================

// Chamar o Draw do objeto pai (herda indicadores básicos)
event_inherited();

if (selecionado) {
    // Círculo de seleção
    draw_set_color(c_red);
    draw_set_alpha(0.3);
    draw_circle(x, y, 45, false);
    draw_set_alpha(1.0);
    
    // Nome da unidade
    draw_set_halign(fa_center);
    draw_set_color(c_red);
    draw_text_transformed(x, y - 120, "INDEPENDENCE", 1.0, 1.0, 0);
    
    // Indicadores de estado
    var _y_offset = -100;
    
    // Indicador de canhão ativo
    if (metralhadora_ativa && instance_exists(alvo_unidade)) {
        draw_set_color(c_yellow);
        if (object_is_ancestor(alvo_unidade.object_index, obj_aereo)) {
            draw_text_transformed(x, y + _y_offset, "🚀 DISPARANDO (AR)", 0.8, 0.8, 0);
        } else {
            draw_text_transformed(x, y + _y_offset, "🔫 DISPARANDO", 0.8, 0.8, 0);
        }
        _y_offset += 15;
    }
    
    // Indicador de status
    if (estado == LanchaState.ATACANDO) {
        draw_set_color(c_yellow);
        draw_text_transformed(x, y + _y_offset, "⚔️ ATACANDO", 0.7, 0.7, 0);
    }
    
    // Círculo de alcance de mísseis
    draw_set_color(c_red);
    draw_set_alpha(0.1);
    draw_circle(x, y, missil_max_alcance, false);
    draw_set_alpha(0.3);
    draw_circle(x, y, missil_max_alcance, true);
    draw_set_alpha(1.0);
    
    // Resetar alinhamento
    draw_set_halign(fa_left);
}