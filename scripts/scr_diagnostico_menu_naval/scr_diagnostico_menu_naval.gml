/// @description Diagnóstico completo do menu de recrutamento naval
/// @param quartel_id ID do quartel naval para testar

show_debug_message("🔍 === DIAGNÓSTICO DO MENU DE RECRUTAMENTO NAVAL ===");

// === 1. VERIFICAR QUARTEL ===
show_debug_message("📋 1. VERIFICANDO QUARTEL...");

if (!instance_exists(argument0)) {
    show_debug_message("❌ Quartel não existe!");
    return;
}

var _quartel = argument0;
show_debug_message("✅ Quartel encontrado: " + string(_quartel));
show_debug_message("   - Tipo: " + string(object_get_name(_quartel.object_index)));
show_debug_message("   - Posição: (" + string(round(_quartel.x)) + ", " + string(round(_quartel.y)) + ")");

// === 2. VERIFICAR OBJETO DO MENU ===
show_debug_message("📋 2. VERIFICANDO OBJETO DO MENU...");

if (!object_exists(obj_menu_recrutamento_marinha)) {
    show_debug_message("❌ obj_menu_recrutamento_marinha não existe!");
    return;
}

show_debug_message("✅ obj_menu_recrutamento_marinha existe");

// === 3. VERIFICAR LAYER GUI ===
show_debug_message("📋 3. VERIFICANDO LAYER GUI...");

if (!layer_exists("GUI")) {
    show_debug_message("⚠️ Layer GUI não existe, criando...");
    layer_create(-100, "GUI");
    show_debug_message("✅ Layer GUI criada");
} else {
    show_debug_message("✅ Layer GUI existe");
}

// === 4. VERIFICAR MENUS EXISTENTES ===
show_debug_message("📋 4. VERIFICANDO MENUS EXISTENTES...");

var _menus_existentes = 0;
with (obj_menu_recrutamento_marinha) {
    _menus_existentes++;
    show_debug_message("   - Menu ID: " + string(id) + " | Quartel: " + string(meu_quartel_id));
}

show_debug_message("📊 Total de menus existentes: " + string(_menus_existentes));

// === 5. LIMPAR MENUS EXISTENTES ===
show_debug_message("📋 5. LIMPANDO MENUS EXISTENTES...");

with (obj_menu_recrutamento_marinha) {
    instance_destroy();
}

show_debug_message("✅ Menus limpos");

// === 6. VERIFICAR VARIÁVEIS GLOBAIS ===
show_debug_message("📋 6. VERIFICANDO VARIÁVEIS GLOBAIS...");

if (!variable_global_exists("menu_recrutamento_aberto")) {
    global.menu_recrutamento_aberto = false;
    show_debug_message("⚠️ global.menu_recrutamento_aberto não existia, criada");
} else {
    show_debug_message("✅ global.menu_recrutamento_aberto existe: " + string(global.menu_recrutamento_aberto));
}

// === 7. VERIFICAR VARIÁVEIS DO QUARTEL ===
show_debug_message("📋 7. VERIFICANDO VARIÁVEIS DO QUARTEL...");

if (!variable_instance_exists(_quartel, "menu_recrutamento")) {
    _quartel.menu_recrutamento = noone;
    show_debug_message("⚠️ menu_recrutamento não existia no quartel, criada");
} else {
    show_debug_message("✅ menu_recrutamento existe no quartel: " + string(_quartel.menu_recrutamento));
}

if (!variable_instance_exists(_quartel, "selecionado")) {
    _quartel.selecionado = false;
    show_debug_message("⚠️ selecionado não existia no quartel, criada");
} else {
    show_debug_message("✅ selecionado existe no quartel: " + string(_quartel.selecionado));
}

// === 8. TENTAR CRIAR MENU ===
show_debug_message("📋 8. TENTANDO CRIAR MENU...");

// Marcar quartel como selecionado
_quartel.selecionado = true;
show_debug_message("✅ Quartel marcado como selecionado");

