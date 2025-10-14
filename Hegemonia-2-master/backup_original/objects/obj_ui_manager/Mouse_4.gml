// Evento Mouse Left Pressed - obj_ui_manager
// L\u00f3gica de clique para o menu de constru\u00e7\u00e3o

if (global.menu_construcao_aberto) {
    var menu_w = window_get_width() * 0.8;
    var menu_h = 120;
    var menu_x = (window_get_width() - menu_w) / 2;
    var menu_y = window_get_height() - menu_h - 20;
    
    // Verificar se clicou dentro do menu
    if (point_in_rectangle(mouse_x, mouse_y, menu_x, menu_y, menu_x + menu_w, menu_y + menu_h)) {
        // Edif\u00edcios dispon\u00edveis (mesmo array do Draw)
        var edificios = [
            {nome: "Mina", objeto: obj_mina, custo: 1000},
            {nome: "Mina Ouro", objeto: obj_mina_ouro, custo: 2500},
            {nome: "Mina Cobre", objeto: obj_mina_cobre, custo: 1500},
            {nome: "Serraria", objeto: obj_serraria, custo: 800},
            {nome: "Po\u00e7o Petr\u00f3leo", objeto: obj_poco_petroleo, custo: 3000},
            {nome: "Plant. Borracha", objeto: obj_plantacao_borracha, custo: 1200}
        ];
        
        var btn_w = 120;
        var btn_h = 35;
        var spacing = 10;
        var start_x = menu_x + 20;
        var btn_y = menu_y + 40;
        
        // Verificar clique em cada bot\u00e3o
        for (var i = 0; i < array_length(edificios); i++) {
            var btn_x = start_x + i * (btn_w + spacing);
            var edificio = edificios[i];
            
            if (point_in_rectangle(mouse_x, mouse_y, btn_x, btn_y, btn_x + btn_w, btn_y + btn_h)) {
                // Verificar se tem dinheiro suficiente
                if (global.estoque_recursos[? "Dinheiro"] >= edificio.custo) {
                    // Criar "fantasma" do edif\u00edcio para posicionamento
                    if (!instance_exists(global.construindo_edificio)) {
                        global.construindo_edificio = instance_create_layer(mouse_x, mouse_y, "Instances", edificio.objeto);
                        global.construindo_edificio.image_alpha = 0.5; // Tornar semi-transparente
                        global.menu_construcao_aberto = false; // Fechar menu
                        show_debug_message("Iniciando constru\u00e7\u00e3o de: " + edificio.nome);
                    }
                }
                break;
            }
        }
    }
}