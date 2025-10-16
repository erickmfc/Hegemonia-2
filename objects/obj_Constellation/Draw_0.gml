// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION FUNCIONAL
// Interface Visual com Feedback
// ===============================================

// === DESENHAR SPRITE ===
draw_self();

// === INDICADOR DE SELEÇÃO ===
if (selecionado) {
    // Círculo de seleção
    draw_set_color(c_blue);
    draw_set_alpha(0.3);
    draw_circle(x, y, 60, false); // Maior que lancha (navio maior)
    draw_set_alpha(1.0);
    
    // Borda de seleção
    draw_set_color(c_blue);
    draw_set_alpha(0.8);
    draw_circle(x, y, 60, true);
    draw_set_alpha(1.0);
}

// === BARRA DE VIDA ===
var _bar_w = 80;
var _bar_h = 10;
var _bar_x = x - _bar_w/2;
var _bar_y = y - 70;

// Fundo da barra
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(_bar_x - 2, _bar_y - 2, _bar_x + _bar_w + 2, _bar_y + _bar_h + 2, false);

// Barra de vida
var _hp_percent = hp_atual / hp_max;
var _hp_color = c_green;
if (_hp_percent < 0.5) _hp_color = c_yellow;
if (_hp_percent < 0.25) _hp_color = c_red;

draw_set_color(_hp_color);
draw_set_alpha(1.0);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w * _hp_percent, _bar_y + _bar_h, false);

// Borda da barra
draw_set_color(c_white);
draw_set_alpha(0.8);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, true);
draw_set_alpha(1.0);

// === INDICADOR DE ESTADO ===
var _estado_y = y - 90;
var _estado_color = c_white;

switch (estado) {
    case "parado": _estado_color = c_gray; break;
    case "movendo": _estado_color = c_aqua; break;
    case "atacando": _estado_color = c_red; break;
    case "patrulhando": _estado_color = c_lime; break;
}

draw_set_halign(fa_center);
draw_set_color(_estado_color);
draw_text_transformed(x, _estado_y, string_upper(estado), 0.8, 0.8, 0);

// === FEEDBACK DE AÇÃO ===
if (feedback_timer > 0) {
    var _feedback_y = y - 110;
    draw_set_color(cor_feedback);
    draw_set_alpha(feedback_timer / 60.0);
    draw_text_transformed(x, _feedback_y, ultima_acao, 0.7, 0.7, 0);
    draw_set_alpha(1.0);
}

// === LINHA DE DESTINO (SE MOVENDO) ===
if (estado == "movendo") {
    draw_set_color(c_aqua);
    draw_set_alpha(0.6);
    draw_line(x, y, destino_x, destino_y);
    
    // Círculo no destino
    draw_set_alpha(0.4);
    draw_circle(destino_x, destino_y, 20, false);
    draw_set_alpha(1.0);
}

// === LINHA DE ATAQUE (SE ATACANDO) ===
if (estado == "atacando" && instance_exists(alvo_unidade)) {
    draw_set_color(c_red);
    draw_set_alpha(0.8);
    draw_line(x, y, alvo_unidade.x, alvo_unidade.y);
    
    // Círculo no alvo
    draw_set_alpha(0.5);
    draw_circle(alvo_unidade.x, alvo_unidade.y, 25, false);
    draw_set_alpha(1.0);
}

// === CÍRCULO DE ALCANCE (SE SELECIONADO) ===
if (selecionado) {
    // Alcance de mísseis
    draw_set_color(c_red);
    draw_set_alpha(0.2);
    draw_circle(x, y, missil_alcance, false);
    
    // Alcance de radar
    draw_set_color(c_blue);
    draw_set_alpha(0.1);
    draw_circle(x, y, alcance_radar, false);
    draw_set_alpha(1.0);
}

