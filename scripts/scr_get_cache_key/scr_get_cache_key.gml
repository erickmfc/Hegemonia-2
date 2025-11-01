/// @description Gera chave única para cache baseada em parâmetros de busca
/// @param {real} _x Posição X
/// @param {real} _y Posição Y
/// @param {real} _raio Raio de busca
/// @param {real} _nacao Nação
/// @return {string} Chave única do cache

function scr_get_cache_key(_x, _y, _raio, _nacao) {
    // ✅ Criar chave baseada em grid (evita cache muito específico)
    // Arredondar para grid de 50 pixels para aumentar taxa de cache hit
    var _grid_size = 50;
    var _grid_x = floor(_x / _grid_size) * _grid_size;
    var _grid_y = floor(_y / _grid_size) * _grid_size;
    var _grid_raio = floor(_raio / 25) * 25; // Arredondar raio para múltiplos de 25
    
    // Chave formatada: "x_y_raio_nacao"
    return string(_grid_x) + "_" + string(_grid_y) + "_" + string(_grid_raio) + "_" + string(_nacao);
}
