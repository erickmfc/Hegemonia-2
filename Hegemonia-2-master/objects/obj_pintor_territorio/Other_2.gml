/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
// Evento: Other -> Game Start
var bbox_left_tile = floor(bbox_left / global.tile_size);
var bbox_top_tile = floor(bbox_top / global.tile_size);
var bbox_right_tile = floor(bbox_right / global.tile_size);
var bbox_bottom_tile = floor(bbox_bottom / global.tile_size);

for (var i = bbox_left_tile; i < bbox_right_tile; i++) {
    for (var j = bbox_top_tile; j < bbox_bottom_tile; j++) {
        // Verifica se a coordenada está dentro do mapa
        if (i >= 0 && i < global.map_width && j >= 0 && j < global.map_height) {
            // Atribui a posse da nação a este tile no grid de dados
            global.map_grid[i][j].nacao = nacao_alvo;
        }
    }
}

// O pintor já cumpriu sua missão, podemos destruí-lo.
instance_destroy();
