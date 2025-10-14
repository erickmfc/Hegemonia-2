// Evento Create de obj_input_manager (VERSÃO SISTEMA DUAL)

// Configuração da câmera (sem alterações)
view_enabled = true;
view_visible[0] = true;
camera = camera_create_view(0, 0, room_width, room_height);
view_set_camera(0, camera);
camera_x = room_width / 2;
camera_y = room_height / 2;
zoom_level = 1.0;
camera_speed = 15;

// Variáveis de controle
mouse_x_previous = window_mouse_get_x();
mouse_y_previous = window_mouse_get_y();

// Nossas variáveis de estado
global.construindo_edificio = noone; // Guarda a instância do "fantasma"
global.definindo_patrulha = noone; // Unidade definindo patrulha
global.unidade_selecionada = noone; // Unidade atualmente selecionada
