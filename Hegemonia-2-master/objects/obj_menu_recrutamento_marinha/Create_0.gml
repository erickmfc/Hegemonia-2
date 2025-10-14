// ===============================================
// HEGEMONIA GLOBAL - MENU DE RECRUTAMENTO NAVAL
// Sistema de Interface Naval Integrado
// ===============================================

show_debug_message("🚀 CREATE EVENT EXECUTANDO - Menu ID: " + string(id));

// Configurações do menu
meu_quartel_id = noone;
unidade_selecionada = 0;

// Configurações visuais
largura_menu = 300;
altura_menu = 250;
pos_x = 50;
pos_y = 50;

// === VERIFICAÇÃO E INICIALIZAÇÃO DE VARIÁVEIS GLOBAIS ===
if (!variable_global_exists("ui_scale")) {
    global.ui_scale = 1.2;
    show_debug_message("⚠️ ui_scale criado: " + string(global.ui_scale));
}

if (!variable_global_exists("text_quality")) {
    global.text_quality = "high";
    show_debug_message("⚠️ text_quality criado: " + string(global.text_quality));
}

if (!variable_global_exists("dinheiro")) {
    global.dinheiro = 1000;
    show_debug_message("⚠️ dinheiro criado: " + string(global.dinheiro));
}

// === VERIFICAÇÃO DE FUNÇÕES ===
// Função function_exists pode não estar disponível em todas as versões
// Assumir que scr_desenhar_texto_ui existe e usar fallback se necessário
show_debug_message("✅ scr_desenhar_texto_ui será verificado durante o uso");

show_debug_message("✅ Menu de Recrutamento Naval criado com sucesso!");
show_debug_message("Menu ID: " + string(id));
show_debug_message("Posição: (" + string(x) + ", " + string(y) + ")");
show_debug_message("Display: " + string(display_get_gui_width()) + "x" + string(display_get_gui_height()));