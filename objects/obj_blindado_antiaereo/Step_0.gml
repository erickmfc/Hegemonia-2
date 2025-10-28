// =======================
// RESFRIAMENTO DO TIRO
// =======================
if (atq_cooldown > 0) atq_cooldown--;

// =======================
// DETECÇÃO DE INIMIGOS AÉREOS APENAS
// =======================
// Procura apenas alvos AÉREOS sempre, exceto quando em movimento manual
if (estado != "movendo") {
    // Se não está atacando ou perdeu o alvo, procurar novo alvo
    if (estado != "atacando" || alvo == noone || !instance_exists(alvo)) {
        // Buscar inimigos AÉREOS apenas
        var _alvo_aereo = instance_nearest(x, y, obj_helicoptero_militar);
        
        // Se não encontrou helicoptero, tentar F-5
        if (_alvo_aereo == noone && object_exists(obj_caca_f5)) {
            _alvo_aereo = instance_nearest(x, y, obj_caca_f5);
        }
        
        // Se não encontrou F-5, tentar F-6
        if (_alvo_aereo == noone && object_exists(obj_f6)) {
            _alvo_aereo = instance_nearest(x, y, obj_f6);
        }
        
        // Se não encontrou F-6, tentar C-100
        if (_alvo_aereo == noone && object_exists(obj_c100)) {
            _alvo_aereo = instance_nearest(x, y, obj_c100);
        }
        
        // Se não encontrou C-100, tentar F-15
        if (_alvo_aereo == noone && object_exists(obj_f15)) {
            _alvo_aereo = instance_nearest(x, y, obj_f15);
        }
        
        alvo = _alvo_aereo;
        
        if (alvo != noone && instance_exists(alvo) && point_distance(x, y, alvo.x, alvo.y) <= alcance_visao) {
            estado = "atacando";
            show_debug_message("🎯 Blindado Anti-Aéreo detectou alvo aéreo!");
        } else {
            // Se não há alvo aéreo próximo, volta para patrulha se tiver pontos
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
        // ✅ CORREÇÃO: Usar função global para coordenadas precisas
        var _coords = global.scr_mouse_to_world();
        var world_x = _coords[0];
        var world_y = _coords[1];
        
        // ✅ CORREÇÃO CRÍTICA: Clamp para dentro da sala
        world_x = clamp(world_x, 8, room_width - 8);
        world_y = clamp(world_y, 8, room_height - 8);
        
        // Contar unidades selecionadas (infantaria + soldado anti-aéreo + tanque + blindado anti-aéreo)
        var unidades_selecionadas = 0;
        with (obj_infantaria) { if (selecionado) unidades_selecionadas++; }
        with (obj_soldado_antiaereo) { if (selecionado) unidades_selecionadas++; }
        with (obj_tanque) { if (selecionado) unidades_selecionadas++; }
        with (obj_blindado_antiaereo) { if (selecionado) unidades_selecionadas++; }
        
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
            
            // Por último, mover blindados anti-aéreos
            with (obj_blindado_antiaereo) {
                if (selecionado) {
                    // Calcular posição na formação (grid 4x4)
                    var coluna = indice_formacao mod 4;
                    var linha = indice_formacao div 4;
                    
                    // Offset da formação (espaçamento de 65 pixels para blindados - maiores que tanques)
                    var offset_x = (coluna - 1.5) * 65;
                    var offset_y = (linha - 1.5) * 65;
                    
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
        // ✅ CORREÇÃO: Usar função global para coordenadas precisas
        var _coords = global.scr_mouse_to_world();
        var px = _coords[0];
        var py = _coords[1];
        
        // ✅ CORREÇÃO CRÍTICA: Clamp para dentro da sala
        px = clamp(px, 8, room_width - 8);
        py = clamp(py, 8, room_height - 8);
        
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
        if (variable_instance_exists(id, "destino_x") && variable_instance_exists(id, "destino_y") && variable_instance_exists(id, "velocidade")) {
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
        }
    break;
    
    case "patrulhando":
        // Verificar se há alvo AÉREO próximo durante a patrulha
        var inimigo_proximo = instance_nearest(x, y, obj_helicoptero_militar);
        
        // Se não encontrou helicoptero, tentar outros aéreos
        if (inimigo_proximo == noone && object_exists(obj_caca_f5)) {
            inimigo_proximo = instance_nearest(x, y, obj_caca_f5);
        }
        if (inimigo_proximo == noone && object_exists(obj_f6)) {
            inimigo_proximo = instance_nearest(x, y, obj_f6);
        }
        if (inimigo_proximo == noone && object_exists(obj_c100)) {
            inimigo_proximo = instance_nearest(x, y, obj_c100);
        }
        if (inimigo_proximo == noone && object_exists(obj_f15)) {
            inimigo_proximo = instance_nearest(x, y, obj_f15);
        }
        
        if (inimigo_proximo != noone && instance_exists(inimigo_proximo) && point_distance(x, y, inimigo_proximo.x, inimigo_proximo.y) <= alcance_visao) {
            // Alvo aéreo detectado! Parar patrulha e atacar
            alvo = inimigo_proximo;
            estado = "atacando";
        } else if (ds_list_size(patrulha) > 0) {
            // Continuar patrulha normalmente
            var pt = ds_list_find_value(patrulha, patrulha_indice);
            if (is_array(pt) && array_length(pt) >= 2) {
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
            var dist_alvo = point_distance(x, y, alvo.x, alvo.y);
            
            // Verificar se o alvo é aéreo
            var _alvo_aereo = (alvo.object_index == obj_helicoptero_militar || 
                              alvo.object_index == obj_caca_f5 || 
                              alvo.object_index == obj_f6 ||
                              alvo.object_index == obj_c100 ||
                              alvo.object_index == obj_f15);
            
            if (_alvo_aereo && dist_alvo <= alcance_tiro) {
                // Atira se estiver no alcance E for alvo aéreo
                if (atq_cooldown <= 0) {
                    // Criar míssil SkyFury
                    var _missil = instance_create_layer(x, y, "Instances", obj_SkyFury_ar);
                    if (instance_exists(_missil)) {
                        _missil.target = alvo;
                        _missil.alvo = alvo;
                        _missil.dono = id;
                        _missil.direction = point_direction(x, y, alvo.x, alvo.y);
                        atq_cooldown = atq_rate;
                        show_debug_message("🚀 Blindado Anti-Aéreo disparou SkyFury!");
                    }
                }
                image_angle = point_direction(x, y, alvo.x, alvo.y);
                
                // Tanque para para atirar com precisão
            } else if (dist_alvo > alcance_tiro && dist_alvo <= alcance_visao && variable_instance_exists(id, "velocidade")) {
                // Aproxima-se do inimigo
                var dir_x = alvo.x - x;
                var dir_y = alvo.y - y;
                var dist_norm = point_distance(0, 0, dir_x, dir_y);
                if (dist_norm > 0) {
                    var dist_ideal = alcance_tiro - 30; // Mantém distância ideal
                    var target_x = x + (dir_x / dist_norm) * (dist_alvo - dist_ideal);
                    var target_y = y + (dir_y / dist_norm) * (dist_alvo - dist_ideal);
                    
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
            if (instance_exists(seguir_alvo) && variable_instance_exists(id, "velocidade")) {
                mp_potential_step(seguir_alvo.x, seguir_alvo.y, velocidade, false);
                image_angle = point_direction(x, y, seguir_alvo.x, seguir_alvo.y);
            } else {
                estado = "parado";
                seguir_alvo = noone;
            }
        }
    break;
}
