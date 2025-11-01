/// @description Processa movimento simplificado quando em frame skip
/// @param {Id.Instance} inst_id ID da instância (aceita qualquer tipo de instância)
/// @param {real} dest_x Destino X
/// @param {real} dest_y Destino Y
/// @param {real} speed Velocidade original
/// @param {real} speed_mult Multiplicador de velocidade

function scr_process_lod_simple_movement(inst_id, dest_x, dest_y, speed, speed_mult) {
    
    // ✅ CORREÇÃO GM1041: Verificar se inst_id é uma instância válida
    // Aceita qualquer tipo de instância (Instance<obj_infantaria>, Instance<obj_tanque>, etc.)
    if (!instance_exists(inst_id)) return false;
    
    var dist = point_distance(inst_id.x, inst_id.y, dest_x, dest_y);
    var threshold = speed * speed_mult; // Threshold baseado na velocidade compensada
    
    if (dist > threshold) {
        // Mover em direção ao destino
        var dir = point_direction(inst_id.x, inst_id.y, dest_x, dest_y);
        inst_id.x += lengthdir_x(speed * speed_mult, dir);
        inst_id.y += lengthdir_y(speed * speed_mult, dir);
        inst_id.image_angle = dir;
        return true; // Ainda está se movendo
    } else {
        // Chegou ao destino (ou muito próximo)
        inst_id.x = dest_x;
        inst_id.y = dest_y;
        return false; // Parou
    }
}