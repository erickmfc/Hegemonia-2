/// @function scr_validacao_terreno(_obj_a_construir, _tile_x, _tile_y);
/// @description Verifica se um objeto pode ser construído em um determinado tile.
/// @param {Asset.GMObject} _obj_a_construir O objeto a ser construído (ex: obj_quartel_marinha).
/// @param {Real} _tile_x A coordenada X do tile no grid.
/// @param {Real} _tile_y A coordenada Y do tile no grid.
/// @return {Bool} Retorna 'true' se a construção for válida, 'false' caso contrário.

function scr_validacao_terreno(_obj_a_construir, _tile_x, _tile_y) {

    // --- PASSO 1: Descobrir qual terreno a estrutura precisa ---
    // Criamos uma instância temporária do objeto para ler sua variável 'terreno_permitido'.
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