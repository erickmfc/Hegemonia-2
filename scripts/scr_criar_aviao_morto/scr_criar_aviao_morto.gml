/// @description Cria um objeto de avião morto na posição especificada
/// @param {real} pos_x Posição X onde o avião caiu
/// @param {real} pos_y Posição Y onde o avião caiu
/// @param {real} angulo Ângulo do avião quando foi destruído
/// @param {real} sprite_id ID do sprite do avião (opcional, pode ser noone)
/// @return {instance} ID da instância criada ou noone

function scr_criar_aviao_morto(pos_x, pos_y, angulo, sprite_id = noone) {
    // Verificar se o objeto existe
    if (!object_exists(obj_aviao_morto)) {
        show_debug_message("⚠️ obj_aviao_morto não existe!");
        return noone;
    }
    
    // Criar instância do avião morto
    var _aviao_morto = instance_create_layer(pos_x, pos_y, "Instances", obj_aviao_morto);
    
    if (instance_exists(_aviao_morto)) {
        // Configurar posição e ângulo
        _aviao_morto.x = pos_x;
        _aviao_morto.y = pos_y;
        _aviao_morto.image_angle = angulo;
        
        // Se sprite foi fornecido, usar ele
        if (sprite_id != noone && sprite_exists(sprite_id)) {
            _aviao_morto.sprite_index = sprite_id;
        }
        // Caso contrário, usar sprite padrão do objeto
        
        return _aviao_morto;
    }
    
    return noone;
}
