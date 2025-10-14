// ===============================================
// OBJ_TANQUE - STEP EVENT (SISTEMA P / O / L / K)
// ===============================================

// --- 1. RESFRIAMENTO DO ATAQUE ---
if (timer_ataque > 0) timer_ataque--;

// --- 1.5. SISTEMA VISUAL RTS ---
// Sincroniza selected com selecionado
selected = selecionado;

// Controla indicadores visuais baseado no estado de seleção
if (selecionado) {
    mostrar_area_tiro = true;
    mostrar_info = true;
    
    // Fade-in suave
    if (fade_alpha < 1) {
        fade_alpha += fade_speed;
        if (fade_alpha > 1) fade_alpha = 1;
    }
} else {
    mostrar_area_tiro = false;
    mostrar_info = false;
    
    // Fade-out suave
    if (fade_alpha > 0) {
        fade_alpha -= fade_speed;
        if (fade_alpha < 0) fade_alpha = 0;
    }
}

// Atualiza modos visuais baseado no estado real
modo_ataque = (modo_combate == "ataque");
modo_defesa = (modo_combate == "passivo");
modo_parado = (estado == "parado");

// =====================================================
// === 1.6. CANCELAR PATRULHA QUANDO RECEBE NOVA ORDEM ===
// =====================================================
// Se o tanque recebeu uma nova ordem de movimento, cancela patrulha
if (estado == "movendo" && modo_definicao_patrulha) {
    modo_definicao_patrulha = false;
    patrulhando = false;
    show_debug_message("🔄 Patrulha cancelada - nova ordem de movimento recebida");
}

// ======================================================
// === 2. CONTROLES DE TECLADO (SOMENTE SELECIONADO) ===
// ======================================================
if (selecionado) {

    // --- (P) MODO PASSIVO ---
    if (keyboard_check_pressed(ord("P"))) {
        modo_combate = "passivo";
        estado = "parado";
        alvo = noone;
        show_debug_message("🟢 Tanque em modo PASSIVO - só revida se atacado");
    }

    // --- (O) MODO ATAQUE ---
    if (keyboard_check_pressed(ord("O"))) {
        modo_combate = "ataque";
        show_debug_message("🔴 Tanque em modo ATAQUE - procura inimigos automaticamente");
    }

    // --- (L) PARAR ---
    if (keyboard_check_pressed(ord("L"))) {
        estado = "parado";
        alvo = noone;
        patrulhando = false;
        modo_definicao_patrulha = false;
        show_debug_message("⏹️ Tanque PAROU");
    }

    // --- (K) MODO PATRULHA ---
    if (keyboard_check_pressed(ord("K"))) {
        // Usar sistema global de patrulha
        global.definindo_patrulha_unidade = id;
        ds_list_clear(pontos_patrulha);
        modo_definicao_patrulha = true;
        estado = "parado";
        show_debug_message("📍 MODO PATRULHA ATIVADO - clique esquerdo para adicionar pontos, direito para confirmar.");
    }
}

// =====================================================
// === 3. LÓGICA DE COMBATE AUTOMÁTICO (MODO ATAQUE) ===
// =====================================================
if (modo_combate == "ataque" && estado != "movendo" && !modo_definicao_patrulha) {
    if (alvo == noone || !instance_exists(alvo)) {
        // Procura inimigos próximos
        var inimigo = instance_nearest(x, y, obj_inimigo);
        if (inimigo != noone && point_distance(x, y, inimigo.x, inimigo.y) <= alcance_visao) {
            alvo = inimigo;
            estado = "atacando";
            show_debug_message("🎯 Tanque encontrou inimigo! Distância: " + string(point_distance(x, y, inimigo.x, inimigo.y)));
        }
    }
}

// =====================================================
// === 4. AUTODEFESA PASSIVA (MODO PASSIVO) ===
// =====================================================
// No modo passivo, o tanque só revida se for atacado
if (modo_combate == "passivo" && estado != "movendo" && !modo_definicao_patrulha) {
    // Verifica se há inimigos muito próximos (ameaça imediata)
    var inimigo_proximo = instance_nearest(x, y, obj_inimigo);
    if (inimigo_proximo != noone && point_distance(x, y, inimigo_proximo.x, inimigo_proximo.y) <= alcance_tiro) {
        // Se inimigo está no alcance de tiro, considera como ameaça e revida
        alvo = inimigo_proximo;
        estado = "atacando";
        show_debug_message("🛡️ Tanque em AUTODEFESA - inimigo muito próximo!");
    }
}

