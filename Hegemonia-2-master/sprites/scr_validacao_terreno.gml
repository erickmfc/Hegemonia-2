/// @function scr_validacao_terreno(objeto_a_construir, tile_x, tile_y);
/// @description Verifica se um objeto pode ser construído em um determinado tile,
///              comparando o terreno necessário com o terreno real do grid.
/// @param {Asset.GMObject} objeto_a_construir O objeto que se deseja construir (ex: obj_quartel_marinha).
/// @param {Real} tile_x A coordenada X do tile no grid.
/// @param {Real} tile_y A coordenada Y do tile no grid.
/// @return {Bool} Retorna 'true' se a construção for válida, 'false' caso contrário.

function scr_validacao_terreno(_obj_a_construir, _tile_x, _tile_y) {

    // --- PASSO 1: Descobrir qual terreno a estrutura precisa ---
    // Criamos uma instância temporária do objeto para ler sua variável 'terreno_permitido'
    // Esta é a forma mais segura de obter a propriedade sem que o objeto exista ainda na room.
    var _inst_temp = instance_create_layer(0, 0, "Instances", _obj_a_construir);
    var _terreno_necessario = _inst_temp.terreno_permitido;
    instance_destroy(_inst_temp); // Destruímos a instância temporária imediatamente

    // --- PASSO 2: Descobrir qual é o terreno no local do clique ---
    // Lemos a informação do nosso grid lógico global, que já foi inicializado.
    // Usamos 'is_undefined' para evitar erros caso o clique seja fora do mapa.
    if (is_undefined(global.terrain_grid[# _tile_x, _tile_y])) {
        show_debug_message("Tentativa de construção fora dos limites do mapa.");
        return false; // Fora do mapa, não pode construir
    }
    var _terreno_no_tile = global.terrain_grid[# _tile_x, _tile_y];

    // --- PASSO 3: Comparar os dois e retornar a resposta ---
    if (_terreno_no_tile == _terreno_necessario) {
        return true; // SUCESSO! O terreno do tile é o mesmo que a estrutura precisa.
    } else {
        return false; // FALHA! O terreno não é compatível.
    }
}

/// @function scr_validacao_terreno_simples(objeto_a_construir, pos_x, pos_y);
/// @description Versão simplificada que usa o sistema existente de verificação de água
/// @param {Asset.GMObject} objeto_a_construir O objeto que se deseja construir
/// @param {Real} pos_x A coordenada X da posição
/// @param {Real} pos_y A coordenada Y da posição
/// @return {Bool} Retorna 'true' se a construção for válida, 'false' caso contrário.

function scr_validacao_terreno_simples(_obj_a_construir, _pos_x, _pos_y) {
    
    // Verifica se é o Quartel da Marinha (precisa de água)
    if (_obj_a_construir == obj_quartel_marinha) {
        // Usa o sistema existente de verificação de água
        return scr_check_water_tile(_pos_x, _pos_y);
    }
    
    // Para outros edifícios, verifica se NÃO é água (precisa de terra)
    if (_obj_a_construir == obj_quartel) {
        return !scr_check_water_tile(_pos_x, _pos_y);
    }
    
    // Para outros objetos, permite construção em terra por padrão
    return !scr_check_water_tile(_pos_x, _pos_y);
}

/// @function scr_validacao_area_construcao(objeto_a_construir, pos_x, pos_y, largura, altura);
/// @description Verifica se uma área inteira é válida para construção
/// @param {Asset.GMObject} objeto_a_construir O objeto que se deseja construir
/// @param {Real} pos_x A coordenada X central da posição
/// @param {Real} pos_y A coordenada Y central da posição
/// @param {Real} largura A largura do edifício
/// @param {Real} altura A altura do edifício
/// @return {Bool} Retorna 'true' se toda a área for válida, 'false' caso contrário.

function scr_validacao_area_construcao(_obj_a_construir, _pos_x, _pos_y, _largura, _altura) {
    
    // Verifica se é o Quartel da Marinha (precisa de água em toda a área)
    if (_obj_a_construir == obj_quartel_marinha) {
        // Usa o sistema existente de verificação de área de água
        return scr_can_build_on_water(_pos_x, _pos_y, _largura, _altura);
    }
    
    // Para outros edifícios, verifica se toda a área é terra
    // Verifica múltiplos pontos da área do edifício
    var _check_points = [
        // Centro
        [_pos_x, _pos_y],
        // Cantos
        [_pos_x - _largura/2, _pos_y - _altura/2],
        [_pos_x + _largura/2, _pos_y - _altura/2],
        [_pos_x - _largura/2, _pos_y + _altura/2],
        [_pos_x + _largura/2, _pos_y + _altura/2],
        // Pontos médios
        [_pos_x, _pos_y - _altura/2],
        [_pos_x, _pos_y + _altura/2],
        [_pos_x - _largura/2, _pos_y],
        [_pos_x + _largura/2, _pos_y]
    ];
    
    // Verifica se todos os pontos são terra (não água)
    for (var i = 0; i < array_length(_check_points); i++) {
        if (scr_check_water_tile(_check_points[i][0], _check_points[i][1])) {
            return false; // Encontrou água em um ponto, não pode construir
        }
    }
    
    return true; // Toda a área é terra, pode construir
}
