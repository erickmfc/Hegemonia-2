// ================================================
// HEGEMONIA GLOBAL - OBJETO: TIRO SIMPLES
// Step Event - Movimento e Colisão
// ================================================

// === VERIFICAÇÃO DE SEGURANÇA ===
// ✅ VERIFICAÇÃO DE SEGURANÇA: Se está invisível ou desativado, não processar
if (!visible || image_alpha <= 0 || speed <= 0) {
    // Projétil já foi acertado ou está sendo desativado
    exit;
}

// === TIMER DE VIDA ===
timer_vida--;
if (timer_vida <= 0) {
    // ✅ CRÍTICO: Destruir projétil IMEDIATAMENTE quando timer expira
    visible = false;
    image_alpha = 0;
    image_xscale = 0;
    image_yscale = 0;
    speed = 0;
    
    // ✅ DESATIVAR IMEDIATAMENTE
    instance_deactivate_object(id);
    
    // ✅ TENTAR RETORNAR AO POOL, MAS SE FALHAR, DESTRUIR DIRETAMENTE
    var _pool_mgr = instance_find(obj_projectile_pool_manager, 0);
    if (!instance_exists(_pool_mgr) || !_pool_mgr.pool_enabled) {
        // Pool não disponível - destruir diretamente
        instance_destroy(id);
    } else {
        // Tentar retornar ao pool
        scr_return_projectile_to_pool(id);
    }
    
    exit;
}

