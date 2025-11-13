/// @description Retorna a cor do terreno baseado no tipo
/// @param {enum} _terreno Tipo de terreno (TERRAIN enum)
/// @return {color} Cor do terreno

function scr_get_terrain_color(_terreno) {
    switch (_terreno) {
        case TERRAIN.AGUA:
            return make_color_rgb(30, 80, 150); // Azul para água
        case TERRAIN.DESERTO:
            return make_color_rgb(200, 180, 100); // Bege/amarelo para deserto
        case TERRAIN.FLORESTA:
            return make_color_rgb(20, 100, 40); // Verde escuro para floresta
        case TERRAIN.CAMPO:
            return make_color_rgb(100, 130, 80); // Verde claro para terra/campo
        default:
            // Suporte para GELO (caso seja adicionado ao enum depois)
            // Você pode adicionar TERRAIN.GELO no enum e usar:
            // case TERRAIN.GELO: return make_color_rgb(200, 220, 240); // Azul claro para gelo
            return make_color_rgb(80, 80, 80); // Cinza padrão
    }
}
