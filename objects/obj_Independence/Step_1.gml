/// @description Step Event 1 - Sistema Específico da Independence
// ===============================================
// HEGEMONIA GLOBAL - INDEPENDENCE
// Sistema de Canhão e Metralhadora (SEM INTERFERIR NO MOVIMENTO)
// ===============================================

// === SISTEMA DE CANHÃO ===
// Criar canhão se não existir
if (!instance_exists(canhao_instancia)) {
    canhao_instancia = instance_create_layer(x + canhao_offset_x, y + canhao_offset_y, "Instances", obj_canhao);
    if (instance_exists(canhao_instancia)) {
        canhao_instancia.navio_pai = id;
        canhao_instancia.offset_x = canhao_offset_x;
        canhao_instancia.offset_y = canhao_offset_y;
        show_debug_message("🔫 Canhão da Independence criado!");
    }
}

// Atualizar posição do canhão
if (instance_exists(canhao_instancia)) {
    canhao_instancia.x = x + canhao_offset_x;
    canhao_instancia.y = y + canhao_offset_y;
    canhao_instancia.image_angle = image_angle;
}

// === SISTEMA DE METRALHADORA ===
if (metralhadora_ativa) {
    metralhadora_timer++;
    
    // Disparar tiro da metralhadora
    if (metralhadora_timer >= metralhadora_intervalo && metralhadora_tiros < metralhadora_max_tiros) {
        if (instance_exists(alvo_unidade)) {
            // Criar tiro do canhão
            var _tiro_canhao = instance_create_layer(x, y, "Instances", obj_tiro_simples);
            if (instance_exists(_tiro_canhao)) {
                _tiro_canhao.alvo = alvo_unidade;
                _tiro_canhao.dono = id;
                _tiro_canhao.dano = 25; // Dano menor por tiro
                _tiro_canhao.speed = 12; // Velocidade alta
                _tiro_canhao.direction = point_direction(x, y, alvo_unidade.x, alvo_unidade.y);
                _tiro_canhao.timer_vida = 120; // 2 segundos de vida
                
                metralhadora_tiros++;
                metralhadora_timer = 0;
                
                show_debug_message("🔫 Independence metralhando! Tiro " + string(metralhadora_tiros) + "/" + string(metralhadora_max_tiros));
            }
        }
    }
    
    // Finalizar metralhadora
    if (metralhadora_tiros >= metralhadora_max_tiros) {
        metralhadora_ativa = false;
        metralhadora_timer = 0;
        metralhadora_tiros = 0;
        show_debug_message("🔫 Independence finalizou rajada de metralhadora!");
    }
}

// === SOBRESCREVER SISTEMA DE ATAQUE ===
// Se está atacando e tem alvo, ativar metralhadora
if (estado == LanchaState.ATACANDO && instance_exists(alvo_unidade)) {
    var _distancia_alvo = point_distance(x, y, alvo_unidade.x, alvo_unidade.y);
    
    if (_distancia_alvo <= missil_alcance && reload_timer <= 0) {
        // Ativar metralhadora em vez de tiro único
        if (!metralhadora_ativa) {
            metralhadora_ativa = true;
            metralhadora_timer = 0;
            metralhadora_tiros = 0;
            reload_timer = reload_time; // Reseta o timer principal
            show_debug_message("🔫 Independence iniciou rajada de metralhadora!");
        }
    }
}
