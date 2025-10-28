/// @description Lógica do Canhão
// ===============================================
// HEGEMONIA GLOBAL - CANHÃO DA INDEPENDENCE
// Sistema de Rotações e Posicionamento
// ===============================================

// === VERIFICAR NAVIO PAI ===
if (!instance_exists(navio_pai)) {
    instance_destroy();
    exit;
}

// === ATUALIZAR POSIÇÃO ===
// Usar lengthdir para acompanhar rotação do navio
x = navio_pai.x + lengthdir_x(offset_x, navio_pai.image_angle);
y = navio_pai.y + lengthdir_y(offset_y, navio_pai.image_angle);

// === ROTAÇÃO DO CANHÃO ===
// Se o navio tem alvo, rotacionar canhão para o alvo
if (variable_instance_exists(navio_pai, "alvo_unidade") && instance_exists(navio_pai.alvo_unidade)) {
    angulo_alvo = point_direction(x, y, navio_pai.alvo_unidade.x, navio_pai.alvo_unidade.y);
} else {
    // Se não tem alvo, seguir a direção do navio
    angulo_alvo = navio_pai.image_angle;
}

// Rotação suave do canhão
image_angle = angle_difference(image_angle, angulo_alvo) * -velocidade_rotacao + image_angle;

// === CONFIGURAÇÕES VISUAIS ===
// Efeito de brilho quando atirando
if (variable_instance_exists(navio_pai, "metralhadora_ativa") && navio_pai.metralhadora_ativa) {
    image_blend = c_yellow;
    image_alpha = 0.9;
} else {
    image_blend = c_white;
    image_alpha = 1.0;
}