# Player de Vídeo - Instruções de Uso

## Objeto: obj_video_player

Este objeto foi criado para reproduzir o vídeo "menu.mp4" no seu jogo GameMaker Studio.

### **Funcionalidades:**

1. **Carregamento Automático**: O vídeo "menu.mp4" é carregado automaticamente quando o objeto é criado
2. **Controles de Reprodução**: Play, Pause, Stop com teclado e mouse
3. **Controle de Volume**: Ajuste de volume com teclas + e -
4. **Interface Visual**: Status em tempo real e controles visuais

### **Controles:**

#### **Teclado:**
- **ESPAÇO**: Play/Pause
- **ESC**: Parar vídeo
- **+**: Aumentar volume
- **-**: Diminuir volume

#### **Mouse:**
- **Clique na área do vídeo**: Play/Pause
- **Clique nos botões**: Controles visuais
- **Controles aparecem automaticamente** ao mover o mouse

### **Como Usar:**

1. **Adicione o objeto à sala**: Coloque `obj_video_player` em qualquer sala do jogo
2. **Posicione o vídeo**: O vídeo será exibido na posição (0,0) com tamanho 800x600
3. **Personalize se necessário**: Ajuste as variáveis no Create_0.gml

### **Variáveis Configuráveis:**

```gml
// Posição e tamanho
video_x = 0;           // Posição X
video_y = 0;           // Posição Y  
video_width = 800;     // Largura
video_height = 600;    // Altura

// Controle
video_loop = false;    // Repetir vídeo
video_volume = 1.0;   // Volume (0.0 a 1.0)
```

### **Arquivos Criados:**

#### **Objeto:**
- `objects/obj_video_player/obj_video_player.yy`
- `objects/obj_video_player/Create_0.gml`
- `objects/obj_video_player/Step_0.gml`
- `objects/obj_video_player/Draw_0.gml`
- `objects/obj_video_player/Mouse_4.gml`
- `objects/obj_video_player/KeyPress_32.gml`
- `objects/obj_video_player/KeyPress_27.gml`

#### **Scripts:**
- `scripts/scr_toggle_play_pause.gml`
- `scripts/scr_play_video.gml`
- `scripts/scr_stop_video.gml`
- `scripts/scr_restart_video.gml`
- `scripts/scr_set_volume.gml`
- `scripts/scr_draw_controls.gml`
- `scripts/scr_check_controls_click.gml`

### **Requisitos:**

1. **Arquivo de vídeo**: Certifique-se de que "menu.mp4" está na pasta do projeto
2. **Formato suportado**: MP4 (recomendado)
3. **GameMaker Studio**: Versão compatível com funções de vídeo

### **Status do Vídeo:**

- **REPRODUZINDO**: Vídeo em execução (verde)
- **PAUSADO**: Vídeo pausado (amarelo)
- **PARADO**: Vídeo parado (vermelho)

### **Troubleshooting:**

- Se o vídeo não carregar, verifique se o arquivo "menu.mp4" existe
- Verifique o console de debug para mensagens de erro
- Certifique-se de que o formato do vídeo é suportado pelo GameMaker Studio

### **Personalização:**

Para usar um vídeo diferente, altere no Create_0.gml:
```gml
video_handle = video_open("seu_video.mp4");
```
