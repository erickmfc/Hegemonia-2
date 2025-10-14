// scr_teste_menu_quartel_militar_novo.gml
function scr_teste_menu_quartel_militar_novo() {
    show_debug_message("--- INICIANDO TESTE DO NOVO MENU DO QUARTEL MILITAR ---");
    
    // 1. Criar um quartel militar
    var _quartel = instance_create_layer(400, 300, "Instances", obj_quartel);
    _quartel.nacao_proprietaria = 1; // Jogador
    show_debug_message("Quartel Militar criado em (400, 300)");
    
    // 2. Definir dinheiro suficiente para testar todas as unidades
    global.dinheiro = 2000;
    show_debug_message("Dinheiro definido para: $" + string(global.dinheiro));
    
    // 3. Abrir o menu de recrutamento
    var _menu = instance_create_layer(0, 0, "Instances", obj_menu_recrutamento);
    _menu.id_do_quartel = _quartel;
    show_debug_message("Menu de recrutamento aberto");
    
    // 4. Verificar unidades disponíveis
    var _unidades = _quartel.unidades_disponiveis;
    var _num_unidades = ds_list_size(_unidades);
    show_debug_message("Unidades disponíveis: " + string(_num_unidades));
    
    for (var i = 0; i < _num_unidades; i++) {
        var _unidade = ds_list_find_value(_unidades, i);
        show_debug_message("  " + string(i + 1) + ". " + _unidade.nome + " - $" + string(_unidade.custo_dinheiro) + " (Pop: " + string(_unidade.custo_populacao) + ")");
    }
    
    show_debug_message("--- INSTRUÇÕES ---");
    show_debug_message("1. Observe o novo layout em grid 2x2 com todas as 4 unidades");
    show_debug_message("2. Verifique as cores verdes militares (em vez de azul naval)");
    show_debug_message("3. Teste os botões RECRUTAR de cada unidade");
    show_debug_message("4. Observe a seção de status do quartel");
    show_debug_message("5. Teste o botão FECHAR");
    show_debug_message("--- FIM DO TESTE ---");
}
