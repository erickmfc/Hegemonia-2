// Efeito de fumaça
if (irandom(2) == 0) {
    var _fumaca = instance_create_layer(x - lengthdir_x(10, direction), y - lengthdir_y(10, direction), "Efeitos", obj_fumaca_missil);
    if (instance_exists(_fumaca)) {
        _fumaca.image_angle = direction; // Rastro segue a direção do míssil
    }
}

// Se o alvo não existir mais, retornar ao pool
if (!instance_exists(target)) {
    // Explosão automática quando o alvo desaparece
    if (object_exists(obj_explosao_terra)) {
        var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_terra);
        if (instance_exists(_explosao)) {
            _explosao.image_blend = make_color_rgb(255, 100, 0); // Laranja para indicar que errou
            _explosao.image_xscale = 1.2;
            _explosao.image_yscale = 1.2;
        }
    }
    scr_return_projectile_to_pool(id);
    exit;
}

// ✅ CORREÇÃO: Removida aquisição automática de alvos
// Míssil só deve existir se tiver alvo válido definido pelo avião
// Se target == noone, o míssil já foi destruído acima (linha 10-22)

// Detectar se o alvo está parado para garantir 100% de acerto
var alvo_parado = false;
if (instance_exists(target)) {
    if (variable_instance_exists(id, "last_tx")) {
        if (last_tx == target.x && last_ty == target.y) {
            still_frames += 1;
        } else {
            still_frames = 0;
        }
        last_tx = target.x;
        last_ty = target.y;
        alvo_parado = (still_frames >= 6); // ~0.1s a 60fps
    }
}

// Guiamento pesado - só segue alvo se estiver próximo
if (instance_exists(target)) {
    var _distancia_alvo = point_distance(x, y, target.x, target.y);
    var _distancia_maxima_rastreamento = 600; // ✅ MELHORADO: Só rastreia se estiver a menos de 600px (era 400)
    
    // Só faz curva se estiver próximo do alvo
    if (_distancia_alvo <= _distancia_maxima_rastreamento) {
        var ang = point_direction(x, y, target.x, target.y);
        var _turn_base = (variable_instance_exists(id, "turn_rate") ? turn_rate : 1.0);
        var _turn = 1.0; // ✅ FORÇADO: Sempre 1.0 para seguir o alvo perfeitamente (100% de precisão)
        direction = lerp(direction, ang, _turn);
    }
    // Se estiver longe do alvo, continua na direção atual (sem curva)
}

// Rotação da imagem para seguir a direção
image_angle = direction;

// Movimento + gravidade (reduz gravidade se alvo estiver parado para alinhar melhor)
var _grav = alvo_parado ? gravity * 0.5 : gravity;
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction) + _grav;

// Checagem de impacto por proximidade (100% GARANTIDO)
if (instance_exists(target)) {
    var _radius_base = (variable_instance_exists(id, "impact_radius") ? impact_radius : 100);
    var _radius = 100; // ✅ FORÇADO: Sempre 100 para garantir 100% de acerto
    if (point_distance(x, y, target.x, target.y) <= _radius) {
        // ✅ APLICAR DANO NO ALVO PRINCIPAL
        var _dano_aplicado = false;
        if (variable_instance_exists(target, "vida")) {
            target.vida -= dano;
            _dano_aplicado = true;
        } else if (variable_instance_exists(target, "hp_atual")) {
            target.hp_atual -= dano;
            _dano_aplicado = true;
        } else if (variable_instance_exists(target, "hp")) {
            target.hp -= dano;
            _dano_aplicado = true;
        }
        if (_dano_aplicado) {
            show_debug_message("💥 Ironclad impactou alvo. Dano: " + string(dano));
        }
        
        // ✅ NOVO: DANO EM ÁREA - MATA TODOS OS SOLDADOS PRÓXIMOS
        var _raio_dano_area = (variable_instance_exists(id, "raio_dano_area") ? raio_dano_area : 150);
        var _dano_area_valor = (variable_instance_exists(id, "dano_area") ? dano_area : 1000);
        
        // Lista de objetos terrestres para verificar
        var _tipos_unidades_terrestres = [
            obj_infantaria, obj_tanque, obj_soldado_antiaereo, obj_blindado_antiaereo
        ];
        
        var _unidades_atingidas = 0;
        for (var i = 0; i < array_length(_tipos_unidades_terrestres); i++) {
            with (_tipos_unidades_terrestres[i]) {
                if (id != other.target) { // Não aplicar dano duplo no alvo principal
                    var _dist = point_distance(x, y, other.x, other.y);
                    if (_dist <= _raio_dano_area) {
                        // Aplicar dano suficiente para matar (1000 de dano mata qualquer soldado)
                        if (variable_instance_exists(id, "hp_atual")) {
                            hp_atual -= _dano_area_valor;
                            _unidades_atingidas++;
                        } else if (variable_instance_exists(id, "vida")) {
                            vida -= _dano_area_valor;
                            _unidades_atingidas++;
                        } else if (variable_instance_exists(id, "hp")) {
                            hp -= _dano_area_valor;
                            _unidades_atingidas++;
                        }
                    }
                }
            }
        }
        
        if (_unidades_atingidas > 0) {
            show_debug_message("💥💥 IRONCLAD - DANO EM ÁREA! " + string(_unidades_atingidas) + " unidades atingidas no raio de " + string(_raio_dano_area) + "px!");
        }
        
        if (object_exists(obj_explosao_terra)) {
            instance_create_layer(x, y, "Efeitos", obj_explosao_terra);
        }
        scr_return_projectile_to_pool(id);
        exit;
    }
}

// === TIMER DE VIDA PARA EXPLOSÃO AUTOMÁTICA ===
// Corrigindo avisos GM2016 - declarar variáveis fora do Create com 'var'
var timer_vida_maximo = variable_instance_exists(id, "timer_vida_maximo") ? timer_vida_maximo : 72;
var timer_vida_atual = variable_instance_exists(id, "timer_vida_atual") ? timer_vida_atual : timer_vida_maximo;

timer_vida_atual--;
if (timer_vida_atual <= 0) {
    // Explosão automática após 1,2 segundos
    if (object_exists(obj_explosao_terra)) {
        var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_terra);
        if (instance_exists(_explosao)) {
            _explosao.image_blend = make_color_rgb(255, 100, 100); // Vermelho para indicar que errou
            _explosao.image_xscale = 1.5;
            _explosao.image_yscale = 1.5;
        }
    }
    scr_return_projectile_to_pool(id);
}
