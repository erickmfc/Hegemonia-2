// =======================
// RESFRIAMENTO DO TIRO
// =======================
if (atq_cooldown > 0) atq_cooldown--;

// =======================
// DETECÇÃO DE INIMIGOS (melhorada)
// =======================
// Procura inimigos sempre, exceto quando em movimento manual
if (estado != "movendo") {
    // Se não está atacando ou perdeu o alvo, procurar novo alvo
    if (estado != "atacando" || alvo == noone || !instance_exists(alvo)) {
        alvo = instance_nearest(x, y, obj_inimigo);
        if (alvo != noone && point_distance(x, y, alvo.x, alvo.y) <= alcance_visao) {
            estado = "atacando";
        } else {
            // Se não há alvo próximo, volta para patrulha se tiver pontos
            if (ds_list_size(patrulha) > 0) {
                estado = "patrulhando";
            } else {
                estado = "parado";
            }
        }
    }
}

// CONTROLES (iguais ao soldado, com coordenadas de mundo)
if (selecionado) {
    // Mover com clique direito
    if (mouse_check_button_pressed(mb_right) && !modo_patrulha) {
        // Mesma conversão usada na infantaria (view -> mundo)
        var world_x = camera_get_view_x(view_camera[0]) + mouse_x;
        var world_y = camera_get_view_y(view_camera[0]) + mouse_y;
        
        // Contar unidades selecionadas (infantaria + tanque)
        var unidades_selecionadas = 0;
        with (obj_infantaria) { if (selecionado) unidades_selecionadas++; }
        with (obj_tanque) { if (selecionado) unidades_selecionadas++; }
        
        if (unidades_selecionadas > 1) {
            // MÚLTIPLAS UNIDADES - MOVIMENTO EM FORMAÇÃO
            var indice_formacao = 0;
            
            // Primeiro, mover infantaria
            with (obj_infantaria) {
                if (selecionado) {
                    // Calcular posição na formação (grid 4x4 para acomodar mais unidades)
                    var coluna = indice_formacao mod 4;
                    var linha = indice_formacao div 4;
                    
                    // Offset da formação (espaçamento de 50 pixels para tanques)
                    var offset_x = (coluna - 1.5) * 50;
                    var offset_y = (linha - 1.5) * 50;
                    
                    // Posição final na formação
                    destino_x = world_x + offset_x;
                    destino_y = world_y + offset_y;
                    estado = "movendo";
                    alvo = noone;
                    image_angle = point_direction(x, y, destino_x, destino_y);
                    
                    indice_formacao++;
                }
            }
            
            // Depois, mover tanques
            with (obj_tanque) {
                if (selecionado) {
                    // Calcular posição na formação (grid 4x4)
                    var coluna = indice_formacao mod 4;
                    var linha = indice_formacao div 4;
                    
                    // Offset da formação (espaçamento de 60 pixels para tanques - maiores)
                    var offset_x = (coluna - 1.5) * 60;
                    var offset_y = (linha - 1.5) * 60;
                    
                    // Posição final na formação
                    destino_x = world_x + offset_x;
                    destino_y = world_y + offset_y;
                    estado = "movendo";
                    alvo = noone;
                    image_angle = point_direction(x, y, destino_x, destino_y);
                    
                    indice_formacao++;
                }
            }
            show_debug_message("Movimento em formação com " + string(unidades_selecionadas) + " unidades");
        } else {
            // UMA UNIDADE - MOVIMENTO NORMAL
            destino_x = world_x;
            destino_y = world_y;
            estado = "movendo";
            alvo = noone;
            image_angle = point_direction(x, y, destino_x, destino_y);
        }
    }
    
    // Patrulha (Q) - limpa patrulha anterior e inicia nova
    if (keyboard_check_pressed(ord("Q"))) {
        if (modo_patrulha) {
            // Se já está em modo patrulha, limpar e sair
            ds_list_clear(patrulha);
            modo_patrulha = false;
            estado = "parado";
        } else {
            // Entrar em modo patrulha
            ds_list_clear(patrulha);
            modo_patrulha = true;
            estado = "parado";
        }
    }
    
    // Adicionar pontos de patrulha com clique direito quando em modo patrulha
    if (modo_patrulha && mouse_check_button_pressed(mb_right)) {
        var px = camera_get_view_x(view_camera[0]) + mouse_x;
        var py = camera_get_view_y(view_camera[0]) + mouse_y;
        var pos = [px, py];
        ds_list_add(patrulha, pos);
        
        // Se é o primeiro ponto, já começa a patrulhar
        if (ds_list_size(patrulha) == 1) {
            estado = "patrulhando";
            patrulha_indice = 0;
        }
    }
    
    // Seguir (E)
    if (keyboard_check_pressed(ord("E"))) {
        var sx = camera_get_view_x(view_camera[0]) + mouse_x;
        var sy = camera_get_view_y(view_camera[0]) + mouse_y;
        var alvo_seg = instance_position(sx, sy, obj_infantaria);
        if (alvo_seg != noone && alvo_seg != id) {
            seguir_alvo = alvo_seg;
            estado = "seguindo";
        }
    }
}

