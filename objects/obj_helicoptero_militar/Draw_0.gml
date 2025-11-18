// ===============================================
// HEGEMONIA GLOBAL - HELICÓPTERO (Draw Refatorado)
// ===============================================

// =============================================
// DRAW - Otimizado com verificação de visibilidade
// =============================================

// ✅ OTIMIZAÇÃO: Verificar se deve desenhar
if (!scr_should_draw(id)) {
    if (instance_exists(obj_draw_optimizer)) {
        obj_draw_optimizer.objects_skipped++;
    }
    exit;
}

// Efeito de altitude com sombra
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_black, 0.4);
draw_sprite_ext(sprite_index, image_index, x, y - altura_voo, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

// Indicadores visuais se selecionado
if (selecionado) {
    var _draw_y = y - altura_voo;

    // Círculo de seleção mais visível
    draw_set_color(c_green); 
    draw_set_alpha(0.5); 
    draw_circle(x, _draw_y, 50, false); // Círculo vazio maior e mais visível
    
    // Círculo interno menor
    draw_set_color(c_green); 
    draw_set_alpha(0.3); 
    draw_circle(x, _draw_y, 30, true); // Círculo preenchido menor
    
    // Radar (opcional - pode ser removido se não quiser)
    draw_set_color(modo_ataque ? c_red : c_gray); 
    draw_set_alpha(0.1); 
    draw_circle(x, _draw_y, radar_alcance, false);
    draw_set_alpha(1.0);

    // Linha para o destino
    if (voando && velocidade_atual > 0) {
        draw_set_color(c_yellow);
        draw_set_alpha(0.5);
        draw_line(x, _draw_y, destino_x, destino_y);
        
        // Círculo no destino
        draw_circle(destino_x, destino_y, 10, false);
    }
    
    // ✅ NOVO: Informações de Status e Controles
    draw_set_alpha(1.0);
    draw_set_halign(fa_center);
    
    var _status_text = voando ? "VOANDO" : "POUSADO";
    var _status_color = voando ? c_aqua : c_lime;
    
    // ✅ CORREÇÃO: Definir fonte padrão antes de desenhar (evita fonte gigante)
    draw_set_font(-1);
    
    // Desenha o status acima do helicóptero (com fundo escuro para legibilidade)
    var _status_x = x;
    var _status_y = _draw_y - 65;
    var _status_w = string_width(_status_text) + 20;
    var _status_h = 25;
    
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(_status_x - _status_w/2, _status_y - _status_h/2, 
                    _status_x + _status_w/2, _status_y + _status_h/2, false);
    draw_set_alpha(1.0);
    
    // Borda do status
    draw_set_color(_status_color);
    draw_set_alpha(0.6);
    draw_rectangle(_status_x - _status_w/2, _status_y - _status_h/2, 
                    _status_x + _status_w/2, _status_y + _status_h/2, true);
    draw_set_alpha(1.0);
    
    // Desenhar status PRINCIPAL
    draw_set_color(_status_color);
    draw_text(_status_x, _status_y, _status_text);
    
    // Desenha os controles disponíveis (menor, abaixo do status)
    draw_set_color(c_white);
    draw_set_alpha(0.9);
    draw_text(x, _draw_y - 35, "[L] Pousar");
    draw_text(x, _draw_y - 20, "[P] Passivo | [O] Ataque");
    draw_set_alpha(1.0);

    draw_set_halign(fa_left);
}