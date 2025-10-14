// ===============================================
// HEGEMONIA GLOBAL - INPUT MANAGER (Step Corrigido com Patrulha Persistente)
// ===============================================

// --- LÓGICA DE INPUT DO MOUSE ---
// Conversão de coordenadas do mouse para o mundo (com zoom)
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);
var _cam = view_camera[0];
var _cam_x = camera_get_view_x(_cam);
var _cam_y = camera_get_view_y(_cam);
var _cam_w = camera_get_view_width(_cam);
var _cam_h = camera_get_view_height(_cam);
var _zoom_level_x = _cam_w / display_get_gui_width();
var _zoom_level_y = _cam_h / display_get_gui_height();
var _mx = _cam_x + (_mouse_gui_x * _zoom_level_x);
var _my = _cam_y + (_mouse_gui_y * _zoom_level_y);

// --- MODO DE DEFINIÇÃO DE PATRULHA ---
if (instance_exists(global.definindo_patrulha_unidade)) {
    var _unidade = global.definindo_patrulha_unidade;

    // Clique esquerdo ADICIONA um ponto à rota
    if (mouse_check_button_pressed(mb_left)) {
        if (variable_instance_exists(_unidade, "pontos_patrulha")) {
            ds_list_add(_unidade.pontos_patrulha, [_mx, _my]);
            show_debug_message("📍 Ponto de patrulha adicionado: (" + string(_mx) + ", " + string(_my) + ")");
        }
    }

    // Clique direito FINALIZA a rota e inicia a patrulha
    if (mouse_check_button_pressed(mb_right)) {
        if (variable_instance_exists(_unidade, "pontos_patrulha") && ds_list_size(_unidade.pontos_patrulha) > 1) {
            _unidade.estado = "patrulhando";
            _unidade.indice_patrulha = 0;
            var _ponto = _unidade.pontos_patrulha[| 0];
            _unidade.destino_x = _ponto[0];
            _unidade.destino_y = _ponto[1];
            show_debug_message("🔄 Patrulha iniciada com " + string(ds_list_size(_unidade.pontos_patrulha)) + " pontos!");
        } else {
            _unidade.estado = "parado"; // Cancela se não houver pontos suficientes
            show_debug_message("❌ Patrulha cancelada - mínimo de 2 pontos necessários");
        }
        global.definindo_patrulha_unidade = noone; // Sai do modo de definição
    }
}
// --- MODO NORMAL (SELEÇÃO E MOVIMENTO) ---
else {
    // DESABILITADO: Sistema de seleção movido para obj_controlador_unidades
    // para evitar conflitos entre múltiplos sistemas de seleção
    if (false && mouse_check_button_pressed(mb_left)) {
        var _unidade_aerea = instance_position(_mx, _my, obj_caca_f5);
        var _unidade_tanque = instance_position(_mx, _my, obj_tanque);
        
        // Desseleciona unidade anterior
        if (instance_exists(global.unidade_selecionada)) {
            global.unidade_selecionada.selecionado = false;
        }
        
        if (instance_exists(_unidade_aerea)) {
            // Seleciona nova unidade
            global.unidade_selecionada = _unidade_aerea;
            _unidade_aerea.selecionado = true;
            show_debug_message("✈️ F-5 selecionado");
        } else if (instance_exists(_unidade_tanque)) {
            // Seleciona tanque
            global.unidade_selecionada = _unidade_tanque;
            _unidade_tanque.selecionado = true;
            show_debug_message("🚗 TANQUE selecionado");
        } else {
            // Desseleciona se clicou em lugar vazio
            global.unidade_selecionada = noone;
        }
    }
    
    // Movimento com clique direito (CÓDIGO ATUALIZADO)
    if (mouse_check_button_pressed(mb_right) && instance_exists(global.unidade_selecionada)) {
        var _unidade = global.unidade_selecionada;
        
        // Dá a nova ordem de movimento
        _unidade.estado = "movendo";
        _unidade.destino_x = _mx;
        _unidade.destino_y = _my;

        // ======================================================================
        // ✅ NOVA LÓGICA: CANCELAR E LIMPAR A PATRULHA ANTERIOR
        // ======================================================================
        if (variable_instance_exists(_unidade, "pontos_patrulha") && ds_list_size(_unidade.pontos_patrulha) > 0) {
            ds_list_clear(_unidade.pontos_patrulha);
            show_debug_message("🔄 Patrulha cancelada por nova ordem de movimento.");
        }
        
        // Cancelar modo de definição e patrulha
        if (variable_instance_exists(_unidade, "modo_definicao_patrulha")) {
            _unidade.modo_definicao_patrulha = false;
        }
        if (variable_instance_exists(_unidade, "patrulhando")) {
            _unidade.patrulhando = false;
        }
        // ======================================================================
        
        if (_unidade.object_index == obj_caca_f5) {
            show_debug_message("🎯 Ordem de movimento para F-5");
        } else if (_unidade.object_index == obj_tanque) {
            show_debug_message("🎯 Ordem de movimento para TANQUE");
        }
    }
}

// --- LÓGICA DE INPUT DO TECLADO ---
if (keyboard_check_pressed(ord("K")) && instance_exists(global.unidade_selecionada)) {
    // Tecla K só funciona para a unidade selecionada e que NÃO está em modo de definição
    if (global.definindo_patrulha_unidade == noone) {
        global.definindo_patrulha_unidade = global.unidade_selecionada;
        if (variable_instance_exists(global.definindo_patrulha_unidade, "pontos_patrulha")) {
            ds_list_clear(global.definindo_patrulha_unidade.pontos_patrulha);
        }
        show_debug_message("🎯 Modo PATRULHA: Clique com o esquerdo para adicionar pontos. Clique direito para iniciar.");
    }
}

// --- CONTROLES DE CÂMERA ---
mouse_x_previous = window_mouse_get_x();
mouse_y_previous = window_mouse_get_y();




