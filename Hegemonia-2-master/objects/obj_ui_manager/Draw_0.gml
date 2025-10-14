// ===============================================
// HEGEMONIA GLOBAL - UI MANAGER
// Evento Draw - Menu de Construção
// ===============================================

// Verificar se a variável global existe antes de usar
if (!variable_global_exists("menu_construcao_aberto")) {
    global.menu_construcao_aberto = false;
}

if (global.menu_construcao_aberto) {
    var menu_w = window_get_width() * 0.8;
    var menu_h = 120;
    var menu_x = (window_get_width() - menu_w) / 2;
    var menu_y = window_get_height() - menu_h - 20;
    
    // Fundo do menu
    draw_set_color(make_color_rgb(25, 25, 35));
    draw_set_alpha(0.9);
    draw_rectangle(menu_x, menu_y, menu_x + menu_w, menu_y + menu_h, false);
    
    // Borda
    draw_set_color(make_color_rgb(70, 100, 140));
    draw_set_alpha(0.8);
    draw_rectangle(menu_x - 2, menu_y - 2, menu_x + menu_w + 2, menu_y + menu_h + 2, false);
    
    // Título
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_text(menu_x + menu_w / 2, menu_y + 20, "MENU DE CONSTRUÇÃO");
    
    // Edifícios disponíveis
    var edificios = [
        {nome: "Mina", objeto: obj_mina, custo: 1000},
        {nome: "Mina Ouro", objeto: obj_mina_ouro, custo: 2500},
        {nome: "Mina Cobre", objeto: obj_mina_cobre, custo: 1500},
        {nome: "Serraria", objeto: obj_serraria, custo: 800},
        {nome: "Poço Petróleo", objeto: obj_poco_petroleo, custo: 3000},
        {nome: "Plant. Borracha", objeto: obj_plantacao_borracha, custo: 1200},
        {nome: "Aeroporto Militar", objeto: obj_aeroporto_militar, custo: 1000} // ✅ ADICIONADO
    ];
    
    var btn_w = 120;
    var btn_h = 35;
    var spacing = 10;
    var start_x = menu_x + 20;
    var btn_y = menu_y + 40;
    
    // Desenhar botões
    for (var i = 0; i < array_length(edificios); i++) {
        var btn_x = start_x + i * (btn_w + spacing);
        var edificio = edificios[i];
        
        // Verificar se tem dinheiro suficiente
        var pode_construir = false;
        if (ds_exists(global.estoque_recursos, ds_type_map)) {
            pode_construir = (global.estoque_recursos[? "Dinheiro"] >= edificio.custo);
        } else {
            // Fallback: usar global.dinheiro se estoque_recursos não existir
            if (variable_global_exists("dinheiro")) {
                pode_construir = (global.dinheiro >= edificio.custo);
            }
        }
        
        // Cor do botão baseada na disponibilidade
        if (pode_construir) {
            draw_set_color(make_color_rgb(80, 120, 80)); // Verde
        } else {
            draw_set_color(make_color_rgb(120, 80, 80)); // Vermelho
        }
        
        draw_set_alpha(0.8);
        draw_rectangle(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, false);
        
        // Texto do botão
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(255, 255, 255));
        draw_set_alpha(1);
        draw_text(btn_x + btn_w / 2, btn_y + btn_h / 2, edificio.nome);
        
        // Custo
        draw_set_color(make_color_rgb(200, 200, 200));
        draw_text(btn_x + btn_w / 2, btn_y + btn_h + 5, "$" + string(edificio.custo));
    }
    
    // Resetar configurações
    draw_set_alpha(1);
}
