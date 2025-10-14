// Os recursos de script mudaram para a v2.3.0; veja
// https://help.yoyogames.com/hc/en-us/articles/360005277377 para obter mais informações
function scr_limpar_menus_recrutamento(){
    show_debug_message("🧹 Iniciando limpeza de menus de recrutamento...");
    
    // === 1. DESTRUIR TODAS AS INSTÂNCIAS DE MENU ===
    var _menus_destruidos = 0;
    
    // Destruir menus de quartel terrestre
    with (obj_menu_recrutamento) {
        instance_destroy();
        _menus_destruidos++;
    }
    
    // Destruir menus de quartel de marinha
    with (obj_menu_recrutamento_marinha) {
        instance_destroy();
        _menus_destruidos++;
    }
    
    // Destruir menus de aeroporto
    with (obj_menu_recrutamento_aereo) {
        instance_destroy();
        _menus_destruidos++;
    }
    
    show_debug_message("✅ " + string(_menus_destruidos) + " menus destruídos");
    
    // === 2. RESETAR VARIÁVEIS GLOBAIS ===
    global.menu_recrutamento_aberto = false;
    
    // === 3. LIMPAR REFERÊNCIAS EM QUARTÉIS ===
    with (obj_quartel) {
        if (variable_instance_exists(id, "menu_recrutamento")) {
            menu_recrutamento = noone;
        }
        selecionado = false;
    }
    
    with (obj_quartel_marinha) {
        if (variable_instance_exists(id, "menu_recrutamento")) {
            menu_recrutamento = noone;
        }
        selecionado = false;
    }
    
    with (obj_aeroporto_militar) {
        if (variable_instance_exists(id, "menu_recrutamento")) {
            menu_recrutamento = noone;
        }
        selecionado = false;
    }
    
    show_debug_message("✅ Limpeza de menus concluída!");
    show_debug_message("   - Variável global resetada: " + string(global.menu_recrutamento_aberto));
    show_debug_message("   - Referências de quartéis limpas");
}

function scr_verificar_menus_orfaos(){
    var _menus_orfaos = 0;
    
    // Verificar menus de quartel terrestre
    with (obj_menu_recrutamento) {
        if (!instance_exists(id_do_quartel)) {
            _menus_orfaos++;
            show_debug_message("⚠️ Menu órfão encontrado: " + string(id) + " (quartel não existe)");
        }
    }
    
    // Verificar menus de quartel de marinha
    with (obj_menu_recrutamento_marinha) {
        if (!instance_exists(meu_quartel_id)) {
            _menus_orfaos++;
            show_debug_message("⚠️ Menu órfão encontrado: " + string(id) + " (quartel marinha não existe)");
        }
    }
    
    // Verificar menus de aeroporto
    with (obj_menu_recrutamento_aereo) {
        if (!instance_exists(meu_aeroporto_id)) {
            _menus_orfaos++;
            show_debug_message("⚠️ Menu órfão encontrado: " + string(id) + " (aeroporto não existe)");
        }
    }
    
    if (_menus_orfaos > 0) {
        show_debug_message("⚠️ " + string(_menus_orfaos) + " menus órfãos encontrados!");
        return true;
    } else {
        show_debug_message("✅ Nenhum menu órfão encontrado");
        return false;
    }
}