// === TIMER DE RECARGA (SE ATACANDO) ===
if (reload_timer > 0) {
    var _reload_percent = reload_timer / reload_time;
    var _reload_y = y + 40;
    var _reload_w = 50;
    var _reload_h = 8;
    var _reload_x = x - _reload_w/2;
    
    // Fundo
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(_reload_x - 1, _reload_y - 1, _reload_x + _reload_w + 1, _reload_y + _reload_h + 1, false);
    
    // Barra de recarga
    draw_set_color(c_yellow);
    draw_set_alpha(1.0);
    draw_rectangle(_reload_x, _reload_y, _reload_x + _reload_w * (1 - _reload_percent), _reload_y + _reload_h, false);
    
    // Borda
    draw_set_color(c_white);
    draw_set_alpha(0.8);
    draw_rectangle(_reload_x, _reload_y, _reload_x + _reload_w, _reload_y + _reload_h, true);
    draw_set_alpha(1.0);
}

// === ROTA DE PATRULHA ===
if (ds_exists(pontos_patrulha, ds_type_list) && ds_list_size(pontos_patrulha) > 0) {
    draw_set_color(c_blue);
    draw_set_alpha(0.8);
    
    // Desenhar linhas conectando os pontos
    for (var i = 0; i < ds_list_size(pontos_patrulha) - 1; i++) {
        var _p1 = pontos_patrulha[| i];
        var _p2 = pontos_patrulha[| i + 1];
        draw_line(_p1[0], _p1[1], _p2[0], _p2[1]);
    }
    
    // Fechar o loop se patrulhando
    if (estado == "patrulhando" && ds_list_size(pontos_patrulha) > 1) {
        var _ultimo = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
        var _primeiro = pontos_patrulha[| 0];
        draw_line(_ultimo[0], _ultimo[1], _primeiro[0], _primeiro[1]);
    }
    
    // Desenhar pontos de patrulha
    for (var i = 0; i < ds_list_size(pontos_patrulha); i++) {
        var _ponto = pontos_patrulha[| i];
        if (i == indice_patrulha_atual && estado == "patrulhando") {
            draw_set_color(c_yellow); // Ponto atual
            draw_circle(_ponto[0], _ponto[1], 12, true);
        } else {
            draw_set_color(c_blue); // Outros pontos
            draw_circle(_ponto[0], _ponto[1], 8, true);
        }
    }
    
    draw_set_alpha(1.0);
}

// === INFO DE DEBUG (SE SELECIONADO) ===
if (selecionado) {
    var _debug_y = y + 60;
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_set_alpha(0.8);
    
    draw_text_transformed(x, _debug_y, "HP: " + string(hp_atual) + "/" + string(hp_max), 0.6, 0.6, 0);
    draw_text_transformed(x, _debug_y + 15, "Vel: " + string(velocidade_movimento), 0.6, 0.6, 0);
    
    if (variable_instance_exists(id, "debug_info")) {
        draw_text_transformed(x, _debug_y + 30, "Mísseis: " + string(debug_info.misseis_disparados), 0.6, 0.6, 0);
        draw_text_transformed(x, _debug_y + 45, "Ações: " + string(debug_info.acoes), 0.6, 0.6, 0);
    } else {
        draw_text_transformed(x, _debug_y + 30, "Mísseis: 0", 0.6, 0.6, 0);
        draw_text_transformed(x, _debug_y + 45, "Ações: 0", 0.6, 0.6, 0);
    }
    draw_set_alpha(1.0);
}

// === CONTROLES (SE SELECIONADO) ===
if (selecionado) {
    var _controls_y = y + 120;
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_set_alpha(0.7);
    
    draw_text_transformed(x, _controls_y, "[S] Parar | [A] Atacar", 0.5, 0.5, 0);
    draw_text_transformed(x, _controls_y + 12, "[P] Patrulha | Clique = Ponto", 0.5, 0.5, 0);
    draw_text_transformed(x, _controls_y + 24, "Clique Dir = Mover", 0.5, 0.5, 0);
    draw_set_alpha(1.0);
}

// Reset
draw_set_halign(fa_left);