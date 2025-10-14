// Efeito de desaparecer (fade out)
timer_atual++;
if (timer_atual >= timer_duracao) {
    instance_destroy();
} else {
    image_alpha -= 1 / timer_duracao;
}