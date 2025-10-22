// ===============================================
// HEGEMONIA GLOBAL - LÓGICA COMUM DE UNIDADES
// Scripts Compartilhados para Todas as Unidades
// ===============================================

/// @description Mover unidade para destino
/// @param {real} unidade_id ID da unidade
/// @param {real} destino_x Posição X de destino
/// @param {real} destino_y Posição Y de destino
/// @return {bool} true se movimento iniciado
function scr_mover_unidade(unidade_id, destino_x, destino_y) {
    if (!instance_exists(unidade_id)) {
        return false;
    }
    
    // Verificar se unidade pode se mover
    if (unidade_id.cooldown_movimento > 0) {
        return false;
    }
    
    // Verificar se unidade não está em combate
    if (unidade_id.estado == "atacando") {
        return false;
    }
    
    // Configurar movimento
    unidade_id.destino_x = destino_x;
    unidade_id.destino_y = destino_y;
    unidade_id.estado = "movendo";
    unidade_id.velocidade_atual = unidade_id.velocidade_movimento;
    
    return true;
}

/// @description Atacar alvo
/// @param {real} unidade_id ID da unidade
/// @param {real} alvo_id ID do alvo
/// @return {bool} true se ataque iniciado
function scr_atacar_alvo(unidade_id, alvo_id) {
    if (!instance_exists(unidade_id) || !instance_exists(alvo_id)) {
        return false;
    }
    
    // Verificar se unidade pode atacar
    if (unidade_id.cooldown_ataque > 0) {
        return false;
    }
    
    // Verificar se alvo está no alcance
    var _distancia = point_distance(unidade_id.x, unidade_id.y, alvo_id.x, alvo_id.y);
    if (_distancia > unidade_id.raio_ataque) {
        return false;
    }
    
    // Configurar ataque
    unidade_id.alvo_inimigo = alvo_id;
    unidade_id.estado = "atacando";
    unidade_id.cooldown_ataque = unidade_id.velocidade_ataque;
    
    return true;
}

/// @description Calcular dano de ataque
/// @param {real} unidade_id ID da unidade
/// @param {real} alvo_id ID do alvo
/// @return {real} Dano causado
function scr_calcular_dano(unidade_id, alvo_id) {
    if (!instance_exists(unidade_id) || !instance_exists(alvo_id)) {
        return 0;
    }
    
    var _dano_base = unidade_id.dano_base;
    var _dano_variavel = unidade_id.dano_variavel;
    var _dano_final = _dano_base + random_range(-_dano_variavel, _dano_variavel);
    
    // Aplicar bônus de nível
    _dano_final += _dano_final * (unidade_id.nivel - 1) * unidade_id.bonus_nivel_dano;
    
    // Aplicar bônus de equipamento
    _dano_final += _dano_final * unidade_id.bonus_equipamento;
    
    // Aplicar eficiência de combate
    _dano_final *= unidade_id.eficiencia_combate;
    
    // Aplicar redução de armadura do alvo
    if (variable_instance_exists(alvo_id, "armadura")) {
        _dano_final -= alvo_id.armadura;
    }
    
    // Garantir dano mínimo
    if (_dano_final < 1) {
        _dano_final = 1;
    }
    
    return _dano_final;
}

/// @description Aplicar dano a unidade
/// @param {real} unidade_id ID da unidade
/// @param {real} dano Dano a ser aplicado
function scr_aplicar_dano(unidade_id, dano) {
    if (!instance_exists(unidade_id)) {
        return;
    }
    
    unidade_id.hp_atual -= dano;
    
    // Verificar se unidade foi destruída
    if (unidade_id.hp_atual <= 0) {
        unidade_id.hp_atual = 0;
        unidade_id.estado = "destruida";
        
        // Aplicar experiência ao atacante se houver
        if (instance_exists(unidade_id.ultimo_atacante)) {
            var _exp_ganha = 10 + (unidade_id.nivel * 5);
            unidade_id.ultimo_atacante.experiencia += _exp_ganha;
        }
        
        // Destruir unidade
        instance_destroy(unidade_id);
    }
}

/// @description Verificar se unidade pode se mover para posição
/// @param {real} unidade_id ID da unidade
/// @param {real} x Posição X
/// @param {real} y Posição Y
/// @return {bool} true se pode se mover
function scr_unidade_pode_mover_para(unidade_id, x, y) {
    if (!instance_exists(unidade_id)) {
        return false;
    }
    
    // Verificar se posição está dentro dos limites do mapa
    if (x < 0 || y < 0 || x > room_width || y > room_height) {
        return false;
    }
    
    // === VERIFICAÇÃO DE COLISÃO COM EDIFÍCIOS ===
    // Apenas unidades terrestres respeitam colisão com edifícios
    if (scr_unidade_deve_respeitar_colisao_edificios(unidade_id)) {
        // Lista de todos os edifícios que impedem movimento
        var _edificios_obstaculos = [
            obj_casa,
            obj_banco,
            obj_fazenda,
            obj_quartel,
            obj_quartel_marinha,
            obj_aeroporto_militar,
            obj_research_center
        ];
        
        // Verificar colisão com cada edifício
        for (var i = 0; i < array_length(_edificios_obstaculos); i++) {
            var _edificio_obj = _edificios_obstaculos[i];
            if (object_exists(_edificio_obj)) {
                // Verificar se há colisão com o edifício
                if (position_meeting(x, y, _edificio_obj)) {
                    show_debug_message("🚫 Movimento terrestre bloqueado: Colisão com " + object_get_name(_edificio_obj));
                    return false;
                }
            }
        }
    } else {
        // Unidades aéreas e navais podem passar por edifícios
        var _tipo = scr_identificar_tipo_unidade(unidade_id);
        if (global.debug_enabled) {
            show_debug_message("✈️ Unidade " + _tipo + " pode passar por edifícios");
        }
    }
    
    // Verificar se unidade pode se mover na água
    if (!unidade_id.pode_mover_agua) {
        // Aqui você pode adicionar verificação de tile de água
        // Por enquanto, assumir que pode se mover
    }
    
    // Verificar se unidade pode se mover na terra
    if (!unidade_id.pode_mover_terra) {
        // Aqui você pode adicionar verificação de tile de terra
        // Por enquanto, assumir que pode se mover
    }
    
    // Verificar se unidade pode se mover na montanha
    if (!unidade_id.pode_mover_montanha) {
        // Aqui você pode adicionar verificação de tile de montanha
        // Por enquanto, assumir que pode se mover
    }
    
    return true;
}

/// @description Atualizar estado da unidade
/// @param {real} unidade_id ID da unidade
function scr_atualizar_estado_unidade(unidade_id) {
    if (!instance_exists(unidade_id)) {
        return;
    }
    
    // Atualizar tempo no estado atual
    unidade_id.tempo_no_estado++;
    
    // Verificar transições de estado
    switch (unidade_id.estado) {
        case "movendo":
            // Verificar se chegou ao destino
            var _distancia = point_distance(unidade_id.x, unidade_id.y, unidade_id.destino_x, unidade_id.destino_y);
            if (_distancia < 5) {
                unidade_id.estado = "parado";
                unidade_id.destino_x = unidade_id.x;
                unidade_id.destino_y = unidade_id.y;
            }
            break;
            
        case "atacando":
            // Verificar se alvo ainda existe
            if (!instance_exists(unidade_id.alvo_inimigo)) {
                unidade_id.estado = "parado";
                unidade_id.alvo_inimigo = noone;
            }
            break;
            
        case "parado":
            // Unidade em repouso
            break;
            
        case "destruida":
            // Unidade foi destruída
            break;
    }
}
