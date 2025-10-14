// ================================================
// HEGEMONIA GLOBAL - OBJETO: AR-CURTO (Míssil Ar-Ar)
// Draw Event - Interface Visual para Mísseis Ar-Ar
// ================================================

// === DESENHAR SPRITE PRINCIPAL ===
if (sprite_exists(sprite_index)) {
    // Desenhar sprite com configurações visuais
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}

// =================================================================
// SISTEMA DE DEBUG CONDICIONAL - SÓ APARECE COM F-5 SELECIONADO
// =================================================================

// Verificar se o F-5 que lançou o míssil está selecionado
if (instance_exists(dono) && dono.selecionado == true) {
    
    // === DESENHAR CIRCULO DE DESTAQUE (APENAS EM DEBUG) ===
    draw_set_color(image_blend);
    draw_circle(x, y, 20, false);
    
    // === DESENHAR LINHA DE DIREÇÃO (APENAS EM DEBUG) ===
    if (alvo != noone && instance_exists(alvo)) {
        draw_set_color(c_yellow);
        draw_line(x, y, alvo.x, alvo.y);
        
        // Desenhar círculo no alvo aéreo
        draw_set_color(c_red);
        draw_circle(alvo.x, alvo.y, 15, false);
        
        // Desenhar linha direta para o alvo
        draw_set_color(c_lime);
        draw_line(x, y, alvo.x, alvo.y);
    }
    
    // === DESENHAR TEXTO DE DEBUG (APENAS EM DEBUG) ===
    draw_set_color(c_white);
    draw_set_font(-1);
    
    var _texto_vida = "Vida: " + string(timer_vida);
    var _texto_vel = "Vel: " + string(speed);
    var _texto_dano = "Dano: " + string(dano);
    var _texto_precisao = "Precisão: " + string(precisao * 100) + "%";
    
    draw_text(x + 25, y - 40, "🚀 AR-CURTO");
    draw_text(x + 25, y - 30, _texto_vida);
    draw_text(x + 25, y - 20, _texto_vel);
    draw_text(x + 25, y - 10, _texto_dano);
    draw_text(x + 25, y, _texto_precisao);
    
    // Desenhar distância até o alvo
    if (alvo != noone && instance_exists(alvo)) {
        var _dist = point_distance(x, y, alvo.x, alvo.y);
        draw_text(x + 25, y + 10, "Dist: " + string(_dist));
        draw_text(x + 25, y + 20, "Alcance: " + string(alcance_maximo));
    }
}