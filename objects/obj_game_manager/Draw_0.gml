// Evento Draw de obj_game_manager

draw_set_color(c_black);
draw_set_alpha(0.8);

for (var i = 0; i < global.map_width; i++) {
    for (var j = 0; j < global.map_height; j++) {
        
        var minha_nacao = global.map_grid[i][j].nacao;
        if (minha_nacao == NATIONS.NEUTRA) continue;

        var xx = i * global.tile_size;
        var yy = j * global.tile_size;

        // Cima
        if (j > 0 && global.map_grid[i][j-1].nacao != minha_nacao) {
            draw_line(xx, yy, xx + global.tile_size, yy);
        }
        // Baixo
        if (j < global.map_height - 1 && global.map_grid[i][j+1].nacao != minha_nacao) {
            draw_line(xx, yy + global.tile_size, xx + global.tile_size, yy + global.tile_size);
        }
        // Esquerda
        if (i > 0 && global.map_grid[i-1][j].nacao != minha_nacao) {
            draw_line(xx, yy, xx, yy + global.tile_size);
        }
        // Direita
        if (i < global.map_width - 1 && global.map_grid[i+1][j].nacao != minha_nacao) {
            draw_line(xx + global.tile_size, yy, xx + global.tile_size, yy + global.tile_size);
        }
    }
}

draw_set_alpha(1);
draw_set_color(c_white);