// === MOVIMENTO EM DIREÇÃO AO ALVO ===
if (alvo != noone && instance_exists(alvo)) {
    // ✅ GUARDAR POSIÇÃO ANTERIOR (para detecção de colisão por linha)
    var _x_anterior = x;
    var _y_anterior = y;
    
    // Calcular direção para o alvo
    var dir_x = alvo.x - x;
    var dir_y = alvo.y - y;
    var dist = point_distance(x, y, alvo.x, alvo.y);
    
    if (dist > 0) {
        // Normalizar direção e aplicar velocidade
        x += (dir_x / dist) * speed;
        y += (dir_y / dist) * speed;
        
        // ✅ CORREÇÃO CRÍTICA: Verificar colisão usando linha (detecta se passou pelo alvo)
        var _distancia_atual = point_distance(x, y, alvo.x, alvo.y);
        var _distancia_anterior = point_distance(_x_anterior, _y_anterior, alvo.x, alvo.y);
        
        // ✅ NOVO: Verificar se passou pelo alvo (distância anterior > atual) OU se está muito perto
        var _raio_colisao = 25; // Raio fixo maior para garantir detecção
        var _passou_pelo_alvo = (_distancia_anterior > _distancia_atual && _distancia_atual <= _raio_colisao);
        var _esta_muito_perto = (_distancia_atual <= _raio_colisao);
        
        // ✅ CORREÇÃO: Também verificar colisão por linha (mais preciso para projéteis rápidos)
        var _colisao_linha = false;
        if (variable_instance_exists(alvo, "sprite_index") && sprite_exists(alvo.sprite_index)) {
            _colisao_linha = collision_line(_x_anterior, _y_anterior, x, y, alvo, false, true);
        }
        
        // Verificar se atingiu o alvo
        if (_passou_pelo_alvo || _esta_muito_perto || _colisao_linha || dist <= speed) {
            // ✅ CORREÇÃO CRÍTICA: Guardar posição do alvo ANTES de aplicar dano (pode ser destruído)
            var _explosao_x = x; // Posição do projétil como fallback
            var _explosao_y = y;
            if (instance_exists(alvo)) {
                _explosao_x = alvo.x;
                _explosao_y = alvo.y;
            }
            
            // Atingiu o alvo!
            if (instance_exists(alvo)) {
                var _dano_aplicado = (variable_instance_exists(id, "dano")) ? dano : 25;
                
                // ✅ NOVO: Verificar se é o primeiro dano antes de aplicar
                var _primeiro_dano = false;
                var _hp_max_alvo = 1;
                if (variable_instance_exists(alvo, "hp_atual") && variable_instance_exists(alvo, "hp_max")) {
                    _primeiro_dano = (alvo.hp_atual >= alvo.hp_max);
                    _hp_max_alvo = alvo.hp_max;
                } else if (variable_instance_exists(alvo, "vida") && variable_instance_exists(alvo, "vida_max")) {
                    _primeiro_dano = (alvo.vida >= alvo.vida_max);
                    _hp_max_alvo = alvo.vida_max;
                } else if (variable_instance_exists(alvo, "hp") && variable_instance_exists(alvo, "hp_max")) {
                    _primeiro_dano = (alvo.hp >= alvo.hp_max);
                    _hp_max_alvo = alvo.hp_max;
                }
                
                // Aplicar dano (compatível com obj_inimigo e obj_infantaria)
                if (variable_instance_exists(alvo, "vida")) {
                    alvo.vida -= _dano_aplicado;
                    
                    // ✅ NOVO: Ativar exibição de vida quando for atingida pela primeira vez
                    if (_primeiro_dano && alvo.vida < alvo.vida_max && alvo.vida > 0) {
                        alvo.mostrar_vida = true;
                        alvo.timer_vida_visivel = 0;
                        var _porcentagem = round((alvo.vida / alvo.vida_max) * 100);
                        show_debug_message("💥 " + object_get_name(alvo.object_index) + " atingido pela primeira vez! Vida: " + string(alvo.vida) + "/" + string(alvo.vida_max) + " (" + string(_porcentagem) + "%)");
                    } else if (alvo.vida < alvo.vida_max && alvo.vida > 0) {
                        if (!variable_instance_exists(alvo, "mostrar_vida")) {
                            alvo.mostrar_vida = true;
                        }
                        alvo.timer_vida_visivel = 0;
                    }
                } else if (variable_instance_exists(alvo, "hp_atual")) {
                    alvo.hp_atual -= _dano_aplicado;
                    
                    // ✅ NOVO: Ativar exibição de vida quando for atingida pela primeira vez
                    if (_primeiro_dano && alvo.hp_atual < alvo.hp_max && alvo.hp_atual > 0) {
                        alvo.mostrar_vida = true;
                        alvo.timer_vida_visivel = 0;
                        var _porcentagem = round((alvo.hp_atual / alvo.hp_max) * 100);
                        show_debug_message("💥 " + object_get_name(alvo.object_index) + " atingido pela primeira vez! HP: " + string(alvo.hp_atual) + "/" + string(alvo.hp_max) + " (" + string(_porcentagem) + "%)");
                    } else if (alvo.hp_atual < alvo.hp_max && alvo.hp_atual > 0) {
                        if (!variable_instance_exists(alvo, "mostrar_vida")) {
                            alvo.mostrar_vida = true;
                        }
                        alvo.timer_vida_visivel = 0;
                    }
                } else if (variable_instance_exists(alvo, "hp")) {
                    alvo.hp -= _dano_aplicado;
                    
                    // ✅ NOVO: Ativar exibição de vida quando for atingida pela primeira vez
                    if (_primeiro_dano && alvo.hp < alvo.hp_max && alvo.hp > 0) {
                        alvo.mostrar_vida = true;
                        alvo.timer_vida_visivel = 0;
                        var _porcentagem = round((alvo.hp / alvo.hp_max) * 100);
                        show_debug_message("💥 " + object_get_name(alvo.object_index) + " atingido pela primeira vez! HP: " + string(alvo.hp) + "/" + string(alvo.hp_max) + " (" + string(_porcentagem) + "%)");
                    } else if (alvo.hp < alvo.hp_max && alvo.hp > 0) {
                        if (!variable_instance_exists(alvo, "mostrar_vida")) {
                            alvo.mostrar_vida = true;
                        }
                        alvo.timer_vida_visivel = 0;
                    }
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
                    // ✅ CORREÇÃO: Verificar se função existe antes de chamar
                    var _script_restos = asset_get_index("scr_criar_restos_unidade");
                    if (_script_restos != -1) {
                        scr_criar_restos_unidade(alvo);
                    }
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
                
                // ✅ CORREÇÃO: Usar posição guardada do alvo para explosão (já foi guardada acima)
                
                // Criar explosão visual
                if (object_exists(obj_explosao_pequena)) {
                    var _explosao = instance_create_layer(_explosao_x, _explosao_y, "Efeitos", obj_explosao_pequena);
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
                // ✅ CORREÇÃO: obj_inimigo removido - buscar apenas obj_infantaria
                with (obj_infantaria) {
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
            
            // ✅ CRÍTICO: Destruir projétil IMEDIATAMENTE após acertar
            // ✅ FORÇAR: Tornar invisível e desativar ANTES de retornar ao pool
            visible = false;
            image_alpha = 0;
            image_xscale = 0;
            image_yscale = 0;
            speed = 0;
            
            // ✅ DESATIVAR IMEDIATAMENTE
            instance_deactivate_object(id);
            
            // ✅ TENTAR RETORNAR AO POOL, MAS SE FALHAR, DESTRUIR DIRETAMENTE
            var _pool_mgr = instance_find(obj_projectile_pool_manager, 0);
            if (!instance_exists(_pool_mgr) || !_pool_mgr.pool_enabled) {
                // Pool não disponível - destruir diretamente
                instance_destroy(id);
            } else {
                // Tentar retornar ao pool
                scr_return_projectile_to_pool(id);
            }
            
            exit;
        }
    } else {
        // Alvo muito próximo, destruir tiro
        visible = false;
        image_alpha = 0;
        speed = 0;
        instance_deactivate_object(id);
        var _pool_mgr = instance_find(obj_projectile_pool_manager, 0);
        if (!instance_exists(_pool_mgr) || !_pool_mgr.pool_enabled) {
            instance_destroy(id);
        } else {
            scr_return_projectile_to_pool(id);
        }
        exit;
    }
} else {
    // Alvo não existe mais, destruir tiro
    visible = false;
    image_alpha = 0;
    speed = 0;
    instance_deactivate_object(id);
    var _pool_mgr = instance_find(obj_projectile_pool_manager, 0);
    if (!instance_exists(_pool_mgr) || !_pool_mgr.pool_enabled) {
        instance_destroy(id);
    } else {
        scr_return_projectile_to_pool(id);
    }
    exit;
}
