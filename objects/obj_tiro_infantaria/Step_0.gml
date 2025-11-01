// ================================================
// HEGEMONIA GLOBAL - OBJETO: TIRO SIMPLES
// Step Event - Movimento e Colisão
// ================================================

// === TIMER DE VIDA ===
timer_vida--;
if (timer_vida <= 0) {
    scr_return_projectile_to_pool(id);
    exit;
}

// === MOVIMENTO EM DIREÇÃO AO ALVO ===
if (alvo != noone && instance_exists(alvo)) {
    // Calcular direção para o alvo
    var dir_x = alvo.x - x;
    var dir_y = alvo.y - y;
    var dist = point_distance(x, y, alvo.x, alvo.y);
    
    if (dist > 0) {
        // Normalizar direção e aplicar velocidade
        x += (dir_x / dist) * speed;
        y += (dir_y / dist) * speed;
        
        // Verificar se atingiu o alvo
        if (dist <= speed) {
            // Atingiu o alvo!
            if (instance_exists(alvo)) {
                var _dano_aplicado = (variable_instance_exists(id, "dano")) ? dano : 25;
                
                // Aplicar dano (compatível com obj_inimigo e obj_infantaria)
                if (variable_instance_exists(alvo, "vida")) {
                    alvo.vida -= _dano_aplicado;
                } else if (variable_instance_exists(alvo, "hp_atual")) {
                    alvo.hp_atual -= _dano_aplicado;
                } else if (variable_instance_exists(alvo, "hp")) {
                    alvo.hp -= _dano_aplicado;
                }
                
                // Verificar se alvo morreu
                var vida_atual = 0;
                if (variable_instance_exists(alvo, "vida")) {
                    vida_atual = alvo.vida;
                } else if (variable_instance_exists(alvo, "hp_atual")) {
                    vida_atual = alvo.hp_atual;
                } else if (variable_instance_exists(alvo, "hp")) {
                    vida_atual = alvo.hp;
                }
                
                if (vida_atual <= 0) {
                    instance_destroy(alvo);
                }
            }
            
            // === SISTEMA DE DANO EM ÁREA (APENAS TIRO DE TANQUE) ===
            if (variable_instance_exists(id, "eh_tiro_tanque") && eh_tiro_tanque) {
                var _dano_area = (variable_instance_exists(id, "dano_area")) ? dano_area : 40;
                var _raio_area = (variable_instance_exists(id, "raio_area")) ? raio_area : 80;
                var _nacao_dono = noone;
                
                // Obter nação do dono do tiro se existir
                if (variable_instance_exists(id, "dono") && instance_exists(dono)) {
                    if (variable_instance_exists(dono, "nacao_proprietaria")) {
                        _nacao_dono = dono.nacao_proprietaria;
                    }
                }
                
                // Criar explosão visual
                if (object_exists(obj_explosao_pequena)) {
                    var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_pequena);
                    if (instance_exists(_explosao)) {
                        _explosao.image_xscale = 1.2;
                        _explosao.image_yscale = 1.2;
                        show_debug_message("💥 Explosão criada no ponto de impacto do tiro do tanque!");
                    }
                }
                
                // Aplicar dano em área em soldados inimigos próximos
                with (obj_infantaria) {
                    var _eh_inimigo = true;
                    
                    // Verificar se é inimigo baseado na nação
                    if (variable_instance_exists(id, "nacao_proprietaria") && variable_instance_exists(other.dono, "nacao_proprietaria")) {
                        var _nacao_soldado = nacao_proprietaria;
                        var _nacao_dono_soldado = other.dono.nacao_proprietaria;
                        _eh_inimigo = (_nacao_soldado != _nacao_dono_soldado) && (_nacao_soldado != noone && _nacao_dono_soldado != noone);
                    }
                    
                    if (_eh_inimigo) {
                        var _dist_area = point_distance(other.x, other.y, x, y);
                        if (_dist_area <= _raio_area && _dist_area > 0) {
                            // Aplicar dano reduzido
                            if (variable_instance_exists(id, "vida")) {
                                vida -= _dano_area;
                            } else if (variable_instance_exists(id, "hp_atual")) {
                                hp_atual -= _dano_area;
                            } else if (variable_instance_exists(id, "hp")) {
                                hp -= _dano_area;
                            }
                            
                            // Verificar morte
                            var _vida_check = 0;
                            if (variable_instance_exists(id, "vida")) {
                                _vida_check = vida;
                            } else if (variable_instance_exists(id, "hp_atual")) {
                                _vida_check = hp_atual;
                            } else if (variable_instance_exists(id, "hp")) {
                                _vida_check = hp;
                            }
                            
                            if (_vida_check <= 0) {
                                instance_destroy();
                            }
                        }
                    }
                }
                
                // Aplicar dano em área em outros inimigos terrestres
                with (obj_inimigo) {
                    var _dist_area = point_distance(other.x, other.y, x, y);
                    if (_dist_area <= _raio_area && _dist_area > 0) {
                        if (variable_instance_exists(id, "vida")) {
                            vida -= _dano_area;
                        } else if (variable_instance_exists(id, "hp_atual")) {
                            hp_atual -= _dano_area;
                        }
                        
                        var _vida_check = 0;
                        if (variable_instance_exists(id, "vida")) {
                            _vida_check = vida;
                        } else if (variable_instance_exists(id, "hp_atual")) {
                            _vida_check = hp_atual;
                        }
                        
                        if (_vida_check <= 0) {
                            instance_destroy();
                        }
                    }
                }
            }
            
            // Retornar tiro ao pool
            scr_return_projectile_to_pool(id);
            exit;
        }
    } else {
        // Alvo muito próximo, retornar tiro ao pool
        scr_return_projectile_to_pool(id);
        exit;
    }
} else {
    // Alvo não existe mais, retornar tiro ao pool
    scr_return_projectile_to_pool(id);
    exit;
}