// ==================================================
// === 5. EXECUÇÃO DOS ESTADOS PRINCIPAIS DO TANQUE ===
// ==================================================
switch (estado) {
    
    case "parado":
        // Nada – aguarda comando
    break;

    case "movendo":
        if (point_distance(x, y, destino_x, destino_y) > 6) {
            var dir = point_direction(x, y, destino_x, destino_y);
            x += lengthdir_x(velocidade, dir);
            y += lengthdir_y(velocidade, dir);
            image_angle = dir;
        } else {
            estado = "parado";
            // Só volta para patrulha se ainda estiver patrulhando E não estiver em modo de definição
            if (patrulhando && ds_list_size(pontos_patrulha) > 0 && !modo_definicao_patrulha) {
                estado = "patrulhando";
                show_debug_message("🔄 Voltando à patrulha após movimento");
            } else {
                show_debug_message("⏸️ Tanque parou - patrulha cancelada");
            }
        }
    break;

    case "patrulhando":
        if (ds_list_size(pontos_patrulha) > 0) {
            var ponto = pontos_patrulha[| indice_patrulha];
            var px = ponto[0];
            var py = ponto[1];

            // CORREÇÃO: Verificar inimigos próximos durante patrulha
            var inimigo_proximo = instance_nearest(x, y, obj_inimigo);
            if (inimigo_proximo != noone && point_distance(x, y, inimigo_proximo.x, inimigo_proximo.y) <= alcance_visao) {
                // Se encontrou inimigo próximo, atacar
                alvo = inimigo_proximo;
                estado = "atacando";
                show_debug_message("🎯 Tanque em patrulha encontrou inimigo! Atacando...");
            } else if (point_distance(x, y, px, py) > 6) {
                // Continuar patrulha normalmente
                var dir = point_direction(x, y, px, py);
                x += lengthdir_x(velocidade, dir);
                y += lengthdir_y(velocidade, dir);
                image_angle = dir;
            } else {
                indice_patrulha = (indice_patrulha + 1) mod ds_list_size(pontos_patrulha);
            }
        } else {
            estado = "parado";
            patrulhando = false;
        }
    break;

    case "atacando":
        if (alvo != noone && instance_exists(alvo)) {
            var dist = point_distance(x, y, alvo.x, alvo.y);

            if (dist <= alcance_tiro) {
                // Apontar para o alvo
                image_angle = point_direction(x, y, alvo.x, alvo.y);
                
                // Atirar se o timer permitir
                if (timer_ataque <= 0) {
                    var b = instance_create_layer(x, y, layer, projetil_objeto);
                    b.direction = point_direction(x, y, alvo.x, alvo.y);
                    b.speed = 8;
                    b.dano = 25;
                    b.alvo = alvo; // Definir alvo do projétil
                    timer_ataque = intervalo_ataque;
                    show_debug_message("💥 Tanque ATIROU! Timer resetado para " + string(intervalo_ataque));
                }
            } else if (dist <= alcance_visao) {
                // Perseguir o alvo
                var dir = point_direction(x, y, alvo.x, alvo.y);
                x += lengthdir_x(velocidade, dir);
                y += lengthdir_y(velocidade, dir);
                image_angle = dir;
                show_debug_message("🏃 Tanque perseguindo inimigo - Distância: " + string(dist));
            } else {
                // CORREÇÃO: Alvo muito longe, voltar para patrulha se estava patrulhando
                alvo = noone;
                if (patrulhando && ds_list_size(pontos_patrulha) > 0) {
                    estado = "patrulhando";
                    show_debug_message("🔄 Tanque voltando à patrulha após perder alvo");
                } else {
                    estado = "parado";
                    show_debug_message("⏸️ Tanque parou após perder alvo");
                }
            }
        } else {
            // CORREÇÃO: Alvo não existe mais, voltar para patrulha se estava patrulhando
            alvo = noone;
            if (patrulhando && ds_list_size(pontos_patrulha) > 0) {
                estado = "patrulhando";
                show_debug_message("🔄 Tanque voltando à patrulha - alvo eliminado");
            } else {
                estado = "parado";
                show_debug_message("⏸️ Tanque parou - alvo eliminado");
            }
        }
    break;
}