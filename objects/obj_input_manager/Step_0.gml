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
        ds_list_add(_unidade.pontos_patrulha, [_mx, _my]);
        show_debug_message("📍 Ponto de patrulha adicionado: (" + string(_mx) + ", " + string(_my) + ")");
    }

    // Clique direito FINALIZA a rota e inicia a patrulha
    if (mouse_check_button_pressed(mb_right)) {
        if (ds_list_size(_unidade.pontos_patrulha) > 1) {
            // ✅ CORREÇÃO: Usar estados corretos baseados no tipo de unidade
            if (object_get_name(_unidade.object_index) == "obj_caca_f5") {
                _unidade.estado = "patrulhando";
            } else if (object_get_name(_unidade.object_index) == "obj_lancha_patrulha") {
                _unidade.estado = LanchaState.PATRULHANDO;
            }
            
            _unidade.indice_patrulha_atual = 0;
            var _ponto = _unidade.pontos_patrulha[| 0];
            _unidade.destino_x = _ponto[0];
            _unidade.destino_y = _ponto[1];
            show_debug_message("🔄 PATRULHA INICIADA com " + string(ds_list_size(_unidade.pontos_patrulha)) + " pontos!");
            show_debug_message("🚢 Unidade começará a patrulhar automaticamente");
        } else {
            // ✅ CORREÇÃO: Usar estado correto baseado no tipo de unidade
            if (object_get_name(_unidade.object_index) == "obj_caca_f5") {
                _unidade.estado = "pousado";
            } else if (object_get_name(_unidade.object_index) == "obj_lancha_patrulha") {
                _unidade.estado = LanchaState.PARADO;
            }
            show_debug_message("❌ PATRULHA CANCELADA - mínimo de 2 pontos necessários");
        }
        global.definindo_patrulha_unidade = noone; // Sai do modo de definição
    }
}
// --- MODO NORMAL (SELEÇÃO E MOVIMENTO) ---
else {
    // Seleção com clique esquerdo
    if (mouse_check_button_pressed(mb_left)) {
        var _unidade_aerea = instance_position(_mx, _my, obj_caca_f5);
        var _unidade_naval = instance_position(_mx, _my, obj_lancha_patrulha);
        
        // Desseleciona unidade anterior
        if (instance_exists(global.unidade_selecionada)) {
            global.unidade_selecionada.selecionado = false;
        }
        
        if (instance_exists(_unidade_aerea)) {
            // Seleciona nova unidade aérea
            global.unidade_selecionada = _unidade_aerea;
            _unidade_aerea.selecionado = true;
            show_debug_message("✈️ F-5 selecionado");
        } else if (instance_exists(_unidade_naval)) {
            // Seleciona nova unidade naval
            global.unidade_selecionada = _unidade_naval;
            _unidade_naval.selecionado = true;
            show_debug_message("🚢 Lancha Patrulha selecionada");
        } else {
            // Desseleciona se clicou em lugar vazio
            global.unidade_selecionada = noone;
        }
    }
    
    // Movimento com clique direito (CÓDIGO ATUALIZADO)
    if (mouse_check_button_pressed(mb_right) && instance_exists(global.unidade_selecionada)) {
        var _unidade = global.unidade_selecionada;
        
        // ✅ CORREÇÃO: Usar estados corretos baseados no tipo de unidade
        if (object_get_name(_unidade.object_index) == "obj_caca_f5") {
            _unidade.estado = "movendo";
        } else if (object_get_name(_unidade.object_index) == "obj_lancha_patrulha") {
            _unidade.estado = LanchaState.MOVENDO;
        }
        
        _unidade.destino_x = _mx;
        _unidade.destino_y = _my;

        // ======================================================================
        // ✅ NOVA LÓGICA: CANCELAR E LIMPAR A PATRULHA ANTERIOR
        // ======================================================================
        if (ds_list_size(_unidade.pontos_patrulha) > 0) {
            ds_list_clear(_unidade.pontos_patrulha);
            show_debug_message("🔄 Patrulha cancelada por nova ordem de movimento.");
        }
        // ======================================================================
        
        // Mensagem adaptada ao tipo de unidade
        if (object_get_name(_unidade.object_index) == "obj_caca_f5") {
            show_debug_message("🎯 Ordem de movimento para F-5");
        } else if (object_get_name(_unidade.object_index) == "obj_lancha_patrulha") {
            show_debug_message("🎯 Ordem de movimento para Lancha Patrulha");
        }
    }
}

// --- COMANDO DE TESTE PARA LANCHA ---
if (keyboard_check_pressed(ord("T"))) {
    show_debug_message("🧪 === TESTE MANUAL DA LANCHA ===");
    scr_teste_lancha_patrulha();
}

// --- LÓGICA DE INPUT DO TECLADO ---
if (keyboard_check_pressed(ord("K")) && instance_exists(global.unidade_selecionada)) {
    // Tecla K só funciona para a unidade selecionada e que NÃO está em modo de definição
    // ✅ CORREÇÃO: Verificação direta e segura da variável global
    var _definindo_patrulha = noone;
    if (variable_global_exists("definindo_patrulha_unidade")) {
        _definindo_patrulha = global.definindo_patrulha_unidade;
    }
    
    if (_definindo_patrulha == noone) {
        // ✅ CORREÇÃO: Adicionar debug detalhado
        show_debug_message("🔍 DEBUG: Tentando ativar patrulha para: " + string(object_get_name(global.unidade_selecionada.object_index)));
        show_debug_message("🔍 DEBUG: Tem pontos_patrulha? " + string(variable_instance_exists(global.unidade_selecionada, "pontos_patrulha")));
        
        if (variable_instance_exists(global.unidade_selecionada, "pontos_patrulha")) {
            // ✅ CORREÇÃO: Usando função auxiliar segura para definir a variável
            global.definindo_patrulha_unidade = global.unidade_selecionada;
            ds_list_clear(global.definindo_patrulha_unidade.pontos_patrulha);
            show_debug_message("🎯 Modo PATRULHA ATIVADO para: " + string(object_get_name(global.unidade_selecionada.object_index)));
            show_debug_message("💡 INSTRUÇÕES: Clique esquerdo para adicionar pontos, direito para iniciar");
        } else {
            show_debug_message("❌ Esta unidade não suporta patrulha");
        }
    } else {
        show_debug_message("⚠️ Já existe uma unidade em modo patrulha");
    }
} else {
    if (!instance_exists(global.unidade_selecionada)) {
        show_debug_message("❌ Nenhuma unidade selecionada");
    }
}

// --- CONTROLES DE CÂMERA ---
mouse_x_previous = window_mouse_get_x();
mouse_y_previous = window_mouse_get_y();




