// ========================================
// OBJETO: obj_quartel_marinha
// EVENTO: Left Pressed
// ========================================

// Quando o quartel marinha é clicado, mostra informações e permite interação
show_message("Quartel Marinha selecionado!");
show_debug_message("Quartel Marinha foi clicado em: " + string(x) + ", " + string(y));

// Define este quartel como selecionado (para outras funcionalidades)
global.selected_quartel_marinha = id;

// Aqui você pode adicionar funcionalidades como:
// - Abrir menu de construção de navios
// - Mostrar informações do quartel
// - Ativar modo de seleção de unidades navais
// - Etc.

// Exemplo de funcionalidade básica - mostrar informações do quartel:
var info_text = "=== QUARTEL MARINHA ===\n";
info_text += "Posição: " + string(x) + ", " + string(y) + "\n";
info_text += "Status: Ativo\n";
info_text += "Capacidade: Disponível\n";
info_text += "\nClique em 'OK' para continuar...";

show_message(info_text);

// Se você quiser que o quartel abra um menu quando clicado:
/*
if (instance_exists(obj_menu_construcao_naval)) {
    obj_menu_construcao_naval.visible = true;
    obj_menu_construcao_naval.active = true;
} else {
    // Criar menu se não existir
    instance_create_layer(room_width/2, room_height/2, "UI", obj_menu_construcao_naval);
}
*/
