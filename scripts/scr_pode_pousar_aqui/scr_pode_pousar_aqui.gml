/// @function scr_pode_pousar_aqui(pos_x, pos_y);
/// @description Verifica se uma unidade aérea pode pousar em uma determinada posição.
function scr_pode_pousar_aqui(_pos_x, _pos_y) {
    // Por enquanto, uma verificação simples que sempre permite pousar em terra.
    // Futuramente, podemos checar o tipo de tile do grid aqui.
    // Ex: if (global.grid_terreno[# _tile_x, _tile_y] == TERRENO.AGUA) return false;
    return true;
}
