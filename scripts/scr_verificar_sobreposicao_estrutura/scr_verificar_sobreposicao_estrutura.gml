/// @function scr_verificar_sobreposicao_estrutura(_pos_x, _pos_y, _largura, _altura, _objeto_tipo)
/// @description Verifica se há sobreposição com outras estruturas na área especificada
/// @param {Real} _pos_x Posição X no mundo
/// @param {Real} _pos_y Posição Y no mundo
/// @param {Real} _largura Largura da estrutura
/// @param {Real} _altura Altura da estrutura
/// @param {Asset.GMObject} _objeto_tipo Tipo de objeto a construir (opcional, para excluir do mesmo tipo)
/// @return {Bool} true se não há sobreposição, false se há sobreposição

function scr_verificar_sobreposicao_estrutura(_pos_x, _pos_y, _largura, _altura, _objeto_tipo = noone) {
    
    // === LISTA DE TODAS AS ESTRUTURAS QUE PODEM COLIDIR ===
    var _estruturas = [
        obj_fazenda,
        obj_quartel,
        obj_quartel_marinha,
        obj_aeroporto_militar,
        obj_mina,
        obj_banco,
        obj_casa
    ];
    
    // Adicionar outras estruturas se existirem
    var _obj_casa_moeda = asset_get_index("obj_casa_da_moeda");
    if (_obj_casa_moeda != -1 && object_exists(_obj_casa_moeda)) {
        array_push(_estruturas, _obj_casa_moeda);
    }
    
    // === CALCULAR ÁREA DA ESTRUTURA ===
    var _area_x1 = _pos_x - _largura / 2;
    var _area_y1 = _pos_y - _altura / 2;
    var _area_x2 = _pos_x + _largura / 2;
    var _area_y2 = _pos_y + _altura / 2;
    
    // === VERIFICAR CADA TIPO DE ESTRUTURA ===
    for (var i = 0; i < array_length(_estruturas); i++) {
        var _tipo_estrutura = _estruturas[i];
        if (!object_exists(_tipo_estrutura)) continue;
        
        // Se for o mesmo tipo de objeto, verificar apenas outras instâncias
        var _verificar_mesmo_tipo = (_objeto_tipo != noone && _tipo_estrutura == _objeto_tipo);
        
        // === VERIFICAR MÚLTIPLOS PONTOS NA ÁREA ===
        // Verificar centro e cantos para garantir detecção completa
        var _pontos_verificacao = [
            [_pos_x, _pos_y],  // Centro
            [_area_x1 + 10, _area_y1 + 10],  // Canto superior esquerdo
            [_area_x2 - 10, _area_y1 + 10],  // Canto superior direito
            [_area_x1 + 10, _area_y2 - 10],  // Canto inferior esquerdo
            [_area_x2 - 10, _area_y2 - 10]   // Canto inferior direito
        ];
        
        // Verificar cada ponto
        for (var j = 0; j < array_length(_pontos_verificacao); j++) {
            var _check_x = _pontos_verificacao[j][0];
            var _check_y = _pontos_verificacao[j][1];
            
            // Verificar se há instância nesta posição
            var _instancia = instance_position(_check_x, _check_y, _tipo_estrutura);
            if (_instancia != noone) {
                // Se estamos verificando o mesmo tipo, é OK (vai substituir)
                // Mas se é tipo diferente, há sobreposição
                if (!_verificar_mesmo_tipo) {
                    show_debug_message("❌ Sobreposição detectada: " + object_get_name(_tipo_estrutura) + " em (" + string(_check_x) + ", " + string(_check_y) + ")");
                    return false; // Há sobreposição
                }
            }
        }
        
        // === VERIFICAÇÃO ADICIONAL: Verificar distância mínima ===
        // Para estruturas grandes, verificar se não estão muito próximas
        var _distancia_minima = 50; // Distância mínima entre estruturas
        
        with (_tipo_estrutura) {
            // Se for o mesmo tipo e mesma posição, pular (será substituído)
            if (_verificar_mesmo_tipo && abs(x - _pos_x) < 5 && abs(y - _pos_y) < 5) {
                continue;
            }
            
            var _dist = point_distance(x, y, _pos_x, _pos_y);
            if (_dist < _distancia_minima) {
                show_debug_message("❌ Estrutura muito próxima: " + object_get_name(_tipo_estrutura) + " a " + string(_dist) + " pixels");
                return false; // Muito próxima
            }
        }
    }
    
    // === SUCESSO: NÃO HÁ SOBREPOSIÇÃO ===
    return true;
}

