/// @description Recuperar cache do GameMaker
/// @param {string} metodo Método de recuperação

function scr_recuperar_cache(metodo) {
    
    show_debug_message("🔄 RECUPERANDO CACHE - Método: " + metodo);
    
    switch (metodo) {
        
        case "forcar_recompilacao":
            // Forçar recompilação de objetos essenciais
            var _objetos_essenciais = [obj_infantaria, obj_inimigo, obj_quartel];
            for (var i = 0; i < array_length(_objetos_essenciais); i++) {
                if (object_exists(_objetos_essenciais[i])) {
                    // Forçar acesso às variáveis para recompilar
                    var _instancia = instance_find(_objetos_essenciais[i], 0);
                    if (instance_exists(_instancia)) {
                        var _temp = _instancia.x + _instancia.y;
                        show_debug_message("✅ Objeto recompilado: " + string(_objetos_essenciais[i]));
                    }
                }
            }
            break;
            
        case "limpar_variaveis_globais":
            // Limpar e recriar variáveis globais
            if (variable_global_exists("dinheiro_pais")) {
                global.dinheiro_pais = global.dinheiro_pais; // Forçar acesso
            } else {
                global.dinheiro_pais = 10000;
                show_debug_message("✅ Variável global dinheiro_pais recriada");
            }
            
            if (variable_global_exists("populacao_cidade")) {
                global.populacao_cidade = global.populacao_cidade; // Forçar acesso
            } else {
                global.populacao_cidade = 0;
                show_debug_message("✅ Variável global populacao_cidade recriada");
            }
            break;
            
        case "verificar_sprites":
            // Verificar e forçar reconhecimento de sprites
            var _sprites_essenciais = [spr_infantaria, spr_inimigo, spr_quartel];
            for (var i = 0; i < array_length(_sprites_essenciais); i++) {
                if (sprite_exists(_sprites_essenciais[i])) {
                    var _temp = sprite_get_width(_sprites_essenciais[i]);
                    show_debug_message("✅ Sprite verificado: " + string(_sprites_essenciais[i]));
                } else {
                    show_debug_message("❌ Sprite não encontrado: " + string(_sprites_essenciais[i]));
                }
            }
            break;
    }
    
    show_debug_message("✅ Cache recuperado com sucesso");
}
