// ===============================================
// HEGEMONIA GLOBAL - QUARTEL DE MARINHA
// Sistema de Seleção Corrigido para Zoom
// ===============================================

// Evento Left Pressed - Seleção do quartel de marinha
show_debug_message("=== MOUSE_53 EXECUTADO ===");
show_debug_message("Mouse X: " + string(mouse_x) + " | Mouse Y: " + string(mouse_y));
show_debug_message("Quartel X: " + string(x) + " | Quartel Y: " + string(y));

// ✅ CORREÇÃO: Usar função global para coordenadas consistentes
var _coords = global.scr_mouse_to_world();
var _mouse_world_x = _coords[0];
var _mouse_world_y = _coords[1];
show_debug_message("Mouse Mundo: (" + string(_mouse_world_x) + ", " + string(_mouse_world_y) + ")");

// ✅ CORREÇÃO BUG: Verificar se há unidade SOBRE o edifício (apenas se não for o próprio quartel)
// Primeiro verificar se há uma UNIDADE sobre o edifício (não o próprio edifício)
var _tem_unidade_sobre = false;
var _tipos_unidades = [
    obj_infantaria, obj_tanque, obj_soldado_antiaereo, obj_blindado_antiaereo,
    obj_caca_f5, obj_helicoptero_militar, obj_f15, obj_f6, obj_c100
];

for (var i = 0; i < array_length(_tipos_unidades); i++) {
    var _inst = instance_position(_mouse_world_x, _mouse_world_y, _tipos_unidades[i]);
    if (_inst != noone && instance_exists(_inst)) {
        _tem_unidade_sobre = true;
        show_debug_message("⚠️ Unidade detectada sobre o edifício - ignorando clique no quartel");
        show_debug_message("   Unidade: " + object_get_name(_inst.object_index));
        break;
    }
}

// Se há unidade sobre o edifício, ignorar o clique no edifício
if (_tem_unidade_sobre) {
    exit; // Sair sem processar clique no edifício
}

// ✅ CORREÇÃO: Verificar se o clique está dentro do sprite do quartel
var _click_detected = false;
if (mouse_check_button_pressed(mb_left)) {
    // Verificar se o clique está dentro da área do quartel
    var _sprite_w = sprite_get_width(sprite_index);
    var _sprite_h = sprite_get_height(sprite_index);
    var _left = x - _sprite_w/2;
    var _right = x + _sprite_w/2;
    var _top = y - _sprite_h/2;
    var _bottom = y + _sprite_h/2;
    
    if (_mouse_world_x >= _left && _mouse_world_x <= _right && 
        _mouse_world_y >= _top && _mouse_world_y <= _bottom) {
        _click_detected = true;
        show_debug_message("✅ CLIQUE DETECTADO NO QUARTEL (área do sprite)!");
    } else {
        show_debug_message("❌ Clique fora da área do quartel");
        show_debug_message("   Área quartel: (" + string(_left) + "," + string(_top) + ") a (" + string(_right) + "," + string(_bottom) + ")");
    }
}

