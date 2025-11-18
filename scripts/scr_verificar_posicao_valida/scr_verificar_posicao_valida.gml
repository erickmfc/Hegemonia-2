/// @description Verificar se a posição é válida para o tipo de objeto
/// @param {real} objeto_tipo Tipo do objeto a ser criado
/// @param {real} pos_x Posição X
/// @param {real} pos_y Posição Y
/// @return {bool} true se a posição é válida, false caso contrário

function scr_verificar_posicao_valida(objeto_tipo, pos_x, pos_y) {
    // Verificar limites da sala
    if (pos_x < 0 || pos_y < 0 || pos_x >= room_width || pos_y >= room_height) {
        return false;
    }
    
    // Verificar se navios precisam estar em água
    switch (objeto_tipo) {
        case obj_lancha_patrulha:
        case obj_fragata:
        case obj_destroyer:
        case obj_submarino:
        case obj_RonaldReagan:
            return scr_verificar_agua(pos_x, pos_y);
        default:
            return true;
    }
}