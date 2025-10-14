// ================================================
// HEGEMONIA GLOBAL - SISTEMA DE FORMAÇÕES TÁTICAS
// Script para gerenciar formações militares avançadas
// ================================================

/// @description Aplicar formação tática às unidades selecionadas
/// @param {real} _world_x Posição X no mundo
/// @param {real} _world_y Posição Y no mundo
/// @param {string} _tipo_formacao Tipo de formação ("linha", "v", "quadrado", "coluna")
function aplicar_formacao_tatica(_world_x, _world_y, _tipo_formacao) {
    
    // Contar unidades selecionadas
    var unidades_selecionadas = 0;
    var lista_infantaria = [];
    var lista_tanque = [];
    
    with (obj_infantaria) {
        if (selecionado) {
            array_push(lista_infantaria, id);
            unidades_selecionadas++;
        }
    }
    
    with (obj_tanque) {
        if (selecionado) {
            array_push(lista_tanque, id);
            unidades_selecionadas++;
        }
    }
    
    if (unidades_selecionadas == 0) return;
    
    var indice_formacao = 0;
    
    switch (_tipo_formacao) {
        case "linha":
            // FORMAÇÃO EM LINHA - Infantaria na frente, tanques atrás
            var espacamento = 50;
            var total_unidades = array_length(lista_infantaria) + array_length(lista_tanque);
            var inicio_x = _world_x - ((total_unidades - 1) * espacamento) / 2;
            
            // Posicionar infantaria na frente
            for (var i = 0; i < array_length(lista_infantaria); i++) {
                var unidade = lista_infantaria[i];
                if (instance_exists(unidade)) {
                    unidade.destino_x = inicio_x + (indice_formacao * espacamento);
                    unidade.destino_y = _world_y - 30; // 30px à frente
                    unidade.estado = "movendo";
                    unidade.alvo = noone;
                    unidade.image_angle = point_direction(unidade.x, unidade.y, unidade.destino_x, unidade.destino_y);
                    indice_formacao++;
                }
            }
            
            // Posicionar tanques atrás
            for (var i = 0; i < array_length(lista_tanque); i++) {
                var unidade = lista_tanque[i];
                if (instance_exists(unidade)) {
                    unidade.destino_x = inicio_x + (indice_formacao * espacamento);
                    unidade.destino_y = _world_y + 30; // 30px atrás
                    unidade.estado = "movendo";
                    unidade.alvo = noone;
                    unidade.image_angle = point_direction(unidade.x, unidade.y, unidade.destino_x, unidade.destino_y);
                    indice_formacao++;
                }
            }
            break;
            
        case "v":
            // FORMAÇÃO EM V - Ataque frontal
            var espacamento = 60;
            var total_unidades = array_length(lista_infantaria) + array_length(lista_tanque);
            var centro_x = _world_x;
            var centro_y = _world_y;
            
            // Posicionar em V
            for (var i = 0; i < array_length(lista_infantaria); i++) {
                var unidade = lista_infantaria[i];
                if (instance_exists(unidade)) {
                    var offset_x = (i - array_length(lista_infantaria)/2) * espacamento;
                    var offset_y = abs(offset_x) * 0.5; // Forma de V
                    unidade.destino_x = centro_x + offset_x;
                    unidade.destino_y = centro_y - offset_y;
                    unidade.estado = "movendo";
                    unidade.alvo = noone;
                    unidade.image_angle = point_direction(unidade.x, unidade.y, unidade.destino_x, unidade.destino_y);
                }
            }
            
            for (var i = 0; i < array_length(lista_tanque); i++) {
                var unidade = lista_tanque[i];
                if (instance_exists(unidade)) {
                    var offset_x = (i - array_length(lista_tanque)/2) * espacamento;
                    var offset_y = abs(offset_x) * 0.5 + 40; // V mais largo para tanques
                    unidade.destino_x = centro_x + offset_x;
                    unidade.destino_y = centro_y - offset_y;
                    unidade.estado = "movendo";
                    unidade.alvo = noone;
                    unidade.image_angle = point_direction(unidade.x, unidade.y, unidade.destino_x, unidade.destino_y);
                }
            }
            break;
            
        case "quadrado":
            // FORMAÇÃO EM QUADRADO - Defesa
            var lado = ceil(sqrt(unidades_selecionadas));
            var espacamento = 55;
            var inicio_x = _world_x - ((lado - 1) * espacamento) / 2;
            var inicio_y = _world_y - ((lado - 1) * espacamento) / 2;
            
            indice_formacao = 0;
            
            // Posicionar infantaria primeiro
            for (var i = 0; i < array_length(lista_infantaria); i++) {
                var unidade = lista_infantaria[i];
                if (instance_exists(unidade)) {
                    var coluna = indice_formacao mod lado;
                    var linha = indice_formacao div lado;
                    unidade.destino_x = inicio_x + (coluna * espacamento);
                    unidade.destino_y = inicio_y + (linha * espacamento);
                    unidade.estado = "movendo";
                    unidade.alvo = noone;
                    unidade.image_angle = point_direction(unidade.x, unidade.y, unidade.destino_x, unidade.destino_y);
                    indice_formacao++;
                }
            }
            
            // Posicionar tanques
            for (var i = 0; i < array_length(lista_tanque); i++) {
                var unidade = lista_tanque[i];
                if (instance_exists(unidade)) {
                    var coluna = indice_formacao mod lado;
                    var linha = indice_formacao div lado;
                    unidade.destino_x = inicio_x + (coluna * espacamento);
                    unidade.destino_y = inicio_y + (linha * espacamento);
                    unidade.estado = "movendo";
                    unidade.alvo = noone;
                    unidade.image_angle = point_direction(unidade.x, unidade.y, unidade.destino_x, unidade.destino_y);
                    indice_formacao++;
                }
            }
            break;
            
        case "coluna":
            // FORMAÇÃO EM COLUNA - Marcha
            var espacamento = 40;
            var inicio_x = _world_x;
            var inicio_y = _world_y;
            
            // Posicionar infantaria primeiro
            for (var i = 0; i < array_length(lista_infantaria); i++) {
                var unidade = lista_infantaria[i];
                if (instance_exists(unidade)) {
                    unidade.destino_x = inicio_x;
                    unidade.destino_y = inicio_y + (i * espacamento);
                    unidade.estado = "movendo";
                    unidade.alvo = noone;
                    unidade.image_angle = point_direction(unidade.x, unidade.y, unidade.destino_x, unidade.destino_y);
                }
            }
            
            // Posicionar tanques atrás
            for (var i = 0; i < array_length(lista_tanque); i++) {
                var unidade = lista_tanque[i];
                if (instance_exists(unidade)) {
                    unidade.destino_x = inicio_x;
                    unidade.destino_y = inicio_y + ((array_length(lista_infantaria) + i) * espacamento);
                    unidade.estado = "movendo";
                    unidade.alvo = noone;
                    unidade.image_angle = point_direction(unidade.x, unidade.y, unidade.destino_x, unidade.destino_y);
                }
            }
            break;
    }
    
    show_debug_message("Formação '" + _tipo_formacao + "' aplicada a " + string(unidades_selecionadas) + " unidades");
}
