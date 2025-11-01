// ================================================
// HEGEMONIA GLOBAL - OBJETO: AR-CURTO (Míssil Ar-Ar)
// Step Event - Sistema ROBUSTO para Interceptação Aérea
// ================================================

// === VERIFICAÇÃO DE SEGURANÇA ===
if (!instance_exists(alvo)) {
    instance_destroy();
    exit;
}

// === VERIFICAÇÃO DE ALCANCE MÁXIMO ===
var _distancia_alvo = point_distance(x, y, alvo.x, alvo.y);
if (_distancia_alvo > alcance_maximo) {
    show_debug_message("🚀 Míssil AR-CURTO perdeu o alvo - fora de alcance!");
    instance_destroy();
    exit;
}

// === MOVIMENTO SIMPLES E DIRETO ===
var _dir = point_direction(x, y, alvo.x, alvo.y);
image_angle = _dir;
direction = _dir;

// Move diretamente em direção ao alvo
x += lengthdir_x(speed, _dir);
y += lengthdir_y(speed, _dir);

// === VERIFICAÇÃO DE LIMITES DO MAPA ===
if (x < 0 || x > room_width || y < 0 || y > room_height) {
    show_debug_message("🚀 Míssil AR-CURTO saiu do mapa - destruindo!");
    instance_destroy();
    exit;
}

// === COLISÃO E DANO ===
// ✅ CORREÇÃO: Usar velocidade + margem para detecção de colisão (evita passar direto)
var _raio_colisao = max(speed + 10, 20); // Raio baseado na velocidade + margem
if (point_distance(x, y, alvo.x, alvo.y) <= _raio_colisao) {
    
    // === VERIFICAÇÃO DE PRECISÃO ===
    var _acerto = (random(1) < precisao);
    
    if (_acerto) {
        // APLICAR DANO SEGURO EM UNIDADES AÉREAS
        var _dano_aplicado = false;
        
        if (variable_instance_exists(alvo, "hp_atual")) {
            alvo.hp_atual -= dano;
            _dano_aplicado = true;
            show_debug_message("💥 Míssil AR-CURTO atingiu alvo aéreo! Dano: " + string(dano) + " | HP restante: " + string(alvo.hp_atual));
        } else if (variable_instance_exists(alvo, "vida")) {
            alvo.vida -= dano;
            _dano_aplicado = true;
            show_debug_message("💥 Míssil AR-CURTO atingiu alvo aéreo! Dano: " + string(dano) + " | Vida restante: " + string(alvo.vida));
        } else if (variable_instance_exists(alvo, "hp")) {
            alvo.hp -= dano;
            _dano_aplicado = true;
            show_debug_message("💥 Míssil AR-CURTO atingiu alvo aéreo! Dano: " + string(dano) + " | HP restante: " + string(alvo.hp));
        } else {
            // Fallback para unidades sem sistema de vida definido
            alvo.vida = 100;
            alvo.vida -= dano;
            _dano_aplicado = true;
            show_debug_message("💥 Míssil AR-CURTO atingiu alvo aéreo! Dano: " + string(dano) + " | Vida restante: " + string(alvo.vida));
        }
        
        // ✅ CORREÇÃO: Usar obj_explosao_ar para explosões aéreas (tem som configurado)
        if (object_exists(obj_explosao_ar)) {
            var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_ar);
            if (instance_exists(_explosao)) {
                _explosao.image_blend = make_color_rgb(255, 150, 0); // Laranja para explosão aérea
                _explosao.image_xscale = 1.5;
                _explosao.image_yscale = 1.5;
                show_debug_message("💥 Explosão aérea criada!");
            }
        } else if (object_exists(obj_explosao_aquatica)) {
            // Fallback para obj_explosao_aquatica se obj_explosao_ar não existir
            var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_aquatica);
            if (instance_exists(_explosao)) {
                _explosao.image_blend = make_color_rgb(255, 100, 100);
                _explosao.image_xscale = 2.0;
                _explosao.image_yscale = 2.0;
                _explosao.image_angle = random(360);
            }
        }
    } else {
        show_debug_message("🎯 Míssil AR-CURTO errou o alvo! Precisão: " + string(precisao * 100) + "%");
        // Criar explosão mesmo ao errar (visual)
        if (object_exists(obj_explosao_ar)) {
            var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_ar);
            if (instance_exists(_explosao)) {
                _explosao.image_blend = make_color_rgb(100, 100, 100); // Cinza para indicar erro
                _explosao.image_xscale = 1.0;
                _explosao.image_yscale = 1.0;
            }
        }
    }
    
    instance_destroy();
    exit;
}

// === TIMER DE VIDA ===
timer_vida--;
if (timer_vida <= 0) {
    show_debug_message("⏰ Míssil AR-CURTO expirou - tempo de vida esgotado!");
    instance_destroy();
}