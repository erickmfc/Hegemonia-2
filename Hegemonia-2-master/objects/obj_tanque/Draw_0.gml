// ===============================================
// OBJ_TANQUE - DRAW EVENT (SISTEMA VISUAL SUTIL)
// ===============================================

// ===============================
// 🟢 DESTAQUE DE SELEÇÃO (SUBTIL)
// ===============================
if (selecionado) {
    draw_set_color(c_lime);
    draw_set_alpha(0.3); // Muito mais sutil
    draw_circle(x, y, sprite_width * 0.6, false); // círculo verde sutil
    draw_set_alpha(1);
}

// ===============================
// 🔵 ÁREA DE TIRO (QUASE INVISÍVEL)
// ===============================
if (mostrar_area_tiro) {
    draw_set_color(c_blue);
    draw_set_alpha(0.05); // Quase invisível
    draw_circle(x, y, alcance_tiro, false);
    draw_set_alpha(1);
}

// ===============================
// 📝 INFORMAÇÕES ESSENCIAIS
// ===============================
if (mostrar_info) {
    var txt = "";
    
    // Mostrar apenas o modo atual
    if (modo_ataque) {
        txt = "⚔️ ATAQUE";
    } else if (modo_defesa) {
        txt = "🛡️ DEFESA";
    } else {
        txt = "⏸️ PARADO";
    }
    
    // Mostrar estado se não estiver parado
    if (estado != "parado") {
        txt += "\n";
        if (estado == "movendo") txt += "🚶 MOVENDO";
        else if (estado == "patrulhando") txt += "🔄 PATRULHA";
        else if (estado == "atacando") txt += "💥 ATACANDO";
    }
    
    // Desenha fundo sutil atrás do texto
    var text_w = string_width(txt);
    var text_h = string_height(txt);
    var bx = x - text_w / 2 - 4;
    var by = y - sprite_height - 20;
    
    draw_set_color(c_black);
    draw_set_alpha(0.4); // Mais sutil
    draw_rectangle(bx, by, bx + text_w + 8, by + text_h + 4, false);
    
    draw_set_color(c_white);
    draw_text(x - text_w / 2, by + 2, txt);
}

// ===============================
// 🔴 LINHAS DE PATRULHA (VERMELHAS)
// ===============================
// Desenha linhas se estiver selecionado, tiver pontos E estiver em modo de definição OU patrulhando
if (selecionado && ds_list_size(pontos_patrulha) > 0 && (modo_definicao_patrulha || patrulhando)) {
    draw_set_color(c_red); // Vermelho para patrulha
    draw_set_alpha(0.8);
    
    // Linhas entre pontos
    for (var i = 0; i < ds_list_size(pontos_patrulha) - 1; i++) {
        var p1 = pontos_patrulha[| i];
        var p2 = pontos_patrulha[| i + 1];
        draw_line(p1[0], p1[1], p2[0], p2[1]);
    }
    
    // CORREÇÃO: Linha do último ponto ao mouse APENAS quando em modo de definição
    // Quando já está patrulhando, não desenha linha seguindo o mouse
    if (modo_definicao_patrulha) {
        var mxw = camera_get_view_x(view_camera[0]) + mouse_x;
        var myw = camera_get_view_y(view_camera[0]) + mouse_y;
        var plast = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
        draw_line(plast[0], plast[1], mxw, myw);
        
        // Círculo no mouse
        draw_set_color(c_red);
        draw_set_alpha(0.6);
        draw_circle(mxw, myw, 6, false);
    }
    
    // CORREÇÃO: Quando patrulhando, desenha linha de volta ao primeiro ponto (loop)
    if (patrulhando && ds_list_size(pontos_patrulha) > 1) {
        var primeiro_ponto = pontos_patrulha[| 0];
        var ultimo_ponto = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
        draw_line(ultimo_ponto[0], ultimo_ponto[1], primeiro_ponto[0], primeiro_ponto[1]);
    }
    
    draw_set_alpha(1);
}

// ===============================
// 🔴 LINHAS DE PATRULHA GLOBAL (SISTEMA GLOBAL)
// ===============================
// Desenha linhas quando esta unidade está sendo definida pelo sistema global
if (instance_exists(global.definindo_patrulha_unidade) && global.definindo_patrulha_unidade == id) {
    draw_set_color(c_red); // Vermelho para patrulha
    draw_set_alpha(0.8);
    
    // Linhas entre pontos existentes
    for (var i = 0; i < ds_list_size(pontos_patrulha) - 1; i++) {
        var p1 = pontos_patrulha[| i];
        var p2 = pontos_patrulha[| i + 1];
        draw_line(p1[0], p1[1], p2[0], p2[1]);
    }
    
    // CORREÇÃO: Linha do último ponto ao mouse APENAS durante definição
    // Não desenha quando já está patrulhando
    if (ds_list_size(pontos_patrulha) > 0 && modo_definicao_patrulha) {
        var mxw = camera_get_view_x(view_camera[0]) + mouse_x;
        var myw = camera_get_view_y(view_camera[0]) + mouse_y;
        var plast = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
        draw_line(plast[0], plast[1], mxw, myw);
        
        // Círculo no mouse
        draw_set_color(c_red);
        draw_set_alpha(0.6);
        draw_circle(mxw, myw, 6, false);
    }
    
    draw_set_alpha(1);
}

// ===============================
// 🔸 SPRITE DA UNIDADE (ORIGINAL)
// ===============================
draw_self();