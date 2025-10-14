/// Research Center - Mouse Event para Menu GUI
/// Centro de Pesquisa - Detecção de Clique Corrigida
/// Sistema de Coordenadas GUI Unificado

// Só processar cliques se o menu de pesquisa estiver aberto
if (!global.menu_pesquisa_aberto) {
    return;
}

// === SISTEMA DE DEBUG OTIMIZADO ===
var debug_enabled = (global.debug_enabled != undefined) ? global.debug_enabled : false;
var debug_timer = (variable_instance_exists(id, "debug_timer")) ? debug_timer : 0;

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

// === USAR COORDENADAS GUI PARA COMPATIBILIDADE ===
var mouse_gui_x = device_mouse_x_to_gui(0);
var mouse_gui_y = device_mouse_y_to_gui(0);

if (debug_enabled) {
    show_debug_message("Mouse GUI: (" + string(mouse_gui_x) + ", " + string(mouse_gui_y) + ")");
}

// === DEFINIR DIMENSÕES DO MENU (IGUAIS AO DRAW GUI) ===
var container_w = display_get_gui_width() * 0.525; // Mesmo do Draw
var container_h = display_get_gui_height() * 0.7;   // Mesmo do Draw
var container_x = (display_get_gui_width() - container_w) / 2;
var container_y = (display_get_gui_height() - container_h) / 2;

if (debug_enabled) {
    show_debug_message("Container: (" + string(container_x) + ", " + string(container_y) + ") Size: " + string(container_w) + "x" + string(container_h));
}

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
    var slot_btn_x = container_x + 30 + (container_w * 0.10); // Mesmo cálculo do Draw
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

// Calcular dimensões dos cartões (mesmo cálculo do Draw)
var cards_per_row = 2;
var card_w = (grid_w - 20) / cards_per_row;
var card_h = 120;
var card_spacing_x = 20;
var card_spacing_y = 15;

// Verificar cliques nos cartões de pesquisa
var research_items = [
    {id: "infantry_upgrade", name: "Infantaria Avançada", cost: 500, time: 300},
    {id: "tank_upgrade", name: "Tanque Moderno", cost: 1000, time: 600},
    {id: "navy_upgrade", name: "Marinha Fortificada", cost: 1500, time: 900},
    {id: "air_upgrade", name: "Força Aérea", cost: 2000, time: 1200}
];

for (var i = 0; i < array_length(research_items); i++) {
    var row = i div cards_per_row;
    var col = i mod cards_per_row;
    
    var card_x = grid_start_x + col * (card_w + card_spacing_x);
    var card_y = grid_start_y + row * (card_h + card_spacing_y);
    
    // Verificar se clique está dentro do cartão
    if (point_in_rectangle(mouse_gui_x, mouse_gui_y, card_x, card_y, card_x + card_w, card_y + card_h)) {
        var item = research_items[i];
        
        // Verificar se pode iniciar pesquisa
        if (global.slots_pesquisa_usados < global.slots_pesquisa_total) {
            if (global.dinheiro >= item.cost) {
                // Iniciar pesquisa
                global.dinheiro -= item.cost;
                global.slots_pesquisa_usados++;
                global.research_timers[? item.id] = item.time;
                
                if (debug_enabled) {
                    show_debug_message("Research started: " + item.name);
                    show_debug_message("Cost: $" + string(item.cost) + ", Time: " + string(item.time) + " frames");
                }
            } else {
                if (debug_enabled) show_debug_message("Not enough money for " + item.name + "! Need: $" + string(item.cost));
            }
        } else {
            if (debug_enabled) show_debug_message("No available research slots!");
        }
        return;
    }
}

// === 5. CLIQUE DENTRO DO MENU MAS FORA DOS ELEMENTOS ===
if (debug_enabled) show_debug_message("Click inside menu but outside interactive elements");
