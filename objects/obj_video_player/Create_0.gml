// Objeto para reproduzir vídeos no jogo
// Configurações iniciais do player de vídeo

// Variáveis de controle do vídeo
video_playing = false;
video_paused = false;
video_volume = 1.0;
video_current_time = 0;
video_duration = 0;
video_loop = false;
video_autoplay = false;
video_handle = -1;

// Variáveis de posição e tamanho
video_x = 0;
video_y = 0;
video_width = 800;
video_height = 600;

// Variáveis de controle de interface
show_controls = true;
controls_alpha = 0.8;
controls_timer = 0;
controls_show_time = 3.0; // segundos para mostrar controles

// Variáveis de estado
video_loaded = false;
video_error = false;
error_message = "";

// Configurações de teclas
key_play_pause = vk_space;
key_stop = vk_escape;
key_volume_up = vk_add;
key_volume_down = vk_subtract;

// Inicializar sistema de vídeo
if (!video_loaded) {
    // Carregar o vídeo menu.mp4
    video_handle = video_open("menu.mp4");
    if (video_handle != -1) {
        video_loaded = true;
        // video_duration não pode ser obtido diretamente, será atualizado durante reprodução
        video_duration = 0;
        show_debug_message("Vídeo menu.mp4 carregado com sucesso!");
    } else {
        video_error = true;
        error_message = "Erro ao carregar menu.mp4";
        show_debug_message("ERRO: Não foi possível carregar o vídeo menu.mp4");
    }
    
    show_debug_message("Player de vídeo inicializado. Use ESPAÇO para play/pause, ESC para parar.");
}