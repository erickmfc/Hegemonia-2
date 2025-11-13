/// @description Sistema de combate unificado para todas as unidades
/// @param {Id.Instance} atacante_id ID da instância do atacante
/// @param {Id.Instance} alvo_id ID da instância do alvo
/// @param {string} tipo_ataque Tipo de ataque (opcional)
/// @return {bool} Sucesso do ataque

function scr_combate_unificado(atacante_id, alvo_id, tipo_ataque = "padrao") {
    // Verificar se ambas as instâncias existem
    if (!instance_exists(atacante_id) || !instance_exists(alvo_id)) {
        scr_debug_log("COMBATE", "Erro: Atacante ou alvo não existe");
        return false;
    }
    
    var atacante = atacante_id;
    var alvo = alvo_id;
    
    // Verificar se são inimigos
    if (!scr_sao_inimigos(atacante, alvo)) {
        scr_debug_log("COMBATE", "Erro: Unidades não são inimigas");
        return false;
    }
    
    // Calcular distância
    var distancia = point_distance(atacante.x, atacante.y, alvo.x, alvo.y);
    
    // Verificar alcance
    var alcance_atacante = scr_obter_alcance(atacante);
    if (distancia > alcance_atacante) {
        scr_debug_log("COMBATE", "Erro: Alvo fora de alcance (" + string(distancia) + " > " + string(alcance_atacante) + ")");
        return false;
    }
    
    // Verificar cooldown
    if (variable_instance_exists(atacante, "atq_cooldown") && atacante.atq_cooldown > 0) {
        scr_debug_log("COMBATE", "Erro: Atacante em cooldown");
        return false;
    }
    
    // Executar ataque baseado no tipo
    var sucesso = false;
    switch (tipo_ataque) {
        case "direto":
            sucesso = scr_ataque_direto(atacante, alvo);
            break;
        case "projetil":
            sucesso = scr_ataque_projetil(atacante, alvo);
            break;
        case "area":
            sucesso = scr_ataque_area(atacante, alvo);
            break;
        default:
            sucesso = scr_ataque_padrao(atacante, alvo);
            break;
    }
    
    if (sucesso) {
        // Resetar cooldown
        if (variable_instance_exists(atacante, "atq_rate")) {
            atacante.atq_cooldown = atacante.atq_rate;
        }
        
        // Atualizar estado
        if (variable_instance_exists(atacante, "estado")) {
            atacante.estado = "atacando";
        }
        
        // Atualizar direção visual
        atacante.image_angle = point_direction(atacante.x, atacante.y, alvo.x, alvo.y);
        
        scr_debug_log("COMBATE", "Ataque executado com sucesso: " + string(atacante.object_index) + " -> " + string(alvo.object_index));
    }
    
    return sucesso;
}

/// @description Verificar se duas unidades são inimigas
function scr_sao_inimigos(unidade1, unidade2) {
    if (!variable_instance_exists(unidade1, "nacao_proprietaria") || 
        !variable_instance_exists(unidade2, "nacao_proprietaria")) {
        return false;
    }
    
    return unidade1.nacao_proprietaria != unidade2.nacao_proprietaria;
}

/// @description Obter alcance de ataque da unidade
function scr_obter_alcance(unidade) {
    if (variable_instance_exists(unidade, "alcance")) {
        return unidade.alcance;
    }
    
    // Alcances padrão baseados no tipo de unidade
    switch (unidade.object_index) {
        case obj_lancha_patrulha:
        case obj_fragata:
        case obj_destroyer:
        case obj_submarino:
        case obj_RonaldReagan:
            return 400; // Alcance naval
        case obj_soldado:
        case obj_soldado_antiaereo:
            return 300; // Alcance de infantaria
        case obj_blindado:
        case obj_tanque:
            return 350; // Alcance de veículos
        default:
            return 300; // Alcance padrão
    }
}

/// @description Ataque padrão (dano direto)
function scr_ataque_padrao(atacante, alvo) {
    var dano = scr_calcular_dano(atacante, alvo);
    scr_aplicar_dano(alvo, dano);
    
    scr_debug_log("COMBATE", "Ataque direto: " + string(dano) + " de dano");
    return true;
}

/// @description Ataque direto (sem projétil)
function scr_ataque_direto(atacante, alvo) {
    var dano = scr_calcular_dano(atacante, alvo);
    scr_aplicar_dano(alvo, dano);
    
    scr_debug_log("COMBATE", "Ataque direto: " + string(dano) + " de dano");
    return true;
}

