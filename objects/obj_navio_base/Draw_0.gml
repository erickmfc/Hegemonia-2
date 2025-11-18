// ===============================================
// HEGEMONIA GLOBAL - NAVIO BASE
// Draw Event - Otimizado
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

// Desenhar sprite do navio
draw_self();

// Indicadores visuais se selecionado (herdado pelos filhos)
if (variable_instance_exists(id, "selecionado") && selecionado) {
    // Círculo de seleção básico
    draw_set_color(c_yellow);
    draw_set_alpha(0.3);
    draw_circle(x, y, 50, true);
    draw_set_alpha(1.0);
    
    // ✅ NOVO: Desenhar linha do caminho A* quando em movimento (APENAS UMA LINHA)
    if (variable_instance_exists(id, "estado") && estado == LanchaState.MOVENDO) {
        // ✅ CORREÇÃO: Desenhar apenas o caminho A* completo (removida linha direta duplicada)
        if (variable_instance_exists(id, "meu_caminho") && meu_caminho != noone) {
            draw_set_color(c_aqua);
            draw_set_alpha(0.6);
            var _num_segments = 30; // Número de segmentos para desenhar o caminho
            var _prev_x = x;
            var _prev_y = y;
            
            // ✅ CORREÇÃO: path_get_x/y usa posição (0.0 a 1.0), não pixels
            for (var i = 1; i <= _num_segments; i++) {
                var _pos = i / _num_segments; // Posição de 0.0 a 1.0
                var _seg_x = path_get_x(meu_caminho, _pos);
                var _seg_y = path_get_y(meu_caminho, _pos);
                if (!is_undefined(_seg_x) && !is_undefined(_seg_y)) {
                    draw_line(_prev_x, _prev_y, _seg_x, _seg_y);
                    _prev_x = _seg_x;
                    _prev_y = _seg_y;
                }
            }
        }
    }
    
    // Desenhar linha quando atacando
    if (variable_instance_exists(id, "estado") && estado == LanchaState.ATACANDO) {
        if (variable_instance_exists(id, "alvo_unidade") && instance_exists(alvo_unidade)) {
            draw_set_color(c_red);
            draw_set_alpha(0.7);
            draw_line(x, y, alvo_unidade.x, alvo_unidade.y);
        }
    }
}

// ======================================================================
// ✅ DESENHAR A ROTA DE PATRULHA (Sistema K)
// ======================================================================
if (variable_instance_exists(id, "estado") && 
    (estado == LanchaState.PATRULHANDO || estado == LanchaState.DEFININDO_PATRULHA || 
     (variable_global_exists("definindo_patrulha_unidade") && global.definindo_patrulha_unidade == id))) {

    if (variable_instance_exists(id, "pontos_patrulha") && ds_exists(pontos_patrulha, ds_type_list) && ds_list_size(pontos_patrulha) > 0) {
        draw_set_color(c_blue); // Azul naval
        draw_set_alpha(0.8);
        
        // Desenha as linhas conectando os pontos
        for (var i = 0; i < ds_list_size(pontos_patrulha) - 1; i++) {
            var _p1 = pontos_patrulha[| i];
            var _p2 = pontos_patrulha[| i + 1];
            draw_line(_p1[0], _p1[1], _p2[0], _p2[1]);
        }
        
        // Desenha círculos nos pontos de patrulha
        for (var i = 0; i < ds_list_size(pontos_patrulha); i++) {
            var _ponto = pontos_patrulha[| i];
            if (variable_instance_exists(id, "indice_patrulha_atual") && i == indice_patrulha_atual) {
                draw_set_color(c_yellow); // Ponto atual em amarelo
                draw_circle(_ponto[0], _ponto[1], 8, true);
            } else {
                draw_set_color(c_blue); // Outros pontos em azul naval
                draw_circle(_ponto[0], _ponto[1], 5, true);
            }
        }
        
        // Se estiver definindo a rota, desenha uma linha do último ponto até o mouse
        if (estado == LanchaState.DEFININDO_PATRULHA || 
            (variable_global_exists("definindo_patrulha_unidade") && global.definindo_patrulha_unidade == id)) {
            var _ultimo_ponto = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
            // Conversão de coordenadas do mouse para o mundo (com zoom)
            var _coords = scr_mouse_to_world();
            var _mouse_world_x = _coords[0];
            var _mouse_world_y = _coords[1];
            draw_set_color(c_lime);
            draw_set_alpha(0.8);
            draw_line(_ultimo_ponto[0], _ultimo_ponto[1], _mouse_world_x, _mouse_world_y);
        }
        // Se já estiver patrulhando, fecha o loop visual
        else if (estado == LanchaState.PATRULHANDO && ds_list_size(pontos_patrulha) > 1) {
            var _ultimo_ponto = pontos_patrulha[| ds_list_size(pontos_patrulha) - 1];
            var _primeiro_ponto = pontos_patrulha[| 0];
            draw_line(_ultimo_ponto[0], _ultimo_ponto[1], _primeiro_ponto[0], _primeiro_ponto[1]);
        }
        
        draw_set_alpha(1.0);
    }
}
// ======================================================================
