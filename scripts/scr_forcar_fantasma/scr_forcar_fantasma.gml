// =========================================================
// HEGEMONIA GLOBAL - FORÇAR FANTASMA DE CONSTRUÇÃO
// Script para forçar o fantasma a aparecer
// =========================================================

function scr_forcar_fantasma() {
    show_debug_message("=== FORÇANDO FANTASMA DE CONSTRUÇÃO ===");
    
    // 1. Ativar variáveis globais
    global.modo_construcao = true;
    global.construindo_agora = asset_get_index("obj_quartel");
    
    show_debug_message("✅ Variáveis globais ativadas");
    show_debug_message("   global.modo_construcao: " + string(global.modo_construcao));
    show_debug_message("   global.construindo_agora: " + string(global.construindo_agora));
    
    // 2. Verificar se o controlador existe
    var _controlador = instance_find(obj_controlador_construcao, 0);
    if (instance_exists(_controlador)) {
        show_debug_message("✅ Controlador encontrado: ID " + string(_controlador));
        
        // 3. Definir posição inicial
        _controlador.grid_x = 200;
        _controlador.grid_y = 200;
        show_debug_message("✅ Posição inicial definida: (200, 200)");
        
        // 4. Verificar sprite
        if (sprite_exists(spr_quartel)) {
            show_debug_message("✅ Sprite do quartel existe");
            
            // 5. Desenhar fantasma manualmente
            show_debug_message("✅ Tentando desenhar fantasma manualmente...");
            
            // Criar um objeto temporário para desenhar
            var _temp_obj = instance_create_layer(0, 0, "Instances", obj_controlador_construcao);
            if (instance_exists(_temp_obj)) {
                _temp_obj.grid_x = 200;
                _temp_obj.grid_y = 200;
                show_debug_message("✅ Objeto temporário criado para desenho");
            }
        } else {
            show_debug_message("❌ Sprite do quartel não existe!");
        }
    } else {
        show_debug_message("❌ Controlador não encontrado!");
        
        // Tentar criar um novo controlador
        var _novo_controlador = instance_create_layer(0, 0, "Instances", obj_controlador_construcao);
        if (instance_exists(_novo_controlador)) {
            show_debug_message("✅ Novo controlador criado: ID " + string(_novo_controlador));
            _novo_controlador.grid_x = 200;
            _novo_controlador.grid_y = 200;
        } else {
            show_debug_message("❌ Falha ao criar controlador!");
        }
    }
    
    show_debug_message("=== INSTRUÇÕES ===");
    show_debug_message("1. Mova o mouse para ver se o fantasma aparece");
    show_debug_message("2. Se não aparecer, o problema é no sistema de desenho");
    show_debug_message("=== FIM DO TESTE ===");
}
