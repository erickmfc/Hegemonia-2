// Efeito de fumaça
if (irandom(2) == 0) {
    var _fumaca = instance_create_layer(x - lengthdir_x(10, direction), y - lengthdir_y(10, direction), "Efeitos", obj_fumaca_missil);
    if (instance_exists(_fumaca)) {
        _fumaca.image_angle = direction; // Rastro segue a direção do míssil
    }
}

// Se o alvo não existir mais, destruir o míssil
if (target == noone && !instance_exists(target)) {
    // Explosão automática quando o alvo desaparece
    if (object_exists(obj_explosao_terra)) {
        var _explosao = instance_create_layer(x, y, "Efeitos", obj_explosao_terra);
        if (instance_exists(_explosao)) {
            _explosao.image_blend = make_color_rgb(255, 100, 0); // Laranja para indicar que errou
            _explosao.image_xscale = 1.2;
            _explosao.image_yscale = 1.2;
        }
    }
    instance_destroy();
    exit;
}

// Aquisição/Manutenção de alvo (fallback se não veio setado)
// Hash pode atacar: unidades terrestres, submarinos, navios e aéreos
// Verificar se tem variável 'alvo' do F-15
if (variable_instance_exists(id, "alvo") && instance_exists(alvo)) {
    target = alvo;
}

if (target == noone || !instance_exists(target)) {
    // Buscar qualquer unidade inimiga próxima
    if (object_exists(obj_inimigo)) {
        target = instance_nearest(x, y, obj_inimigo);
    }
    // Também pode buscar submarinos
    if ((target == noone || !instance_exists(target)) && object_exists(obj_submarino)) {
        var _sub = instance_nearest(x, y, obj_submarino);
        if (_sub != noone) {
            target = _sub;
        }
    }
}

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
    var _distancia_maxima_rastreamento = 400; // Só rastreia se estiver a menos de 400px
    
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
        // ✅ DANO PRINCIPAL NO ALVO
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
            show_debug_message("💥💥 MÍSSIL HASH IMPACTOU ALVO! Dano: " + string(dano) + " (SUPER PESADO)");
        }
        
        // ✅ DANO EM ÁREA - AFETA TODAS AS UNIDADES PRÓXIMAS (terrestres e aéreas)
        var _raio_dano_area = 150; // ✅ AUMENTADO: Raio maior para pegar mais soldados
        var _dano_area_aplicado = false;
        var _unidades_atingidas = 0;
        
        // Lista de objetos para verificar
        var _tipos_unidades = [
            obj_infantaria, obj_tanque, obj_soldado_antiaereo, obj_blindado_antiaereo,
            obj_caca_f5, obj_f15, obj_f6, obj_helicoptero_militar, obj_c100
        ];
        
        for (var i = 0; i < array_length(_tipos_unidades); i++) {
            with (_tipos_unidades[i]) {
                if (id != other.target) { // Não aplicar dano duplo no alvo principal
                    var _dist = point_distance(x, y, other.x, other.y);
                    if (_dist <= _raio_dano_area) {
                        // ✅ AUMENTADO: Dano suficiente para matar qualquer soldado
                        var _dano_area_valor = (variable_instance_exists(other.id, "dano_area") ? other.dano_area : 1000);
                        
                        if (variable_instance_exists(id, "hp_atual")) {
                            hp_atual -= _dano_area_valor;
                            _dano_area_aplicado = true;
                            _unidades_atingidas++;
                        } else if (variable_instance_exists(id, "vida")) {
                            vida -= _dano_area_valor;
                            _dano_area_aplicado = true;
                            _unidades_atingidas++;
                        } else if (variable_instance_exists(id, "hp")) {
                            hp -= _dano_area_valor;
                            _dano_area_aplicado = true;
                            _unidades_atingidas++;
                        }
                    }
                }
            }
        }
        
        if (_dano_area_aplicado) {
            show_debug_message("💥💥 HASH - DANO EM ÁREA! " + string(_unidades_atingidas) + " unidades atingidas no raio de " + string(_raio_dano_area) + "px!");
        }
        
        if (object_exists(obj_explosao_terra)) {
            instance_create_layer(x, y, "Efeitos", obj_explosao_terra);
        }
        instance_destroy();
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
    instance_destroy();
}
