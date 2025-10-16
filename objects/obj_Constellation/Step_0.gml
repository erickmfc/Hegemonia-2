// ===============================================
// HEGEMONIA GLOBAL - CONSTELLATION FUNCIONAL
// Lógica Principal com Feedback Visual
// ===============================================

// === CONTROLE DE COMANDOS (SE SELECIONADO) ===
if (selecionado) {
    // Comando de parar (tecla S)
    if (keyboard_check_pressed(ord("S"))) {
        estado = "parado";
        alvo_unidade = noone;
        ultima_acao = "Parou";
        cor_feedback = c_yellow;
        feedback_timer = 60;
        if (variable_instance_exists(id, "debug_info")) {
            debug_info.acoes++;
        }
        show_debug_message("⏹️ Constellation PAROU");
    }
    
    // Comando de ataque (tecla A)
    if (keyboard_check_pressed(ord("A"))) {
        // Procurar inimigo mais próximo
        var _inimigo = instance_nearest(x, y, obj_inimigo);
        if (instance_exists(_inimigo) && _inimigo.nacao_proprietaria != nacao_proprietaria) {
            var _distancia = point_distance(x, y, _inimigo.x, _inimigo.y);
            if (_distancia <= missil_alcance) {
                alvo_unidade = _inimigo;
                estado = "atacando";
                ultima_acao = "Atacando " + string(_inimigo);
                cor_feedback = c_red;
                feedback_timer = 60;
                if (variable_instance_exists(id, "debug_info")) {
            debug_info.acoes++;
        }
                show_debug_message("⚔️ Constellation ATACANDO inimigo!");
            } else {
                ultima_acao = "Inimigo muito longe";
                cor_feedback = c_orange;
                feedback_timer = 60;
                show_debug_message("❌ Inimigo muito longe (" + string(round(_distancia)) + "px)");
            }
        } else {
            ultima_acao = "Nenhum inimigo";
            cor_feedback = c_orange;
            feedback_timer = 60;
            show_debug_message("❌ Nenhum inimigo encontrado");
        }
    }
}

// === MÁQUINA DE ESTADOS ===
switch (estado) {
    case "movendo":
        // Debug: verificar se está realmente movendo
        if (irandom(60) == 0) { // A cada segundo aproximadamente
            show_debug_message("🚢 Constellation MOVENDO - Estado: " + estado);
            show_debug_message("🚢 Destino: (" + string(round(destino_x)) + ", " + string(round(destino_y)) + ")");
            show_debug_message("🚢 Posição atual: (" + string(round(x)) + ", " + string(round(y)) + ")");
        }
        
        // Verificar se chegou no destino
        var _distancia = point_distance(x, y, destino_x, destino_y);
        if (_distancia < 15) {
            estado = "parado";
            ultima_acao = "Chegou ao destino";
            cor_feedback = c_green;
            feedback_timer = 60;
            show_debug_message("✅ Constellation chegou ao destino!");
        } else {
            // Mover em direção ao destino
            var _direcao = point_direction(x, y, destino_x, destino_y);
            image_angle = _direcao; // Navio aponta para o destino
            x += lengthdir_x(velocidade_movimento, _direcao);
            y += lengthdir_y(velocidade_movimento, _direcao);
        }
        break;
        
    case "atacando":
        if (instance_exists(alvo_unidade)) {
            var _distancia_alvo = point_distance(x, y, alvo_unidade.x, alvo_unidade.y);
            
            // Se inimigo está no alcance, atirar míssil
            if (_distancia_alvo <= missil_alcance && reload_timer <= 0) {
                // Usar sistema de mísseis do Constellation
                var _missil = scr_disparar_missil(alvo_unidade, "auto", x, y, id);
                if (instance_exists(_missil)) {
                    reload_timer = reload_time;
                    if (variable_instance_exists(id, "debug_info")) {
                        debug_info.misseis_disparados++;
                    }
                    
                    ultima_acao = "Míssil disparado!";
                    cor_feedback = c_red;
                    feedback_timer = 30;
                    show_debug_message("🚀 Constellation DISPAROU MÍSSIL!");
                }
            } else if (_distancia_alvo > missil_alcance) {
                // Inimigo saiu do alcance, perseguir
                destino_x = alvo_unidade.x;
                destino_y = alvo_unidade.y;
                estado = "movendo";
                ultima_acao = "Perseguindo inimigo";
                cor_feedback = c_orange;
                feedback_timer = 60;
                show_debug_message("🎯 Constellation perseguindo inimigo!");
            }
        } else {
            // Inimigo foi destruído
            estado = "parado";
            alvo_unidade = noone;
            ultima_acao = "Inimigo destruído!";
            cor_feedback = c_green;
            feedback_timer = 60;
            show_debug_message("✅ Inimigo destruído!");
        }
        break;
        
    case "patrulhando":
        if (ds_exists(pontos_patrulha, ds_type_list) && ds_list_size(pontos_patrulha) > 0) {
            var _ponto_atual = pontos_patrulha[| indice_patrulha_atual];
            var _distancia_ponto = point_distance(x, y, _ponto_atual[0], _ponto_atual[1]);
            
            if (_distancia_ponto < 20) {
                // Chegou no ponto, ir para o próximo
                indice_patrulha_atual++;
                if (indice_patrulha_atual >= ds_list_size(pontos_patrulha)) {
                    indice_patrulha_atual = 0; // Voltar ao primeiro ponto
                }
                
                ultima_acao = "Ponto " + string(indice_patrulha_atual + 1) + "/" + string(ds_list_size(pontos_patrulha));
                cor_feedback = c_aqua;
                feedback_timer = 30;
                show_debug_message("📍 Constellation: Próximo ponto de patrulha");
            } else {
                // Mover para o ponto atual
                destino_x = _ponto_atual[0];
                destino_y = _ponto_atual[1];
                var _direcao = point_direction(x, y, destino_x, destino_y);
                image_angle = _direcao;
                x += lengthdir_x(velocidade_movimento, _direcao);
                y += lengthdir_y(velocidade_movimento, _direcao);
            }
        } else {
            // Sem pontos de patrulha, voltar ao estado parado
            estado = "parado";
            ultima_acao = "Patrulha cancelada";
            cor_feedback = c_orange;
            feedback_timer = 60;
            show_debug_message("⚠️ Constellation: Sem pontos de patrulha");
        }
        break;
}

// === ATUALIZAR TIMERS ===
if (reload_timer > 0) reload_timer--;
if (feedback_timer > 0) feedback_timer--;

// === ATUALIZAR DEBUG INFO ===
if (variable_instance_exists(id, "debug_info")) {
    debug_info.estado = estado;
    debug_info.velocidade = velocidade_movimento;
    debug_info.hp = hp_atual;
}

// === DEBUG: VERIFICAR ESTADO ===
if (irandom(120) == 0) { // A cada 2 segundos aproximadamente
    show_debug_message("🔍 Constellation DEBUG - Estado: " + estado);
    show_debug_message("🔍 Destino: (" + string(round(destino_x)) + ", " + string(round(destino_y)) + ")");
    show_debug_message("🔍 Posição: (" + string(round(x)) + ", " + string(round(y)) + ")");
    show_debug_message("🔍 Selecionado: " + string(selecionado));
}