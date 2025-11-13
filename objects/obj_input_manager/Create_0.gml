// Evento Create de obj_input_manager (VERSÃO SISTEMA DUAL)

// ✅ DEBUG: Confirmar que Create está sendo executado
show_debug_message("🎮 obj_input_manager CREATE executado! Room: " + room_get_name(room) + " | Instance ID: " + string(id));

// Inicializar variáveis globais se não existirem
if (!variable_global_exists("modo_construcao")) {
    global.modo_construcao = false;
    show_debug_message("⚠️ global.modo_construcao inicializado como false");
}
if (!variable_global_exists("menu_pesquisa_aberto")) {
    global.menu_pesquisa_aberto = false;
    show_debug_message("⚠️ global.menu_pesquisa_aberto inicializado como false");
}

// Configuração da câmera (sem alterações)
view_enabled = true;
view_visible[0] = true;
camera = camera_create_view(0, 0, room_width, room_height);
view_set_camera(0, camera);
camera_x = room_width / 2;
camera_y = room_height / 2;
// ✅ Zoom inicial fixo em 3.5 (muito próximo)
zoom_level = 3.5;
camera_speed = 50; // ✅ Aumentado drasticamente para resposta muito mais rápida

// Variáveis de controle
mouse_x_previous = window_mouse_get_x();
mouse_y_previous = window_mouse_get_y();

// ✅ CORREÇÃO GM2016: Declarar variáveis de cache no Create event
cam_cache_w = -1;
cam_cache_h = -1;

// Nossas variáveis de estado
global.construindo_edificio = noone; // Guarda a instância do "fantasma"
global.definindo_patrulha = noone; // Unidade definindo patrulha
global.unidade_selecionada = noone; // Unidade atualmente selecionada

// ✅ NOVO: Variáveis para duplo clique e seleção por área
ultimo_clique_tempo = 0;
ultimo_clique_obj = noone;
selecionando_area = false;
inicio_selecao_x = 0;
inicio_selecao_y = 0;
tempo_duplo_clique = 0.3; // 300ms para considerar duplo clique
mouse_foi_soltou_este_frame = false; // Flag para rastrear se mouse foi solto neste frame
mouse_pressionado_frame_anterior = false; // Rastrear estado anterior do mouse

show_debug_message("✅ obj_input_manager inicializado completamente");