// Criar menu
var _menu = instance_create_layer(0, 0, "GUI", obj_menu_recrutamento_marinha);

if (instance_exists(_menu)) {
    show_debug_message("✅ Menu criado com sucesso!");
    show_debug_message("   - Menu ID: " + string(_menu));
    show_debug_message("   - Posição: (" + string(_menu.x) + ", " + string(_menu.y) + ")");
    show_debug_message("   - Layer: GUI");
    
    // Configurar menu
    _menu.meu_quartel_id = _quartel;
    _quartel.menu_recrutamento = _menu;
    global.menu_recrutamento_aberto = true;
    
    show_debug_message("✅ Menu configurado:");
    show_debug_message("   - meu_quartel_id: " + string(_menu.meu_quartel_id));
    show_debug_message("   - menu_recrutamento no quartel: " + string(_quartel.menu_recrutamento));
    show_debug_message("   - global.menu_recrutamento_aberto: " + string(global.menu_recrutamento_aberto));
    
} else {
    show_debug_message("❌ Falha ao criar menu!");
}

// === 9. VERIFICAR EVENTOS DO MENU ===
show_debug_message("📋 9. VERIFICANDO EVENTOS DO MENU...");

if (instance_exists(_menu)) {
    show_debug_message("✅ Verificando eventos do menu criado:");
    
    // Verificar se Create event executou
    if (variable_instance_exists(_menu, "meu_quartel_id")) {
        show_debug_message("   ✅ Create event executou (meu_quartel_id existe)");
    } else {
        show_debug_message("   ❌ Create event não executou (meu_quartel_id não existe)");
    }
    
    // Verificar se Step event executou
    if (variable_instance_exists(_menu, "debug_step_executado")) {
        show_debug_message("   ✅ Step event executou");
    } else {
        show_debug_message("   ⚠️ Step event ainda não executou (normal no primeiro frame)");
    }
}

// === 10. VERIFICAR RECURSOS ===
show_debug_message("📋 10. VERIFICANDO RECURSOS...");

if (!variable_global_exists("dinheiro")) {
    global.dinheiro = 10000;
    show_debug_message("⚠️ global.dinheiro não existia, criada com valor 10000");
} else {
    show_debug_message("✅ global.dinheiro existe: $" + string(global.dinheiro));
}

// === 11. VERIFICAR FONTES ===
show_debug_message("📋 11. VERIFICANDO FONTES...");

if (font_exists(fnt_ui_main)) {
    show_debug_message("✅ fnt_ui_main existe");
} else {
    show_debug_message("⚠️ fnt_ui_main não existe, menu usará fonte padrão");
}

// === 12. VERIFICAR SPRITES ===
show_debug_message("📋 12. VERIFICANDO SPRITES...");

if (sprite_exists(spr_lancha_patrulha)) {
    show_debug_message("✅ spr_lancha_patrulha existe");
} else {
    show_debug_message("⚠️ spr_lancha_patrulha não existe, ícone não será mostrado");
}

// === RESULTADO FINAL ===
show_debug_message("🎯 === RESULTADO DO DIAGNÓSTICO ===");

if (instance_exists(_menu)) {
    show_debug_message("✅ SUCESSO: Menu criado e configurado!");
    show_debug_message("📋 Próximos passos:");
    show_debug_message("   1. Verificar se o menu aparece na tela");
    show_debug_message("   2. Testar cliques nos botões");
    show_debug_message("   3. Verificar se o Step event executa");
    show_debug_message("   4. Testar fechamento com Escape");
} else {
    show_debug_message("❌ FALHA: Menu não foi criado!");
    show_debug_message("📋 Possíveis causas:");
    show_debug_message("   1. Layer GUI não existe ou não está acessível");
    show_debug_message("   2. Objeto obj_menu_recrutamento_marinha tem problemas");
    show_debug_message("   3. Conflito com outros sistemas");
    show_debug_message("   4. Erro no Create event do menu");
}

show_debug_message("🔍 === DIAGNÓSTICO CONCLUÍDO ===");