/// @description Ataque com projétil
function scr_ataque_projetil(atacante, alvo) {
    // Determinar tipo de projétil baseado no atacante
    var tipo_projetil = obj_tiro_infantaria; // Padrão
    
    switch (atacante.object_index) {
        case obj_lancha_patrulha:
        case obj_fragata:
        case obj_destroyer:
        case obj_submarino:
        case obj_RonaldReagan:
            tipo_projetil = obj_projetil_naval;
            break;
        case obj_soldado:
        case obj_soldado_antiaereo:
            tipo_projetil = obj_tiro_infantaria;
            break;
        case obj_blindado:
        case obj_tanque:
            tipo_projetil = obj_tiro_blindado;
            break;
    }
    
    // Criar projétil
    var proj = instance_create_layer(atacante.x, atacante.y, atacante.layer, tipo_projetil);
    if (instance_exists(proj)) {
        proj.direction = point_direction(atacante.x, atacante.y, alvo.x, alvo.y);
        proj.speed = 8;
        proj.dano = scr_calcular_dano(atacante, alvo);
        proj.alvo = alvo;
        proj.atirador = atacante;
        
        scr_debug_log("COMBATE", "Projétil criado: " + string(tipo_projetil));
        return true;
    }
    
    return false;
}

/// @description Ataque em área
function scr_ataque_area(atacante, alvo) {
    var dano = scr_calcular_dano(atacante, alvo);
    var raio_area = 100; // Raio do ataque em área
    
    // Aplicar dano ao alvo principal
    scr_aplicar_dano(alvo, dano);
    
    // Aplicar dano reduzido a unidades próximas
    with (all) {
        if (id != alvo.id && scr_sao_inimigos(atacante, id)) {
            var dist = point_distance(atacante.x, atacante.y, x, y);
            if (dist <= raio_area) {
                var dano_area = dano * 0.5; // 50% do dano
                scr_aplicar_dano(id, dano_area);
            }
        }
    }
    
    scr_debug_log("COMBATE", "Ataque em área: " + string(dano) + " de dano");
    return true;
}

/// @description Calcular dano do ataque
function scr_calcular_dano(atacante, alvo) {
    var dano_base = 25; // Dano padrão
    
    if (variable_instance_exists(atacante, "dano")) {
        dano_base = atacante.dano;
    }
    
    // Aplicar modificadores
    var dano_final = dano_base;
    
    // Bônus de nível
    if (variable_instance_exists(atacante, "nivel")) {
        dano_final += dano_final * (atacante.nivel - 1) * 0.1; // 10% por nível
    }
    
    // Bônus de experiência
    if (variable_instance_exists(atacante, "experiencia")) {
        dano_final += dano_final * (atacante.experiencia / 1000) * 0.05; // 5% por 1000 XP
    }
    
    // Redução de armadura do alvo
    if (variable_instance_exists(alvo, "armadura")) {
        dano_final -= alvo.armadura;
    }
    
    // Garantir dano mínimo
    if (dano_final < 1) {
        dano_final = 1;
    }
    
    return dano_final;
}

/// @description Aplicar dano a uma unidade
function scr_aplicar_dano(unidade, dano) {
    if (!instance_exists(unidade)) {
        return;
    }
    
    if (variable_instance_exists(unidade, "hp_atual")) {
        unidade.hp_atual -= dano;
        
        // Verificar se foi destruída
        if (unidade.hp_atual <= 0) {
            unidade.hp_atual = 0;
            
            // ✅ NOVO: Verificar se é um avião antes de destruir
            var _eh_aviao = false;
            var _sprite_aviao = noone;
            var _angulo_aviao = 0;
            var _pos_x = unidade.x;
            var _pos_y = unidade.y;
            
            // Lista de objetos de avião
            if (unidade.object_index == obj_f15 || 
                unidade.object_index == obj_su35 || 
                unidade.object_index == obj_c100 || 
                unidade.object_index == obj_caca_f5 || 
                unidade.object_index == obj_helicoptero_militar || 
                unidade.object_index == obj_f6 ||
                unidade.object_index == obj_SkyFury_ar) {
                
                _eh_aviao = true;
                _sprite_aviao = unidade.sprite_index;
                _angulo_aviao = unidade.image_angle;
            }
            
            if (variable_instance_exists(unidade, "estado")) {
                unidade.estado = "destruida";
            }
            
            // Dar experiência ao atacante se houver
            if (instance_exists(unidade.ultimo_atacante)) {
                if (variable_instance_exists(unidade.ultimo_atacante, "experiencia")) {
                    unidade.ultimo_atacante.experiencia += 10;
                }
            }
            
            scr_debug_log("COMBATE", "Unidade destruída: " + string(unidade.object_index));
            
            // ✅ NOVO: Se for avião, criar objeto de avião morto antes de destruir
            if (_eh_aviao) {
                scr_criar_aviao_morto(_pos_x, _pos_y, _angulo_aviao, _sprite_aviao);
            }
            
            instance_destroy(unidade);
        } else {
            scr_debug_log("COMBATE", "Dano aplicado: " + string(dano) + " HP restante: " + string(unidade.hp_atual));
        }
    }
}