// ===============================================
// HEGEMONIA GLOBAL - UNIDADE DE COMBATE (PAI)
// Bloco 7, Fase 3: Sistema de Feedback Visual
// ===============================================

// --- PASSO 1: DESENHAR A UNIDADE ---
// draw_self() desenha o sprite da unidade filha (seja infantaria ou tanque)
draw_self();

// --- PASSO 2: DESENHAR A BARRA DE VIDA ---
// (Lógica que movemos da infantaria para o pai)
if (vida_atual < vida_maxima) {
    var _bar_x = x - (sprite_width / 2);
    var _bar_y = y - sprite_height;
    var _bar_w = sprite_width;
    var _bar_h = 5;
    var _vida_perc = vida_atual / vida_maxima;
    
    draw_set_color(c_dkgray);
    draw_rectangle(_bar_x - 1, _bar_y - 1, _bar_x + _bar_w + 1, _bar_y + _bar_h + 1, false);
    
    if (nacao_proprietaria == 1) { draw_set_color(c_lime); } else { draw_set_color(c_red); }
    draw_rectangle(_bar_x, _bar_y, _bar_x + (_bar_w * _vida_perc), _bar_y + _bar_h, false);
    
    draw_set_color(c_white);
}

// --- PASSO 3: DESENHAR FEEDBACKS APENAS SE A UNIDADE ESTIVER SELECIONADA ---
if (selecionado) {
    
    // 1. LINHAS VERDES DE SELEÇÃO
    draw_set_color(c_lime);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true); // 'true' para contorno
    
    // 2. CÍRCULO CINZA DO ALCANCE DE TIRO
    draw_set_alpha(0.3); // Define a transparência
    draw_set_color(c_gray);
    draw_circle(x, y, alcance_em_pixels, true); // 'true' para contorno
    draw_set_alpha(1.0); // Reseta a transparência

    // 3. LINHAS AMARELAS DA ROTA DE PATRULHA
    if (ds_list_size(rota_de_patrulha) > 0) {
        draw_set_color(c_yellow);
        for (var i = 0; i < ds_list_size(rota_de_patrulha); i++) {
            var _ponto = rota_de_patrulha[| i];
            
            // Desenha a linha do ponto anterior para o atual
            if (i > 0) {
                var _ponto_anterior = rota_de_patrulha[| i - 1];
                draw_line(_ponto[0], _ponto[1], _ponto_anterior[0], _ponto_anterior[1]);
            } else {
                // Desenha a linha da unidade até o primeiro ponto
                draw_line(x, y, _ponto[0], _ponto[1]);
            }
        }
    }
    
    // Reseta a cor para branco para não afetar outros objetos
    draw_set_color(c_white);
}
