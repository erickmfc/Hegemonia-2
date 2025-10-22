// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações

/// @description Verificar se o C100 pode carregar uma unidade
/// @param {instance} unidade Unidade a ser carregada
/// @return {bool} True se pode carregar, false caso contrário
function scr_c100_can_load(unidade) {
    // Verificar se a unidade existe
    if (!instance_exists(unidade)) {
        return false;
    }
    
    // Verificar se o C100 tem capacidade
    if (carga_atual >= capacidade_maxima) {
        return false;
    }
    
    // Verificar se a unidade está próxima o suficiente
    var distancia = point_distance(x, y, unidade.x, unidade.y);
    if (distancia > alcance) {
        return false;
    }
    
    // Verificar se a unidade pode ser carregada
    if (variable_instance_exists(unidade, "pode_ser_carregada")) {
        return unidade.pode_ser_carregada;
    }
    
    return true;
}