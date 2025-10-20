// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO ULTRA-MODERNO
// Sistema de Mouse Atualizado para Layout Único
// ===============================================

// Prevenir fechamento imediato (evita bug de duplo clique)
if (delay_abertura > 0) {
    if (global.debug_enabled) show_debug_message("Menu ainda em delay de abertura. Ignorando clique.");
    return;
}

// USAR COORDENADAS GUI PARA COMPATIBILIDADE COM ZOOM
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);

if (global.debug_enabled) {
    show_debug_message("=== CLIQUE DETECTADO NO MENU MELHORADO ===");
    show_debug_message("Posição do mouse: (" + string(_mouse_gui_x) + ", " + string(_mouse_gui_y) + ")");
}

// === DIMENSÕES DO MENU MELHORADO (IGUAIS AO DRAW GUI) ===
var _mw = 1430; // Largura aumentada em 25%
var _mh = 786;  // Altura aumentada em 25%
var _mx = (display_get_gui_width() - _mw) / 2;
var _my = (display_get_gui_height() - _mh) / 2;

// === 1. VERIFICAR BOTÃO FECHAR PRIMEIRO ===
var _close_w = 114; // +25% de 91px
var _close_h = 36;  // +25% de 29px
var _close_x = _mx + _mw - _close_w - 20;
var _close_y = _my + _mh - 58 + 10; // Footer ajustado (+25%)

if (_mouse_gui_x >= _close_x && _mouse_gui_x <= _close_x + _close_w &&
    _mouse_gui_y >= _close_y && _mouse_gui_y <= _close_y + _close_h) {
    
    if (global.debug_enabled) show_debug_message("Botão FECHAR clicado - fechando menu");
    global.menu_recrutamento_aberto = false;
    instance_destroy();
    return;
}

// === 2. VERIFICAR CLIQUE FORA DO MENU ===
if (_mouse_gui_x < _mx || _mouse_gui_x > _mx + _mw ||
    _mouse_gui_y < _my || _mouse_gui_y > _my + _mh) {
    
    if (global.debug_enabled) show_debug_message("Clique fora do menu - fechando");
    global.menu_recrutamento_aberto = false;
    instance_destroy();
    return;
}

// === 3. VERIFICAR CLIQUE NOS CARDS DAS UNIDADES ===
var _header_h = 90; // Altura ajustada (+25%)
var _info_w = 358; // Largura aumentada em 25%
var _info_x = _mx + _mw - _info_w - 20;
var _grid_x = _mx + 20; // Centralizado para novo layout
var _grid_y = _my + _header_h + 30;
var _grid_w = _mw - 40; // Margem ajustada para layout centralizado
var _grid_h = _mh - _header_h - 92; // Footer ajustado (+25%)

// Cards reorganizados
var _card_w = 300;  // Cards reorganizados
var _card_h = 200;  // Altura ajustada
var card_spacing_x = 40; // Espaçamento horizontal
var card_spacing_y = 30; // Espaçamento vertical

// Obter unidades disponíveis
var _unidades = [];
if (instance_exists(id_do_quartel)) {
    _unidades = id_do_quartel.unidades_disponiveis;
}

// Verificar clique em cada card
for (var i = 0; i < min(4, ds_list_size(_unidades)); i++) {
    var _unidade = ds_list_find_value(_unidades, i);
    var _row = i div 2;
    var _col = i mod 2;
    
    var _card_x = _grid_x + _col * (_card_w + card_spacing_x);
    var _card_y = _grid_y + _row * (_card_h + card_spacing_y);
    
    // Todos os cards descem 35%
    _card_y += _card_h * 0.35; // Descer 35% da altura do card
    
    // Cards de infantaria e soldado anti sobem 25%
    if (_unidade.nome == "Infantaria" || _unidade.nome == "Soldado Antiaéreo") {
        _card_y -= _card_h * 0.25; // Subir 25% da altura do card
    }
    
    // Verificar se o clique foi no card
    if (_mouse_gui_x >= _card_x && _mouse_gui_x <= _card_x + _card_w &&
        _mouse_gui_y >= _card_y && _mouse_gui_y <= _card_y + _card_h) {
        
        if (global.debug_enabled) {
            show_debug_message("*** CARD DA UNIDADE " + string(i) + " CLICADO ***");
            show_debug_message("Unidade: " + _unidade.nome);
        }
        
        // Verificar se pode recrutar
        var _can_afford = (global.dinheiro >= _unidade.custo_dinheiro && global.populacao >= _unidade.custo_populacao);
        var _quartel_livre = (!instance_exists(id_do_quartel) || !id_do_quartel.esta_treinando);
        var _disponivel = _can_afford && _quartel_livre;
        
        if (_disponivel) {
            // Sistema de múltiplas unidades
            var _quantidade = 1; // Quantidade padrão
            
            // Verificar se Shift está pressionado para 5 unidades
            if (keyboard_check(vk_shift)) {
                _quantidade = 5;
                if (global.debug_enabled) show_debug_message("🚀 MODO RÁPIDO: Criando 5 unidades!");
            }
            // Verificar se Ctrl está pressionado para 10 unidades
            else if (keyboard_check(vk_control)) {
                _quantidade = 10;
                if (global.debug_enabled) show_debug_message("🚀 MODO MASSIVO: Criando 10 unidades!");
            }
            
            if (global.debug_enabled) show_debug_message("Recrutando " + string(_quantidade) + " unidades: " + _unidade.nome);
            
            // ✅ SISTEMA DE FILA - SEMPRE ADICIONAR À FILA
            if (instance_exists(id_do_quartel)) {
                if (global.debug_enabled) show_debug_message("Adicionando à fila de recrutamento - Quartel ID: " + string(id_do_quartel));
                
                // Adicionar múltiplas unidades à fila
                for (var j = 0; j < _quantidade; j++) {
                    // Adicionar à fila de recrutamento (nome correto da variável)
                    ds_queue_enqueue(id_do_quartel.fila_recrutamento, i); // Índice da unidade
                    
                    if (global.debug_enabled) show_debug_message("Unidade " + string(j+1) + "/" + string(_quantidade) + " adicionada à fila");
                }
                
                // Se não está treinando, iniciar produção
                if (!id_do_quartel.esta_treinando) {
                    with (id_do_quartel) {
                        event_perform(ev_other, ev_user0); // Iniciar produção
                    }
                }
                
                // Ativar animação de confirmação
                recruitment_confirmation = true;
                confirmation_timer = 30; // 30 frames de animação
                confirmation_text = string(_quantidade) + "x " + _unidade.nome + " adicionado à fila!";
                confirmation_color = make_color_rgb(50, 205, 50);
                
                if (global.debug_enabled) show_debug_message("✅ " + string(_quantidade) + " unidades adicionadas à fila de produção!");
            } else {
                if (global.debug_enabled) show_debug_message("ERRO: Quartel não encontrado (ID: " + string(id_do_quartel) + ")");
            }
        } else {
            if (!_can_afford) {
                if (global.debug_enabled) show_debug_message("Recursos insuficientes para recrutar " + _unidade.nome);
            } else {
                if (global.debug_enabled) show_debug_message("Quartel ocupado - não é possível recrutar agora");
            }
        }
        return;
    }
}

// === 4. CLIQUE EM QUALQUER OUTRO LUGAR DENTRO DO PAINEL ===
if (global.debug_enabled) show_debug_message("Clique dentro do painel, mas fora dos elementos interativos");
// Manter o menu aberto
