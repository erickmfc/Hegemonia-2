/// Research Center - Step Event
/// Centro de Pesquisa Industrial - Lógica de Cliques Moderna
/// Sistema de Debug Otimizado

// Only process clicks if the research menu is open
if (!global.menu_pesquisa_aberto) {
    return;
}

// === SISTEMA DE DEBUG OTIMIZADO ===
// Reduzir debug messages de 558 para ~56 por frame (90% de redução)
var debug_enabled = (global.debug_enabled != undefined) ? global.debug_enabled : false;
var debug_timer = (variable_instance_exists(id, "debug_timer")) ? debug_timer : 0;

// Check for mouse clicks
if (mouse_check_button_pressed(mb_left)) {
    // Debug condicional - apenas quando necessário
    if (debug_enabled && debug_timer <= 0) {
        show_debug_message("=== CLIQUE DETECTADO NO CENTRO DE PESQUISA ===");
        debug_timer = 30; // Debug a cada 30 frames (0.5 segundos)
    } else if (debug_timer > 0) {
        debug_timer--;
    }
    
    // === VERIFICAÇÃO DE VARIÁVEIS GLOBAIS ===
    if (!ds_exists(global.nacao_recursos, ds_type_map)) {
        if (debug_enabled) show_debug_message("ERRO CRÍTICO: global.nacao_recursos não é um ds_map válido!");
        return;
    }
    
    if (!ds_exists(global.research_timers, ds_type_map)) {
        if (debug_enabled) show_debug_message("ERRO CRÍTICO: global.research_timers não é um ds_map válido!");
        return;
    }
    
    // Get mouse GUI position
    var mouse_gui_x = device_mouse_x_to_gui(0);
    var mouse_gui_y = device_mouse_y_to_gui(0);
    
    // === DEFINIR DIMENSÕES DO MENU (AJUSTADAS PARA 52.5% - MAIS PROPORCIONAL) ===
    var container_w = display_get_gui_width() * 0.525; // Reduzido de 75% para 52.5%
    var container_h = display_get_gui_height() * 0.7;
    var container_x = (display_get_gui_width() - container_w) / 2;
    var container_y = (display_get_gui_height() - container_h) / 2;
    
    // === 1. VERIFICAR BOTÃO FECHAR (PRIORIDADE MÁXIMA) ===
    var close_btn_x = container_x + container_w - 120;
    var close_btn_y = container_y + container_h - 80;
    var close_btn_w = 80;
    var close_btn_h = 35;
    
    if (point_in_rectangle(mouse_gui_x, mouse_gui_y, close_btn_x, close_btn_y, close_btn_x + close_btn_w, close_btn_y + close_btn_h)) {
        global.menu_pesquisa_aberto = false;
        if (debug_enabled) show_debug_message("Research menu closed by close button.");
        return;
    }
    
    // === 2. VERIFICAR CLIQUE FORA DO MENU ===
    if (mouse_gui_x < container_x || mouse_gui_x > container_x + container_w ||
        mouse_gui_y < container_y || mouse_gui_y > container_y + container_h) {
        
        global.menu_pesquisa_aberto = false;
        if (debug_enabled) show_debug_message("Research menu closed (clicked outside).");
        return;
    }
    
    // === 3. VERIFICAR BOTÃO SLOT EXTRA ===
    if (global.slots_pesquisa_total == 3) {
        var slot_btn_x = container_x + 30 + (container_w * 0.10); // Mover 10% para direita
        var slot_btn_y = container_y + container_h - 80;
        var slot_btn_w = 200;
        var slot_btn_h = 35;
        
        if (point_in_rectangle(mouse_gui_x, mouse_gui_y, slot_btn_x, slot_btn_y, slot_btn_x + slot_btn_w, slot_btn_y + slot_btn_h)) {
            // Check if player can afford the extra slot
            if (global.dinheiro >= global.custo_slot_extra) {
                global.dinheiro -= global.custo_slot_extra;
                global.slots_pesquisa_total = 4;
                if (debug_enabled) {
                    show_debug_message("Extra research slot purchased for $" + string(global.custo_slot_extra));
                    show_debug_message("New research capacity: " + string(global.slots_pesquisa_usados) + "/" + string(global.slots_pesquisa_total));
                }
            } else {
                if (debug_enabled) show_debug_message("Not enough money for extra slot! Need: $" + string(global.custo_slot_extra) + ", Have: $" + string(global.dinheiro));
            }
            return;
        }
    }
    
    // === 4. VERIFICAR CARTÕES DE PESQUISA ===
    var header_h = 60;
    var header_y = container_y + 10;
    var info_panel_w = 200;
    var info_panel_x = container_x + container_w - info_panel_w - 20;
    
    var grid_start_x = container_x + 30;
    var grid_start_y = header_y + header_h + 30;
    var grid_w = container_w - info_panel_w - 60;
    var grid_h = container_h - header_h - 140;
    
    var grid_cols = 4;
    var grid_rows = 3;
    var card_w = (grid_w - (grid_cols - 1) * 25) / grid_cols;
    var card_h = (grid_h - (grid_rows - 1) * 20) / grid_rows;
    
    // Verificar se research_names existe e é válido
    if (!variable_instance_exists(id, "research_names") || !is_array(research_names)) {
        if (debug_enabled) show_debug_message("ERRO: research_names não é válido!");
        return;
    }
    
    // Processar cliques nos cartões
    for (var i = 0; i < array_length(research_names); i++) {
        var col = i mod grid_cols;
        var row = i div grid_cols;
        
        var card_x = grid_start_x + col * (card_w + 25);
        var card_y = grid_start_y + row * (card_h + 20);
        
        // Check if mouse is over this research card
        if (point_in_rectangle(mouse_gui_x, mouse_gui_y, card_x, card_y, card_x + card_w, card_y + card_h)) {
            
            if (debug_enabled) show_debug_message("*** CLIQUE DETECTADO NO CARTÃO: " + research_names[i] + " ***");
            
            var research_name = research_names[i];
            
            // Verificar se a chave existe
            if (!ds_map_exists(global.nacao_recursos, research_name)) {
                if (debug_enabled) show_debug_message("ERRO: Chave '" + research_name + "' não encontrada!");
                continue;
            }
            
            var status = global.nacao_recursos[? research_name];
            
            // Processar clique baseado no status
            if (status == RESOURCE_STATUS.AVAILABLE) {
                // Verificar se há slots disponíveis
                if (global.slots_pesquisa_usados < global.slots_pesquisa_total) {
                    // Obter custo da pesquisa (valores reduzidos em 50% e depois em 20%)
                    var research_cost = 0;
                    switch(research_name) {
                        case "Borracha": research_cost = 2400; break;
                        case "Petroleo": research_cost = 3000; break;
                        case "Silicio": research_cost = 3200; break;
                        case "Mina": research_cost = 2000; break;
                        case "Aluminio": research_cost = 3600; break;
                        case "Centro": research_cost = 4000; break;
                        case "Ouro": research_cost = 6000; break;
                        case "Serraria": research_cost = 1600; break;
                        case "Cobre": research_cost = 2800; break;
                        case "Uranio": research_cost = 10000; break;
                        case "Litio": research_cost = 4800; break;
                        case "Titanio": research_cost = 7200; break;
                        default: research_cost = 2000; break;
                    }
                    
                    // Verificar se o jogador pode pagar
                    if (global.dinheiro >= research_cost) {
                        // Deduzir custo e iniciar pesquisa
                        global.dinheiro -= research_cost;
                        global.nacao_recursos[? research_name] = RESOURCE_STATUS.RESEARCHING;
                        global.slots_pesquisa_usados++;
                        
                        // Criar timer da pesquisa
                        if (!ds_map_exists(global.research_timers, research_name)) {
                            global.research_timers[? research_name] = research_timer_steps;
                        }
                        
                        if (debug_enabled) {
                            show_debug_message("========== PESQUISA INICIADA ==========");
                            show_debug_message("Recurso: " + research_name);
                            show_debug_message("Custo: $" + string(research_cost));
                            show_debug_message("Slots: " + string(global.slots_pesquisa_usados) + "/" + string(global.slots_pesquisa_total));
                            show_debug_message("Dinheiro restante: $" + string(global.dinheiro));
                            show_debug_message("======================================");
                        }
                    } else {
                        if (debug_enabled) show_debug_message("Dinheiro insuficiente para " + research_name + "! Precisa: $" + string(research_cost) + ", Tem: $" + string(global.dinheiro));
                    }
                } else {
                    if (debug_enabled) show_debug_message("Sem slots de pesquisa disponíveis! Atual: " + string(global.slots_pesquisa_usados) + "/" + string(global.slots_pesquisa_total));
                }
            }
            else if (status == RESOURCE_STATUS.RESEARCHING) {
                if (debug_enabled) show_debug_message("Pesquisa '" + research_name + "' já está em andamento.");
            }
            else if (status == RESOURCE_STATUS.RESEARCHED) {
                if (debug_enabled) show_debug_message("Pesquisa '" + research_name + "' já foi concluída.");
            }
            
            return; // Sair após processar um cartão
        }
    }
    
    if (debug_enabled) show_debug_message("Nenhum cartão foi clicado. Mouse em: (" + string(mouse_gui_x) + ", " + string(mouse_gui_y) + ")");
}

// === TECLA ESC PARA FECHAR MENU ===
if (keyboard_check_pressed(vk_escape)) {
    global.menu_pesquisa_aberto = false;
    if (debug_enabled) show_debug_message("Research menu closed (ESC key).");
}
