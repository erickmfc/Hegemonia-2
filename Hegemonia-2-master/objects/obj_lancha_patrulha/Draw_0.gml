// =========================================================
// HEGEMONIA GLOBAL - LANCHA PATRULHA DRAW EVENT
// v3.2 - Versão Revisada e Funcional
// =========================================================

// 1. Desenha o sprite principal da lancha
draw_self();

// 2. Desenha a barra de vida (apenas se danificada)
if (hp_atual < hp_max) {
    draw_healthbar(x - 25, y - 35, x + 25, y - 29, (hp_atual / hp_max) * 100, c_black, c_red, c_green, 0, true, true);
}

// 3. Feedback visual quando a unidade está SELECIONADA
if (selecionado) {
    // SELEÇÃO SUTIL: Círculo verde com transparência
    draw_set_color(c_lime);
    draw_set_alpha(0.8);
    draw_circle(x, y, 28, true);
    draw_set_alpha(1.0);
    
    // ✅ NOVO: CÍRCULO DE ALCANCE DE ATAQUE
    if (modo_ataque) {
        draw_set_color(c_red);
        draw_set_alpha(0.3);
        draw_circle(x, y, alcance_ataque, false);
        draw_set_alpha(1.0);
    }
    
    // ✅ NOVO: CÍRCULO DE RADAR (maior)
    draw_set_color(c_gray);
    draw_set_alpha(0.2);
    draw_circle(x, y, radar_alcance, false);
    draw_set_alpha(1.0);
    
    // LINHA DE MOVIMENTO (se estiver movendo)
    if (estado == "movendo") {
        draw_set_color(c_lime);
        draw_line_width(x, y, destino_x, destino_y, 3);
        draw_circle(destino_x, destino_y, 8, true);
    }
    
    // LINHA DE PATRULHA (se estiver patrulhando)
    if (estado == "patrulhando" && ds_list_size(pontos_patrulha) > 0) {
        var p_atual = pontos_patrulha[| indice_patrulha_atual];
        draw_set_color(c_aqua);
        draw_line_width(x, y, p_atual[0], p_atual[1], 3);
        draw_circle(p_atual[0], p_atual[1], 8, true);
    }
    
    // ✅ NOVO: LINHA PARA O ALVO (quando atacando)
    if (estado == "atacando" && instance_exists(alvo_em_mira)) {
        draw_set_color(c_red);
        draw_line_width(x, y, alvo_em_mira.x, alvo_em_mira.y, 2);
        draw_circle(alvo_em_mira.x, alvo_em_mira.y, 6, true);
    }
    
    // ✅ NOVO: PAINEL DE INFORMAÇÕES DETALHADO
    draw_set_alpha(1.0);
    draw_set_halign(fa_left);
    
    // Determinar estado atual
    var _estado_texto = "PARADO";
    if (estado == "movendo") _estado_texto = "MOVENDO";
    else if (estado == "atacando") _estado_texto = "ATACANDO";
    else if (estado == "patrulhando") _estado_texto = "PATRULHANDO";
    else if (global.definindo_patrulha_unidade == id) _estado_texto = "DEFININDO ROTA";
    
    // Determinar modo de combate
    var _modo_texto = "PASSIVO";
    if (variable_instance_exists(id, "modo_ataque") && modo_ataque) {
        _modo_texto = "ATAQUE";
    }
    
    // Determinar progresso da patrulha
    var _patrulha_info = "";
    if (estado == "patrulhando" && ds_list_size(pontos_patrulha) > 0) {
        var _ponto_atual = indice_patrulha_atual + 1;
        var _total_pontos = ds_list_size(pontos_patrulha);
        _patrulha_info = "Patrulha: Ponto " + string(_ponto_atual) + "/" + string(_total_pontos);
    } else if (global.definindo_patrulha_unidade == id) {
        _patrulha_info = "Patrulha: Definindo (" + string(ds_list_size(pontos_patrulha)) + " pontos)";
    } else {
        _patrulha_info = "Patrulha: Inativa";
    }
    
    // Calcular dimensões do painel
    var _linha1 = "LANCHA PATRULHA";
    var _linha2 = "Estado: " + _estado_texto;
    var _linha3 = "Modo: " + _modo_texto;
    var _linha4 = "HP: " + string(hp_atual) + "/" + string(hp_max);
    var _linha5 = _patrulha_info;
    
    var _largura_max = max(string_width(_linha1), string_width(_linha2));
    _largura_max = max(_largura_max, string_width(_linha3));
    _largura_max = max(_largura_max, string_width(_linha4));
    _largura_max = max(_largura_max, string_width(_linha5));
    
    var _altura_total = string_height(_linha1) * 5 + 20; // 5 linhas + padding
    var _largura_total = _largura_max + 20; // padding
    
    // Posição do painel (acima da lancha)
    var _painel_x = x - _largura_total / 2;
    var _painel_y = y - sprite_height - _altura_total - 10;
    
    // Desenhar fundo do painel
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(_painel_x, _painel_y, _painel_x + _largura_total, _painel_y + _altura_total, false);
    
    // Desenhar borda do painel
    draw_set_color(c_lime);
    draw_set_alpha(0.6);
    draw_rectangle(_painel_x, _painel_y, _painel_x + _largura_total, _painel_y + _altura_total, true);
    
    // Desenhar texto do painel
    draw_set_color(c_white);
    draw_set_alpha(1.0);
    
    var _texto_y = _painel_y + 10;
    draw_text(_painel_x + 10, _texto_y, _linha1);
    _texto_y += string_height(_linha1);
    
    draw_text(_painel_x + 10, _texto_y, _linha2);
    _texto_y += string_height(_linha2);
    
    draw_text(_painel_x + 10, _texto_y, _linha3);
    _texto_y += string_height(_linha3);
    
    draw_text(_painel_x + 10, _texto_y, _linha4);
    _texto_y += string_height(_linha4);
    
    draw_text(_painel_x + 10, _texto_y, _linha5);
    
    draw_set_halign(fa_left);
}

// 4. ROTA DE PATRULHA completa (sempre visível se existir)
if (ds_list_size(pontos_patrulha) > 0) {
    draw_set_color(c_aqua);
    draw_set_alpha(0.6);
    
    // Desenha linhas entre pontos
    for (var i = 0; i < ds_list_size(pontos_patrulha); i++) {
        var p1 = pontos_patrulha[| i];
        var p2 = pontos_patrulha[| (i + 1) % ds_list_size(pontos_patrulha)];
        draw_line_width(p1[0], p1[1], p2[0], p2[1], 2);
        draw_circle(p1[0], p1[1], 6, true);
    }
    
    draw_set_alpha(1.0);
}

// 5. Linha durante definição de patrulha
if (global.definindo_patrulha_unidade == id && ds_list_size(pontos_patrulha) > 0) {
    var p_last = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
    var _coords = global.scr_mouse_to_world();
    draw_set_color(c_yellow);
    draw_line_width(p_last[0], p_last[1], _coords[0], _coords[1], 4);
}
