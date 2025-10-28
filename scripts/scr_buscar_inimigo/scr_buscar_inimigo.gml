/// @description Buscar inimigo mais próximo considerando nacao_proprietaria
/// @param _x Posição X
/// @param _y Posição Y
/// @param _raio Raio de busca
/// @param _minha_nacao Nação atual (1 = jogador, 2 = IA)
/// @return ID do inimigo mais próximo ou noone

function scr_buscar_inimigo(_x, _y, _raio, _minha_nacao) {
    var _inimigo_mais_proximo = noone;
    var _menor_distancia = _raio + 1;
    
    // ✅ BUSCAR EM TODOS OS TIPOS (UNIDADES + ESTRUTURAS)
    var _tipos_unidades = [
        obj_infantaria,
        obj_tanque,
        obj_blindado_antiaereo,
        obj_soldado_antiaereo,
        obj_helicoptero_militar,
        obj_caca_f5,
        obj_f15,
        obj_f6,
        obj_c100,
        obj_lancha_patrulha,
        obj_RonaldReagan,
        obj_Constellation,
        obj_Independence,
        obj_navio_transporte,
        obj_wwhendrick,
        obj_submarino_base
    ];
    
    // ✅ ESTRUTURAS INIMIGAS TAMBÉM
    var _tipos_estruturas = [
        obj_quartel,
        obj_casa,
        obj_fazenda,
        obj_mina,
        obj_banco,
        obj_aeroporto_militar,
        obj_quartel_marinha
    ];
    
    // Procurar unidades inimigas
    for (var i = 0; i < array_length(_tipos_unidades); i++) {
        with (_tipos_unidades[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria")) {
                if (nacao_proprietaria != _minha_nacao) {
                    var _dist = point_distance(_x, _y, x, y);
                    if (_dist <= _raio && _dist < _menor_distancia) {
                        _menor_distancia = _dist;
                        _inimigo_mais_proximo = id;
                        show_debug_message("🎯 Encontrou unidade inimiga: " + object_get_name(object_index) + " | dist: " + string(_dist) + " | nacao: " + string(nacao_proprietaria));
                    }
                }
            }
        }
    }
    
    // Procurar estruturas inimigas
    for (var i = 0; i < array_length(_tipos_estruturas); i++) {
        with (_tipos_estruturas[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria")) {
                if (nacao_proprietaria != _minha_nacao) {
                    var _dist = point_distance(_x, _y, x, y);
                    if (_dist <= _raio && _dist < _menor_distancia) {
                        _menor_distancia = _dist;
                        _inimigo_mais_proximo = id;
                        show_debug_message("🏗️ Encontrou estrutura inimiga: " + object_get_name(object_index) + " | dist: " + string(_dist) + " | nacao: " + string(nacao_proprietaria));
                    }
                }
            }
        }
    }
    
    return _inimigo_mais_proximo;
}
