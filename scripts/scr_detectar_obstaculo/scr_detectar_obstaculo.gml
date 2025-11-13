/// @description Detecta obstáculos à frente da unidade e retorna direção de desvio ou novo destino
/// @param {real} _x Posição X atual
/// @param {real} _y Posição Y atual
/// @param {real} _direcao Direção do movimento (em graus)
/// @param {real} _destino_x Destino X final
/// @param {real} _destino_y Destino Y final
/// @param {real} _distancia_verificacao Distância à frente para verificar (padrão: 40 pixels)
/// @param {instance} _id_instancia ID da instância que está chamando (opcional, usa id se não fornecido)
/// @return {array} [nova_direcao, novo_destino_x, novo_destino_y] ou [direcao_original, destino_x, destino_y] se não houver obstáculo

function scr_detectar_obstaculo(_x, _y, _direcao, _destino_x, _destino_y, _distancia_verificacao = 40, _id_instancia = noone) {
    // ✅ CORREÇÃO: Usar id fornecido ou o id do objeto que chamou a função
    if (_id_instancia == noone) {
        _id_instancia = id;
    }
    
    // Calcular posição à frente
    var _x_frente = _x + lengthdir_x(_distancia_verificacao, _direcao);
    var _y_frente = _y + lengthdir_y(_distancia_verificacao, _direcao);
    
    // Lista de objetos que são obstáculos (verificando se existem)
    var _obstaculos = [];
    
    // ✅ CORREÇÃO: Adicionar apenas objetos que existem
    if (object_exists(obj_casa)) array_push(_obstaculos, obj_casa);
    if (object_exists(obj_banco)) array_push(_obstaculos, obj_banco);
    if (object_exists(obj_quartel)) array_push(_obstaculos, obj_quartel);
    if (object_exists(obj_quartel_marinha)) array_push(_obstaculos, obj_quartel_marinha);
    if (object_exists(obj_aeroporto_militar)) array_push(_obstaculos, obj_aeroporto_militar);
    if (object_exists(obj_fazenda)) array_push(_obstaculos, obj_fazenda);
    if (object_exists(obj_research_center)) array_push(_obstaculos, obj_research_center);
    if (object_exists(obj_mina_ouro)) array_push(_obstaculos, obj_mina_ouro);
    if (object_exists(obj_mina_aluminio)) array_push(_obstaculos, obj_mina_aluminio);
    if (object_exists(obj_mina_cobre)) array_push(_obstaculos, obj_mina_cobre);
    if (object_exists(obj_mina_litio)) array_push(_obstaculos, obj_mina_litio);
    if (object_exists(obj_mina_titanio)) array_push(_obstaculos, obj_mina_titanio);
    if (object_exists(obj_mina_uranio)) array_push(_obstaculos, obj_mina_uranio);
    if (object_exists(obj_plantacao_borracha)) array_push(_obstaculos, obj_plantacao_borracha);
    if (object_exists(obj_poco_petroleo)) array_push(_obstaculos, obj_poco_petroleo);
    if (object_exists(obj_serraria)) array_push(_obstaculos, obj_serraria);
    
    // ✅ CORREÇÃO: Verificar se obj_casa_da_moeda existe antes de usar
    var _casa_moeda_index = asset_get_index("obj_casa_da_moeda");
    if (_casa_moeda_index != -1 && object_exists(_casa_moeda_index)) {
        array_push(_obstaculos, _casa_moeda_index);
    }
    
    // ✅ CORREÇÃO: Verificar se obj_extrator_silicio existe antes de usar
    var _extrator_silicio_index = asset_get_index("obj_extrator_silicio");
    if (_extrator_silicio_index != -1 && object_exists(_extrator_silicio_index)) {
        array_push(_obstaculos, _extrator_silicio_index);
    }
    
    // Verificar se há obstáculo à frente
    var _obstaculo_encontrado = false;
    for (var i = 0; i < array_length(_obstaculos); i++) {
        if (position_meeting(_x_frente, _y_frente, _obstaculos[i])) {
            _obstaculo_encontrado = true;
            break;
        }
    }
    
    // ✅ MELHORADO: Verificar TODAS as unidades próximas (não apenas a mais próxima)
    var _unidades_obstaculo = [];
    
    // ✅ CORREÇÃO: Adicionar apenas unidades que existem
    if (object_exists(obj_infantaria)) array_push(_unidades_obstaculo, obj_infantaria);
    if (object_exists(obj_tanque)) array_push(_unidades_obstaculo, obj_tanque);
    if (object_exists(obj_blindado_antiaereo)) array_push(_unidades_obstaculo, obj_blindado_antiaereo);
    if (object_exists(obj_soldado_antiaereo)) array_push(_unidades_obstaculo, obj_soldado_antiaereo);
    
    // ✅ NOVO: Verificar múltiplas unidades próximas (importante para formações)
    var _raio_verificacao_unidades = 50; // Aumentado de 30 para 50 pixels
    var _unidades_proximas = 0;
    
    // ✅ CORREÇÃO: Usar instance_find para iterar sem problemas de escopo
    for (var i = 0; i < array_length(_unidades_obstaculo); i++) {
        var _tipo_unidade = _unidades_obstaculo[i];
        if (!object_exists(_tipo_unidade)) continue;
        
        // Encontrar todas as instâncias próximas deste tipo
        var _instancia = noone;
        var _instancia_anterior = noone;
        
        // Iterar sobre todas as instâncias deste tipo
        while (true) {
            if (_instancia_anterior == noone) {
                _instancia = instance_find(_tipo_unidade, 0);
            } else {
                _instancia = instance_find(_tipo_unidade, _instancia_anterior);
            }
            
            if (_instancia == noone) break;
            if (_instancia == _id_instancia) { // Não verificar a si mesmo
                _instancia_anterior = _instancia;
                continue;
            }
            
            // Verificar distância e posição
            var _dist_unidade = point_distance(_x, _y, _instancia.x, _instancia.y);
            
            // Se está muito perto, verificar se está no caminho
            if (_dist_unidade < _raio_verificacao_unidades) {
                // Verificar se está no caminho à frente
                var _angulo_para_unidade = point_direction(_x, _y, _instancia.x, _instancia.y);
                var _diferenca_angulo = abs(angle_difference(_direcao, _angulo_para_unidade));
                
                if (_diferenca_angulo < 90) {
                    _unidades_proximas++;
                    // Verificar se está exatamente no caminho
                    var _x_unidade_frente = _x + lengthdir_x(_distancia_verificacao, _direcao);
                    var _y_unidade_frente = _y + lengthdir_y(_distancia_verificacao, _direcao);
                    var _dist_unidade_caminho = point_distance(_x_unidade_frente, _y_unidade_frente, _instancia.x, _instancia.y);
                    
                    if (_dist_unidade_caminho < 40) {
                        _obstaculo_encontrado = true;
                        break;
                    }
                }
            }
            
            _instancia_anterior = _instancia;
        }
        
        if (_obstaculo_encontrado) break;
    }
    
    // ✅ NOVO: Se há muitas unidades próximas (formação), aumentar sensibilidade
    if (_unidades_proximas >= 3 && !_obstaculo_encontrado) {
        // Em formação, ser mais cuidadoso
        var _x_frente_2 = _x + lengthdir_x(_distancia_verificacao * 1.5, _direcao);
        var _y_frente_2 = _y + lengthdir_y(_distancia_verificacao * 1.5, _direcao);
        
        // ✅ CORREÇÃO: Usar instance_find em vez de with
        for (var i = 0; i < array_length(_unidades_obstaculo); i++) {
            var _tipo_unidade_2 = _unidades_obstaculo[i];
            if (!object_exists(_tipo_unidade_2)) continue;
            
            var _instancia_2 = noone;
            var _instancia_2_anterior = noone;
            
            while (true) {
                if (_instancia_2_anterior == noone) {
                    _instancia_2 = instance_find(_tipo_unidade_2, 0);
                } else {
                    _instancia_2 = instance_find(_tipo_unidade_2, _instancia_2_anterior);
                }
                
                if (_instancia_2 == noone) break;
                if (_instancia_2 == _id_instancia) { // Não verificar a si mesmo
                    _instancia_2_anterior = _instancia_2;
                    continue;
                }
                
                var _dist = point_distance(_x_frente_2, _y_frente_2, _instancia_2.x, _instancia_2.y);
                if (_dist < 35) {
                    _obstaculo_encontrado = true;
                    break;
                }
                
                _instancia_2_anterior = _instancia_2;
            }
            
            if (_obstaculo_encontrado) break;
        }
    }
    
    // Se encontrou obstáculo, calcular rota alternativa
    if (_obstaculo_encontrado) {
        // ✅ NOVO: Calcular ponto de desvio ao redor do obstáculo
        // Tentar encontrar um caminho ao redor do obstáculo
        
        var _raio_desvio = 80; // Distância para contornar o obstáculo
        var _melhor_direcao = _direcao;
        var _novo_destino_x = _destino_x;
        var _novo_destino_y = _destino_y;
        var _caminho_encontrado = false;
        
        // ✅ Tentar múltiplas direções para encontrar caminho livre
        var _angulos_teste = [45, -45, 90, -90, 135, -135, 180];
        
        // ✅ NOVO: Recriar lista de unidades para verificação de caminho
        var _unidades_verificacao = [];
        if (object_exists(obj_infantaria)) array_push(_unidades_verificacao, obj_infantaria);
        if (object_exists(obj_tanque)) array_push(_unidades_verificacao, obj_tanque);
        if (object_exists(obj_blindado_antiaereo)) array_push(_unidades_verificacao, obj_blindado_antiaereo);
        if (object_exists(obj_soldado_antiaereo)) array_push(_unidades_verificacao, obj_soldado_antiaereo);
        
        for (var a = 0; a < array_length(_angulos_teste); a++) {
            var _angulo_teste = _direcao + _angulos_teste[a];
            var _dist_teste = _raio_desvio * 2; // Testar mais longe
            
            // Calcular ponto de desvio nesta direção
            var _x_desvio = _x + lengthdir_x(_dist_teste, _angulo_teste);
            var _y_desvio = _y + lengthdir_y(_dist_teste, _angulo_teste);
            
            // Verificar se este caminho está livre
            var _caminho_livre = true;
            
            // Verificar múltiplos pontos ao longo do caminho
            for (var p = 1; p <= 3; p++) {
                var _check_x = _x + lengthdir_x(_dist_teste * (p / 3), _angulo_teste);
                var _check_y = _y + lengthdir_y(_dist_teste * (p / 3), _angulo_teste);
                
                // Verificar edifícios
                for (var i = 0; i < array_length(_obstaculos); i++) {
                    if (position_meeting(_check_x, _check_y, _obstaculos[i])) {
                        _caminho_livre = false;
                        break;
                    }
                }
                
                // ✅ NOVO: Também verificar outras unidades no caminho
                if (_caminho_livre) {
                    for (var u = 0; u < array_length(_unidades_verificacao); u++) {
                        var _tipo_unidade_check = _unidades_verificacao[u];
                        if (!object_exists(_tipo_unidade_check)) continue;
                        
                        // Usar instance_find para iterar sem problemas de escopo
                        var _instancia_check = noone;
                        var _instancia_check_anterior = noone;
                        
                        while (true) {
                            if (_instancia_check_anterior == noone) {
                                _instancia_check = instance_find(_tipo_unidade_check, 0);
                            } else {
                                _instancia_check = instance_find(_tipo_unidade_check, _instancia_check_anterior);
                            }
                            
                            if (_instancia_check == noone) break;
                            if (_instancia_check == _id_instancia) { // Não verificar a si mesmo
                                _instancia_check_anterior = _instancia_check;
                                continue;
                            }
                            
                            // Verificar se está no caminho
                            var _dist_check = point_distance(_check_x, _check_y, _instancia_check.x, _instancia_check.y);
                            if (_dist_check < 40) {
                                _caminho_livre = false;
                                break;
                            }
                            
                            _instancia_check_anterior = _instancia_check;
                        }
                        
                        if (!_caminho_livre) break;
                    }
                }
                
                if (!_caminho_livre) break;
            }
            
            // Se encontrou caminho livre, usar este desvio
            if (_caminho_livre) {
                // Calcular novo destino temporário (ponto de desvio)
                _novo_destino_x = _x_desvio;
                _novo_destino_y = _y_desvio;
                _melhor_direcao = _angulo_teste;
                _caminho_encontrado = true;
                break;
            }
        }
        
        // ✅ Se não encontrou caminho livre, tentar contornar pela direita ou esquerda
        if (!_caminho_encontrado) {
            // Tentar contornar pela direita (90 graus)
            var _x_direita = _x + lengthdir_x(_raio_desvio * 2, _direcao + 90);
            var _y_direita = _y + lengthdir_y(_raio_desvio * 2, _direcao + 90);
            var _direita_livre = true;
            
            for (var i = 0; i < array_length(_obstaculos); i++) {
                if (position_meeting(_x_direita, _y_direita, _obstaculos[i])) {
                    _direita_livre = false;
                    break;
                }
            }
            
            if (_direita_livre) {
                _novo_destino_x = _x_direita;
                _novo_destino_y = _y_direita;
                _melhor_direcao = _direcao + 90;
                _caminho_encontrado = true;
            } else {
                // Tentar contornar pela esquerda (-90 graus)
                var _x_esquerda = _x + lengthdir_x(_raio_desvio * 2, _direcao - 90);
                var _y_esquerda = _y + lengthdir_y(_raio_desvio * 2, _direcao - 90);
                var _esquerda_livre = true;
                
                for (var i = 0; i < array_length(_obstaculos); i++) {
                    if (position_meeting(_x_esquerda, _y_esquerda, _obstaculos[i])) {
                        _esquerda_livre = false;
                        break;
                    }
                }
                
                if (_esquerda_livre) {
                    _novo_destino_x = _x_esquerda;
                    _novo_destino_y = _y_esquerda;
                    _melhor_direcao = _direcao - 90;
                    _caminho_encontrado = true;
                }
            }
        }
        
        // Retornar nova direção e novo destino temporário
        return [_melhor_direcao, _novo_destino_x, _novo_destino_y];
    }
    
    // Sem obstáculo - retornar direção e destino originais
    return [_direcao, _destino_x, _destino_y];
}
