/// @description Buscar inimigo mais próximo considerando nacao_proprietaria (COM CACHE)
/// @param _x Posição X
/// @param _y Posição Y
/// @param _raio Raio de busca
/// @param _minha_nacao Nação atual (1 = jogador, 2 = IA)
/// @return ID do inimigo mais próximo ou noone

function scr_buscar_inimigo(_x, _y, _raio, _minha_nacao) {
    
    // ✅ PRIMEIRO: Tentar obter do cache
    var _inimigo_cached = scr_get_cached_enemy_search(_x, _y, _raio, _minha_nacao);
    if (_inimigo_cached != noone && instance_exists(_inimigo_cached)) {
        return _inimigo_cached; // ✅ Cache HIT - Retornar imediatamente
    }
    
    // ❌ Cache MISS - Buscar normalmente
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
    
    // ✅ NOVO: Verificar se obj_presidente_1 existe e adicionar
    var _obj_presidente = asset_get_index("obj_presidente_1");
    if (_obj_presidente != -1 && asset_get_type(_obj_presidente) == asset_object) {
        array_push(_tipos_estruturas, _obj_presidente);
    }
    
    // Procurar unidades inimigas
    for (var i = 0; i < array_length(_tipos_unidades); i++) {
        with (_tipos_unidades[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria")) {
                if (nacao_proprietaria != _minha_nacao) {
                    var _dist = point_distance(_x, _y, x, y);
                    if (_dist <= _raio && _dist < _menor_distancia) {
                        _menor_distancia = _dist;
                        _inimigo_mais_proximo = id;
                        // ✅ REMOVIDO: Debug excessivo - comentado para melhor performance
                        // if (global.debug_enabled) show_debug_message("🎯 Encontrou unidade inimiga");
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
    
    // ✅ ARMAZENAR NO CACHE (se encontrou algo)
    scr_set_cached_enemy_search(_x, _y, _raio, _minha_nacao, _inimigo_mais_proximo);
    
    return _inimigo_mais_proximo;
}
