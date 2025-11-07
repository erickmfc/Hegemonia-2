// ===============================================
// HEGEMONIA GLOBAL - CALCULAR FORÇA TOTAL DA IA
// ÚNICA DECLARAÇÃO DESTA FUNÇÃO
// ===============================================

/// @description Calcula a força total da IA baseada em suas unidades
/// @param {struct|instance} _ia Estrutura ou instância da IA
/// @return {real} Força total calculada
function scr_ia_calcular_forca_total(_ia) {
    // Validação básica
    if (is_undefined(_ia) || _ia == noone) {
        return 0;
    }
    
    // Verificar se é instância válida ou struct
    var _nacao_ia = 0;
    if (instance_exists(_ia)) {
        // É uma instância
        if (variable_instance_exists(_ia, "nacao_proprietaria")) {
            _nacao_ia = _ia.nacao_proprietaria;
        } else {
            return 0;
        }
    } else {
        // Pode ser struct ou outro tipo - tentar acessar diretamente
        _nacao_ia = _ia.nacao_proprietaria;
    }
    
    // Verificar se nacao_proprietaria é válida
    if (is_undefined(_nacao_ia) || _nacao_ia <= 0) {
        return 0;
    }
    
    var _forca_total = 0;
    
    // ✅ OTIMIZADO: Mapa de pontuações por tipo de unidade (mais fácil de manter)
    var _pontuacoes = ds_map_create();
    _pontuacoes[? obj_infantaria] = 1;
    _pontuacoes[? obj_tanque] = 4;
    _pontuacoes[? obj_soldado_antiaereo] = 2;
    _pontuacoes[? obj_blindado_antiaereo] = 2;
    
    // ✅ OTIMIZADO: Implementação direta (sem depender de função externa)
    var _tipos_terrestres = [obj_infantaria, obj_tanque, obj_soldado_antiaereo, obj_blindado_antiaereo];
    for (var i = 0; i < array_length(_tipos_terrestres); i++) {
        if (!object_exists(_tipos_terrestres[i])) continue;
        
        // Obter pontuação do mapa (padrão: 1 se não encontrado)
        var _pontuacao = _pontuacoes[? _tipos_terrestres[i]];
        if (is_undefined(_pontuacao)) {
            _pontuacao = 1; // Valor padrão de segurança
        }
        
        with (_tipos_terrestres[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                _forca_total += _pontuacao;
            }
        }
    }
    
    // Limpar mapa de pontuações terrestres
    ds_map_destroy(_pontuacoes);
    
    // ✅ OTIMIZADO: Implementação direta (sem depender de função externa)
    // Pontuação naval: 5 pontos por navio
    var _pontuacao_navio = 5;
    var _tipos_navais = [obj_lancha_patrulha, obj_navio_base, obj_submarino_base, obj_navio_transporte, obj_Constellation, obj_Independence, obj_RonaldReagan];
    var _obj_fragata_forca = asset_get_index("obj_fragata");
    if (_obj_fragata_forca != -1 && asset_get_type(_obj_fragata_forca) == asset_object) {
        array_push(_tipos_navais, _obj_fragata_forca);
    }
    for (var i = 0; i < array_length(_tipos_navais); i++) {
        if (!object_exists(_tipos_navais[i])) continue;
        with (_tipos_navais[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                _forca_total += _pontuacao_navio;
            }
        }
    }
    
    // ✅ OTIMIZADO: Implementação direta (sem depender de função externa)
    // Pontuação aérea: 3 pontos por aeronave
    var _pontuacao_aeronave = 3;
    var _tipos_aereos = [obj_helicoptero_militar, obj_caca_f5, obj_f6, obj_f15, obj_c100];
    for (var i = 0; i < array_length(_tipos_aereos); i++) {
        if (!object_exists(_tipos_aereos[i])) continue;
        with (_tipos_aereos[i]) {
            if (variable_instance_exists(id, "nacao_proprietaria") && nacao_proprietaria == _nacao_ia) {
                _forca_total += _pontuacao_aeronave;
            }
        }
    }
    
    return _forca_total;
}