// =======================
// ESTADOS
// =======================
switch (estado) {
    case "parado":
    break;
    
    case "movendo":
        if (point_distance(x, y, destino_x, destino_y) > 6) {
            // Movimento estilo infantaria (sem rastro/borrao)
            var dir = point_direction(x, y, destino_x, destino_y);
            var dx = lengthdir_x(velocidade, dir);
            var dy = lengthdir_y(velocidade, dir);
            x += dx;
            y += dy;
            image_angle = dir;
        } else {
            estado = "parado";
        }
    break;
    
    case "patrulhando":
        // Verificar se há inimigo próximo durante a patrulha
        var inimigo_proximo = instance_nearest(x, y, obj_inimigo);
        if (inimigo_proximo != noone && point_distance(x, y, inimigo_proximo.x, inimigo_proximo.y) <= alcance_visao) {
            // Inimigo detectado! Parar patrulha e atacar
            alvo = inimigo_proximo;
            estado = "atacando";
        } else if (ds_list_size(patrulha) > 0) {
            // Continuar patrulha normalmente
            var pt = patrulha[| patrulha_indice];
            var px = pt[0];
            var py = pt[1];
            if (point_distance(x, y, px, py) > 6) {
                var dirp = point_direction(x, y, px, py);
                x += lengthdir_x(velocidade, dirp);
                y += lengthdir_y(velocidade, dirp);
                image_angle = dirp;
            } else {
                patrulha_indice = (patrulha_indice + 1) mod ds_list_size(patrulha);
            }
        }
    break;
    
    case "atacando":
        if (alvo != noone && !instance_exists(alvo)) {
            // Inimigo eliminado, procurar novo alvo
            alvo = noone;
            if (ds_list_size(patrulha) > 0) {
                estado = "patrulhando";
            } else {
                estado = "parado";
            }
        } else if (alvo != noone && instance_exists(alvo)) {
            var dist = point_distance(x, y, alvo.x, alvo.y);
            
            if (dist <= alcance_tiro) {
                // Atira se estiver no alcance
                if (atq_cooldown <= 0) {
                    var b = instance_create_layer(x, y, layer, obj_tiro_infantaria);
                    b.direction = point_direction(x, y, alvo.x, alvo.y);
                    b.speed = 12;      // mais rápido que infantaria
                    b.dano = 35;       // muito mais forte
                    b.alvo = alvo;     // manter alvo
                    b.image_blend = c_yellow; // cor amarela para diferenciar
                    atq_cooldown = atq_rate;
                }
                image_angle = point_direction(x, y, alvo.x, alvo.y);
                
                // Tanque para para atirar com precisão
            } else if (dist > alcance_tiro && dist <= alcance_visao) {
                // Aproxima-se do inimigo
                var dir_x = alvo.x - x;
                var dir_y = alvo.y - y;
                var dist_norm = point_distance(0, 0, dir_x, dir_y);
                if (dist_norm > 0) {
                    var dist_ideal = alcance_tiro - 30; // Mantém distância ideal
                    var target_x = x + (dir_x / dist_norm) * (dist - dist_ideal);
                    var target_y = y + (dir_y / dist_norm) * (dist - dist_ideal);
                    
                    var dir = point_direction(x, y, target_x, target_y);
                    x += lengthdir_x(velocidade, dir);
                    y += lengthdir_y(velocidade, dir);
                    image_angle = dir;
                }
            } else {
                // Inimigo muito longe, volta para patrulha
                alvo = noone;
                if (ds_list_size(patrulha) > 0) {
                    estado = "patrulhando";
                } else {
                    estado = "parado";
                }
            }
        } else {
            // Alvo não existe mais, volta para patrulha
            alvo = noone;
            if (ds_list_size(patrulha) > 0) {
                estado = "patrulhando";
            } else {
                estado = "parado";
            }
        }
    break;
    
    case "seguindo":
        if (seguir_alvo != noone) {
            if (instance_exists(seguir_alvo)) {
                mp_potential_step(seguir_alvo.x, seguir_alvo.y, velocidade, false);
                image_angle = point_direction(x, y, seguir_alvo.x, seguir_alvo.y);
            } else {
                estado = "parado";
                seguir_alvo = noone;
            }
        }
    break;
}