if (_click_detected) {
    show_debug_message("✅ CLIQUE DETECTADO NO QUARTEL!");
    
    // === CORREÇÃO: FECHAR MENUS EXISTENTES ===
    // Garantir que não há menus órfãos antes de criar um novo
    if (global.menu_recrutamento_aberto) {
        show_debug_message("🔄 Fechando menus existentes antes de abrir novo...");
        scr_limpar_menus_recrutamento();
    }
    
    // Fechar menu deste quartel se existir
    if (menu_recrutamento != noone) {
        show_debug_message("Fechando menu existente: " + string(menu_recrutamento));
        instance_destroy(menu_recrutamento);
        menu_recrutamento = noone;
    }
    
    // Desmarcar outros quartéis
    with (obj_quartel) { 
        selecionado = false;
        if (variable_instance_exists(id, "menu_recrutamento") && menu_recrutamento != noone) {
            instance_destroy(menu_recrutamento);
            menu_recrutamento = noone;
        }
    }
    
    with (obj_quartel_marinha) { 
        selecionado = false;
        if (menu_recrutamento != noone) {
            instance_destroy(menu_recrutamento);
            menu_recrutamento = noone;
        }
    }
    
    // Marcar este quartel de marinha
    selecionado = true;
    show_debug_message("✅ Quartel selecionado!");
    
    // === CORREÇÃO: CRIAR MENU COM SISTEMA ROBUSTO ===
    show_debug_message("Criando menu de recrutamento...");
    
    // Verificar se objeto do menu existe
    if (!object_exists(obj_menu_recrutamento_marinha)) {
        show_debug_message("❌ ERRO: obj_menu_recrutamento_marinha não existe!");
        return;
    }
    
    // Tentar criar menu na layer "Instances" (mais segura)
    var _menu_criado = false;
    
    // Primeira tentativa: layer "Instances"
    if (layer_exists("Instances")) {
        menu_recrutamento = instance_create_layer(0, 0, "Instances", obj_menu_recrutamento_marinha);
        if (instance_exists(menu_recrutamento)) {
            _menu_criado = true;
            show_debug_message("✅ Menu criado na layer 'Instances'");
        }
    }
    
    // Segunda tentativa: layer "GUI" (se existir)
    if (!_menu_criado && layer_exists("GUI")) {
        menu_recrutamento = instance_create_layer(0, 0, "GUI", obj_menu_recrutamento_marinha);
        if (instance_exists(menu_recrutamento)) {
            _menu_criado = true;
            show_debug_message("✅ Menu criado na layer 'GUI'");
        }
    }
    
    // Terceira tentativa: criar layer GUI e tentar novamente
    if (!_menu_criado) {
        show_debug_message("Criando layer GUI...");
        layer_create(-100, "GUI");
        menu_recrutamento = instance_create_layer(0, 0, "GUI", obj_menu_recrutamento_marinha);
        if (instance_exists(menu_recrutamento)) {
            _menu_criado = true;
            show_debug_message("✅ Menu criado na layer 'GUI' (criada)");
        }
    }
    
    // Configurar menu se foi criado com sucesso
    if (_menu_criado && instance_exists(menu_recrutamento)) {
        // Configurar menu
        menu_recrutamento.meu_quartel_id = id;
        global.menu_recrutamento_aberto = true;
        
        // Garantir que menu é visível
        menu_recrutamento.visible = true;
        menu_recrutamento.image_alpha = 1.0;
        menu_recrutamento.depth = -1000; // Depth alto para ficar na frente
        
        show_debug_message("=== MENU DE RECRUTAMENTO NAVAL ABERTO ===");
        show_debug_message("Quartel de Marinha ID: " + string(id));
        show_debug_message("Menu ID: " + string(menu_recrutamento));
        show_debug_message("Posição: (" + string(menu_recrutamento.x) + ", " + string(menu_recrutamento.y) + ")");
        show_debug_message("Visível: " + string(menu_recrutamento.visible));
        show_debug_message("Alpha: " + string(menu_recrutamento.image_alpha));
        show_debug_message("Depth: " + string(menu_recrutamento.depth));
        
        // Verificar se Create event executou
        if (variable_instance_exists(menu_recrutamento, "meu_quartel_id")) {
            show_debug_message("✅ Create event do menu executou");
        } else {
            show_debug_message("⚠️ Create event do menu não executou, configurando manualmente");
            menu_recrutamento.meu_quartel_id = id;
        }
        
    } else {
        show_debug_message("❌ FALHA CRÍTICA: Não foi possível criar menu em nenhuma layer!");
        show_debug_message("   - Layer 'Instances' existe: " + string(layer_exists("Instances")));
        show_debug_message("   - Layer 'GUI' existe: " + string(layer_exists("GUI")));
        show_debug_message("   - Objeto menu existe: " + string(object_exists(obj_menu_recrutamento_marinha)));
    }
} else {
    show_debug_message("❌ Clique não detectado ou fora do quartel");
}