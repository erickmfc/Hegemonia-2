/// @description Verifica se objeto está visível na tela (com margem)
/// @param {Id.Instance} _obj ID da instância
/// @param {real} _margin Margem extra (pixels)
/// @return {bool} true se está visível, false caso contrário

function scr_is_on_screen(_obj, _margin = 32) {
    
    if (!instance_exists(_obj)) return false;
    
    var cam = view_camera[0];
    if (cam == noone) return true; // Sem câmera = assumir visível
    
    var cam_x = camera_get_view_x(cam);
    var cam_y = camera_get_view_y(cam);
    var cam_w = camera_get_view_width(cam);
    var cam_h = camera_get_view_height(cam);
    
    // Verificar se está dentro da área visível (com margem)
    var obj_x = _obj.x;
    var obj_y = _obj.y;
    
    // Obter tamanho do objeto (bbox ou estimativa)
    var obj_w = 32; // Default
    var obj_h = 32; // Default
    
    if (variable_instance_exists(_obj, "bbox_right") && variable_instance_exists(_obj, "bbox_left")) {
        obj_w = _obj.bbox_right - _obj.bbox_left;
        obj_h = _obj.bbox_bottom - _obj.bbox_top;
    } else if (sprite_exists(_obj.sprite_index)) {
        obj_w = sprite_get_width(_obj.sprite_index);
        obj_h = sprite_get_height(_obj.sprite_index);
    }
    
    // Verificar interseção
    var left = cam_x - _margin;
    var right = cam_x + cam_w + _margin;
    var top = cam_y - _margin;
    var bottom = cam_y + cam_h + _margin;
    
    var obj_left = obj_x - obj_w/2;
    var obj_right = obj_x + obj_w/2;
    var obj_top = obj_y - obj_h/2;
    var obj_bottom = obj_y + obj_h/2;
    
    // Verificar se há interseção
    return !(obj_right < left || obj_left > right || obj_bottom < top || obj_top > bottom);
}