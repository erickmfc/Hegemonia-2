// ===============================================
// HEGEMONIA GLOBAL - MINIMAP
// Função para obter cor baseada na nação
// ===============================================

/// @function scr_minimap_get_nation_color(_nacao)
/// @description Retorna a cor do objeto no minimapa baseado na nação
/// @param {number} _nacao Número da nação (1 = Jogador, 2 = Presidente/IA, etc)
/// @return {color} Cor correspondente à nação

function scr_minimap_get_nation_color(_nacao) {
    if (_nacao == 1) {
        // Jogador (Azul)
        return make_color_rgb(50, 150, 255);
    } else if (_nacao == 2) {
        // Presidente 1 / IA Inimiga (Vermelho)
        return make_color_rgb(255, 50, 50);
    } else if (_nacao == 3) {
        // Outra nação (Laranja)
        return make_color_rgb(255, 150, 50);
    } else {
        // Neutro/Outros (Cinza)
        return make_color_rgb(150, 150, 150);
    }
}

