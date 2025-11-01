// =============================================
// LOOP PRINCIPAL DE DEACTIVATION
// Sistema complementar ao scr_manage_instance_lod()
// Foca em estatísticas e LOD detalhado por objeto
// =============================================

// Verificar se sistema está habilitado
if (!system_enabled || !variable_global_exists("map_width")) {
    exit;
}

// ✅ IMPORTANTE: Este sistema trabalha JUNTO com scr_manage_instance_lod()
// scr_manage_instance_lod() faz a deactivation rápida a cada 5 frames
// Este objeto faz verificação detalhada com estatísticas a cada 30 frames

// Atualizar timer
timer_check--;
if (timer_check > 0) {
    exit; // Ainda não é hora de verificar
}

// Resetar timer
timer_check = check_interval;

// === OBTER INFORMAÇÕES DA CÂMERA ===
var cam = view_camera[0];
if (cam == noone) {
    current_camera = noone;
    exit;
}

current_camera = cam;
cam_x = camera_get_view_x(cam);
cam_y = camera_get_view_y(cam);
cam_w = camera_get_view_width(cam);
cam_h = camera_get_view_height(cam);

// Calcular área de ativação (viewport + margem)
var activate_x1 = cam_x - margin_padding;
var activate_y1 = cam_y - margin_padding;
var activate_x2 = cam_x + cam_w + margin_padding;
var activate_y2 = cam_y + cam_h + margin_padding;

// === OBTER ZOOM ATUAL ===
var current_zoom = 1.0;
if (instance_exists(obj_input_manager)) {
    current_zoom = obj_input_manager.zoom_level;
}

// === PROCESSAR CADA TIPO DE OBJETO ===
for (var i = 0; i < array_length(managed_objects); i++) {
    var obj_type = managed_objects[i];
    
    // ✅ CORREÇÃO GM1041: Verificar se é um objeto válido
    // Verificar tipo do asset e se o objeto existe
    if (asset_get_type(obj_type) != asset_object || !object_exists(obj_type)) {
        continue; // Pular se não é um objeto válido ou não existe
    }
    
    // === VERIFICAR TODAS AS INSTÂNCIAS DESTE TIPO ===
    with (obj_type) {
        // Pular se já está marcado como sempre ativo
        if (variable_instance_exists(id, "force_always_active") && force_always_active) {
            instance_activate_object(id); // Garantir que está ativo
            continue; // Sempre ativo (ex: jogador selecionado)
        }
        
        // Verificar se está dentro da área de ativação
        var _inside_area = (x >= activate_x1 && x <= activate_x2 &&
                           y >= activate_y1 && y <= activate_y2);
        
        // === LÓGICA DE ATIVAÇÃO/DESATIVAÇÃO ===
        if (_inside_area) {
            // Dentro da área - ATIVAR instância
            // ✅ CORREÇÃO: GameMaker não tem variável 'active'
            // Ativar instância (é seguro chamar mesmo se já estiver ativa)
            instance_activate_object(id);
            
            // Contar ativações apenas na primeira vez ou quando flag muda
            if (!variable_instance_exists(id, "_deactivation_flag") || !id._deactivation_flag) {
                obj_deactivation_manager.stats_activated++;
                id._deactivation_flag = true;
            }
            
            if (variable_instance_exists(id, "visible")) {
                visible = true;
            }
            
            // === SINCRONIZAR LOD LEVEL COM FRAME SKIP ===
            // Garantir que lod_level está atualizado para o sistema de frame skip
            // Usar script otimizado scr_get_lod_level()
            var current_lod = scr_get_lod_level();
            
            if (!variable_instance_exists(id, "lod_level")) {
                lod_level = current_lod;
            } else {
                lod_level = current_lod; // Atualizar sempre
            }
            
            // Habilitar frame skip automaticamente em zoom afastado
            if (current_lod <= 1) {
                if (!variable_instance_exists(id, "skip_frames_enabled")) {
                    skip_frames_enabled = true;
                } else {
                    skip_frames_enabled = true; // Sempre habilitar se LOD baixo
                }
            }
            
        } else {
            // Fora da área - DESATIVAR se estiver ativo
            // ✅ CORREÇÃO: Acessar variáveis do manager usando obj_deactivation_manager
            var _manager_cam_x = obj_deactivation_manager.cam_x;
            var _manager_cam_y = obj_deactivation_manager.cam_y;
            var _manager_cam_w = obj_deactivation_manager.cam_w;
            var _manager_cam_h = obj_deactivation_manager.cam_h;
            var _distance = point_distance(x, y, _manager_cam_x + _manager_cam_w/2, _manager_cam_y + _manager_cam_h/2);
            
            // Só desativar se estiver realmente longe
            // ✅ CORREÇÃO: Verificar se pode desativar (não desativar se force_always_active)
            var _activation_distance = obj_deactivation_manager.activation_distance;
            if (_distance > _activation_distance) {
                // Verificar se não é uma instância crítica
                var _can_deactivate = true;
                if (variable_instance_exists(id, "force_always_active") && force_always_active) {
                    _can_deactivate = false;
                }
                
                if (_can_deactivate) {
                    var _was_active = (variable_instance_exists(id, "_deactivation_flag") && id._deactivation_flag);
                    instance_deactivate_object(id);
                    
                    if (_was_active) {
                        obj_deactivation_manager.stats_deactivated++;
                        id._deactivation_flag = false; // Limpar flag
                    }
                    
                    if (variable_instance_exists(id, "visible")) {
                        visible = false; // Esconder também
                    }
                }
            }
        }
    }
}

// Atualizar estatísticas
stats_check_count++;

// Debug periódico
if (variable_global_exists("debug_enabled") && global.debug_enabled && stats_check_count mod 300 == 0) {
    show_debug_message("📊 Deactivation: +" + string(stats_activated) + " / -" + string(stats_deactivated));
    stats_activated = 0; // Resetar contadores
    stats_deactivated = 0;
}
