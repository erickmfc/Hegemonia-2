// ========================================
// INSTRUÇÕES DE IMPLEMENTAÇÃO RÁPIDA
// ========================================

// PASSO 1: ADICIONAR SCRIPT PRINCIPAL
// ========================================
// 1. Copie o arquivo "scr_check_water_tile.gml" para seu projeto
// 2. Adicione como script no GameMaker Studio
// 3. Nome do script: "scr_check_water_tile"

// PASSO 2: IMPLEMENTAR NOS NAVIOS
// ========================================

// Para cada navio (lancha, marinha, nav122, br120):

// 1. Abra o objeto do navio
// 2. No evento Create, adicione as variáveis:
/*
moving_to_target = false;
target_x = 0;
target_y = 0;
ship_speed = 2; // Ajuste conforme necessário
ship_width = 154; // Ajuste conforme o sprite
ship_height = 186; // Ajuste conforme o sprite
*/

// 3. No evento Step, substitua ou adicione:
/*
if (moving_to_target) {
    var distance = point_distance(x, y, target_x, target_y);
    
    if (distance > 10) {
        var next_x = x + lengthdir_x(ship_speed, point_direction(x, y, target_x, target_y));
        var next_y = y + lengthdir_y(ship_speed, point_direction(x, y, target_x, target_y));
        
        if (scr_check_water_area(next_x, next_y, ship_width, ship_height)) {
            x = next_x;
            y = next_y;
        } else {
            moving_to_target = false;
            show_message("Navio não pode sair da água!");
        }
    } else {
        moving_to_target = false;
    }
}
*/

// 4. No evento Left Pressed, adicione:
/*
if (scr_check_water_tile(mouse_x, mouse_y)) {
    target_x = mouse_x;
    target_y = mouse_y;
    moving_to_target = true;
} else {
    var nearest_water = scr_find_nearest_water(mouse_x, mouse_y, 200);
    if (nearest_water[0] != -1) {
        target_x = nearest_water[0];
        target_y = nearest_water[1];
        moving_to_target = true;
    } else {
        show_message("Não há água próxima para mover o navio!");
    }
}
*/

// PASSO 3: IMPLEMENTAR NO QUARTEL MARINHA
// ========================================

// 1. Abra o objeto do botão de construção do Quartel Marinha
// 2. No evento Left Pressed, substitua por:
/*
if (scr_can_build_on_water(mouse_x, mouse_y, 154, 186)) {
    instance_create_layer(mouse_x, mouse_y, "Instances", obj_quartel_marinha);
    show_message("Quartel Marinha construído com sucesso!");
} else {
    show_message("Quartel Marinha deve ser construído na água!");
}
*/

// PASSO 4: TESTAR
// ========================================

// 1. Execute o jogo
// 2. Teste movimento dos navios:
//    - Clique em água: deve mover
//    - Clique em terra: deve mostrar erro
// 3. Teste construção do quartel:
//    - Construa em água: deve funcionar
//    - Construa em terra: deve mostrar erro

// ========================================
// CONFIGURAÇÕES POR TIPO DE NAVIO
// ========================================

// LANCHA PATRULHA:
// ship_speed = 3;
// ship_width = 78;
// ship_height = 19;
// max_radius = 200;

// MARINHA:
// ship_speed = 2;
// ship_width = 154;
// ship_height = 186;
// max_radius = 300;

// NAV122:
// ship_speed = 1.5;
// ship_width = 600;
// ship_height = 139;
// max_radius = 400;

// BR120:
// ship_speed = 1;
// ship_width = 574;
// ship_height = 118;
// max_radius = 500;

// ========================================
// AJUSTES FINOS
// ========================================

// Se navios param muito longe da borda:
// - Aumente o valor de "distance > 10" no Step

// Se navios não encontram água próxima:
// - Aumente o "max_radius" na função scr_find_nearest_water

// Se verificação não funciona:
// - Verifique se os sprites de terreno estão corretos
// - Teste scr_check_water_tile() manualmente

// Se performance está lenta:
// - Reduza o número de pontos verificados em scr_check_water_area
// - Aumente o intervalo de verificação

// ========================================
// ARQUIVOS CRIADOS
// ========================================

// 1. scr_check_water_tile.gml - Função principal
// 2. obj_lancha_patrulha_implementation.gml - Código para lancha
// 3. obj_marinha_implementation.gml - Código para marinha
// 4. obj_nav122_implementation.gml - Código para nav122
// 5. obj_br120_implementation.gml - Código para br120
// 6. obj_quartel_marinha_implementation.gml - Código para quartel
// 7. test_system.gml - Código de teste
// 8. implementation_guide.gml - Este arquivo

// ========================================
// SUPORTE
// ========================================

// Se encontrar problemas:
// 1. Verifique se todos os scripts foram adicionados
// 2. Confirme se os nomes dos objetos estão corretos
// 3. Teste cada função individualmente
// 4. Use o arquivo test_system.gml para debug