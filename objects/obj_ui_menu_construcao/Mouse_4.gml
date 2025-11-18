// =========================================================
// MENU DE CONSTRUÇÃO REDESENHADO - MOUSE LEFT PRESSED
// Processamento de cliques nos botões
// =========================================================

if (menu_estado != 2) {
    exit;
}

var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

var _botao_y_atual = botao_start_y;

for (var i = 0; i < array_length(lista_botoes); i++) {
    var _botao = lista_botoes[i];
    var _botao_x = menu_pos_x_atual + (menu_largura - botao_largura) / 2;
    var _botao_y = _botao_y_atual;
    
    // Verificar com escala do botão
    var _centro_x = _botao_x + botao_largura / 2;
    var _centro_y = _botao_y + botao_altura / 2;
    var _scaled_largura = botao_largura * _botao.scale_anim;
    var _scaled_altura = botao_altura * _botao.scale_anim;
    var _scaled_x = _centro_x - _scaled_largura / 2;
    var _scaled_y = _centro_y - _scaled_altura / 2;
    
    if (point_in_rectangle(_mouse_gui_x, _mouse_gui_y,
                          _scaled_x, _scaled_y,
                          _scaled_x + _scaled_largura, _scaled_y + _scaled_altura)) {
        
        // === VERIFICAR RECURSOS ===
        var _tem_recursos = true;
        var _mensagem_erro = "";
        
        // Verificar dinheiro
        if (variable_global_exists("dinheiro") && global.dinheiro < _botao.custo_dinheiro) {
            _tem_recursos = false;
            _mensagem_erro = "Dinheiro insuficiente! Precisa: $" + string(_botao.custo_dinheiro);
        }
        
        // Verificar recursos adicionais
        if (_tem_recursos && is_struct(_botao.custo_recursos)) {
            var _keys = struct_get_names(_botao.custo_recursos);
            if (array_length(_keys) > 0) {
                for (var j = 0; j < array_length(_keys); j++) {
                    var _key = _keys[j];
                    var _valor_necessario = _botao.custo_recursos[$_key];
                    var _valor_atual = 0;
                    
                    if (variable_global_exists(_key)) {
                        _valor_atual = global[$_key];
                    } else if (variable_global_exists(_key + "s")) {
                        _valor_atual = global[$_key + "s"];
                    }
                    // Nota: Se a variável não for encontrada, _valor_atual permanece 0
                    
                    if (_valor_atual < _valor_necessario) {
                        _tem_recursos = false;
                        _mensagem_erro = _key + " insuficiente! Precisa: " + string(_valor_necessario);
                        break;
                    }
                }
            }
        }
        
        // === ATIVAR MODO CONSTRUÇÃO ===
        if (_tem_recursos) {
            global.construindo_agora = _botao.objeto_construir;
            
            menu_estado = 3;
            menu_aberto = false;
            timer_animacao = 0;
            
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("✅ Botão clicado (Redesenhado): " + _botao.nome);
                show_debug_message("   Objeto: " + string(_botao.objeto_construir));
                show_debug_message("   Modo construção ativado");
            }
        } else {
            if (variable_global_exists("debug_enabled") && global.debug_enabled) {
                show_debug_message("❌ " + _mensagem_erro);
            }
            // Efeito visual de erro (shake do botão)
            _botao.scale_anim = 0.95;
        }
        
        exit;
    }
    
    _botao_y_atual += botao_altura + botao_espacamento;
}
